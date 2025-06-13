import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shieldiea/app/data/child_model.dart';
import 'package:image/image.dart' as img;
import 'package:shieldiea/app/services/screen_capture.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ChooseChildController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final children = <ChildModel>[].obs;
  var isLoading = false.obs;
  var isUploading = false.obs;


  @override
  void onInit() async {
    super.onInit();
    await getChilds();

    // Handle enable/disable calls from AccessibilityService
    // _captureControlChannel.setMethodCallHandler((call) async {
    //   switch (call.method) {
    //     case 'enableCapture':
    //       print("[DEBUG] enableCapture dipanggil");
    //       await startStreaming();
    //       break;
    //     case 'disableCapture':
    //       print("[DEBUG] disableCapture dipanggil");
    //       stopStreaming();
    //       break;
    //   }
    // });
  }

  Future<void> getChilds() async {
    final box = GetStorage();
    final data = box.read("dataParent") as Map<String, dynamic>;
    // String accessToken = data["token"];

    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await _firestore
        .collection('children')
        .where('user_id', isEqualTo: userId)
        .get();

    children.value = snapshot.docs
        .map((doc) => ChildModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_firebase', token!);
    log("FCM $token");

    return token;
  }

  static const _captureControlChannel = MethodChannel('screen_capture');
  static const _overlayControlChannel = MethodChannel('overlay_control');

  final _sc = ScreenCapture();
  StreamSubscription? _subscription;

  var isMonitoring = false.obs;
  var lastJpeg = Rxn<Uint8List>();

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> initCapture() async {
    bool ok = await _sc.requestPermission();
    if (!ok) return;

    print("[DEBUG] Permission granted. Waiting for enableCapture...");
    startStreaming();
  }

  Future<void> requestCapturePermission() async {
    final ok = await _sc.requestPermission();
    if (!ok) return;
    isMonitoring.value = true;
  }

  Future<void> startStreaming() async {
    if (_subscription != null) return;
    _subscription = _sc.frameStream.listen(_processFrame);
  }

  Future<void> _processFrame(dynamic rawData) async {
    if (rawData is! Map) return;

    if (isUploading.value) {
      print('[DEBUG] Skip frame karena masih upload...');
      return;
    }

    try {
      isUploading.value = true;

      final rawMap = Map<String, dynamic>.from(rawData);
      final bytes = rawMap['bytes'] as Uint8List;
      final meta = Map<String, dynamic>.from(rawMap['metadata']);
      final w = meta['width'] as int;
      final h = meta['height'] as int;

      final frame = img.Image.fromBytes(
        width: w,
        height: h,
        bytes: bytes.buffer,
        order: img.ChannelOrder.rgba,
      );

      final preview = img.copyResize(frame, width: 360);
      final jpeg = Uint8List.fromList(img.encodeJpg(preview));

      print("[DEBUG] Frame received: ${jpeg.length} bytes, $w x $h");

      await uploadCapturedImage(jpeg); // tunggu upload selesai

      lastJpeg.value = jpeg;
    } catch (e) {
      print("Error processing frame: $e");
    } finally {
      isUploading.value = false;
    }
  }


  Future<void> uploadCapturedImage(Uint8List imageBytes) async {
    final uri = Uri.parse('https://balancebites.auroraweb.id/analyze');

    print('[UPLOAD] Mengunggah gambar ke $uri');

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) =>
                true; // abaikan SSL error

      final ioClient = IOClient(httpClient);

      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'capture.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));

      final streamedResponse = await ioClient.send(request);

      if (streamedResponse.statusCode == 200) {
        final responseBody = await streamedResponse.stream.bytesToString();
        print('[UPLOAD] Berhasil: $responseBody');
      } else {
        print('[UPLOAD] Gagal: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      print('[UPLOAD] Error: $e');
    }
  }

  void stopStreaming() {
    _subscription?.cancel();
    _subscription = null;
    _overlayControlChannel.invokeMethod('removeOverlay');
    isMonitoring.value = false;
    lastJpeg.value = null;
  }
}
