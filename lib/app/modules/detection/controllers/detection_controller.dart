import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:image/image.dart' as img;
import 'package:shieldiea/app/services/screen_capture.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class DetectionController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  var isUploading = false.obs;

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
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final doc = await _firestore.collection('settings').doc(userId).get();

    String url = 'https://balancebites.auroraweb.id/analyze?';

    if (doc.exists) {
      final data = doc.data()!;
      if (data['enable_porn'] == true) {
        url += 'enablePorn=true&';
      } else {
        url += 'enablePorn=false&';
      }
      if (data['enable_kekerasan'] == true) {
        url += 'enableKekerasan=true&';
      } else {
        url += 'enableKekerasan=false';
      }
    }

    final uri = Uri.parse(url);

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
