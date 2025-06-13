import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Observable state
  var enablePornografi = false.obs;
  var enableKekerasan = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final doc = await _firestore.collection('settings').doc(userId).get();

    if (doc.exists) {
      final data = doc.data()!;
      enablePornografi.value = data['enable_porn'] ?? false;
      enableKekerasan.value = data['enable_kekerasan'] ?? false;
    }
  }

  Future<void> _updateSetting(String key, bool value) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('settings').doc(userId).set(
      {key: value},
      SetOptions(merge: true),
    );
  }

  void togglePornografi(bool value) {
    enablePornografi.value = value;
    _updateSetting('enable_porn', value);
  }

  void toggleKekerasan(bool value) {
    enableKekerasan.value = value;
    _updateSetting('enable_kekerasan', value);
  }
}
