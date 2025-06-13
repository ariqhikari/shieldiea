import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  final _sc = ScreenCapture();

  StreamSubscription? _subscription;
  var isMonitoring = false.obs;
  var lastJpeg = Rxn<Uint8List>();
  var isUploading = false.obs;

  static const _captureControlChannel = MethodChannel('screen_capture');
  static const _overlayControlChannel = MethodChannel('overlay_control');

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> toggleCapture() async {
    if (isMonitoring.value) {
      stopStreaming();
    } else {
      await initCapture();
    }
  }

  Future<void> initCapture() async {
    bool ok = await _sc.requestPermission();
    if (!ok) return;

    print("[DEBUG] Permission granted. Starting capture...");
    startStreaming();
  }

  Future<void> startStreaming() async {
    if (_subscription != null) return;
    _subscription = _sc.frameStream.listen(_processFrame);
    isMonitoring.value = true;
  }

  void stopStreaming() {
    _subscription?.cancel();
    _subscription = null;
    _overlayControlChannel.invokeMethod('removeOverlay');
    isMonitoring.value = false;
    lastJpeg.value = null;
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

      await uploadCapturedImage(jpeg);

      lastJpeg.value = jpeg;
    } catch (e) {
      print("Error processing frame: $e");
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> sendNotification() async {
    final url =
        Uri.parse('https://balancebites.auroraweb.id/send-notification');

    // get user fcm from firestore user
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    final doc = await _firestore.collection('users').doc(userId).get();

    final payload = {
      "token": doc.data()?['token_fcm'] ?? '',
      "title": "Konten Berbahaya Terdeteksi",
      "body":
          "Anak Anda mungkin melihat konten yang tidak pantas. Silakan periksa.",
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('[NOTIF] Berhasil mengirim notifikasi.');
      } else {
        print('[NOTIF] Gagal: ${response.statusCode}');
        print('[NOTIF] Response: ${response.body}');
      }
    } catch (e) {
      print('[NOTIF] Error: $e');
    }
  }

  Future<void> uploadCapturedImage(Uint8List imageBytes) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final doc = await _firestore.collection('settings').doc(userId).get();

    String url = 'https://balancebites.auroraweb.id/analyze?';

    if (doc.exists) {
      final data = doc.data()!;
      url += 'enablePorn=${data['enable_porn'] == true}&';
      url += 'enableKekerasan=${data['enable_kekerasan'] == true}';
    }

    final uri = Uri.parse(url);

    print('[UPLOAD] Mengunggah gambar ke $uri');

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

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

        // Cek apakah hasilnya "danger"
        if (responseBody.contains('danger')) {
          print('[DETECTION] Bahaya terdeteksi! Menampilkan overlay...');
          _overlayControlChannel.invokeMethod('showOverlay');
          await sendNotification();
        } else {
          print('[DETECTION] Aman. Menghapus overlay jika ada.');
          _overlayControlChannel.invokeMethod('removeOverlay');
        }
      } else {
        print('[UPLOAD] Gagal: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      print('[UPLOAD] Error: $e');
    }
  }
}
