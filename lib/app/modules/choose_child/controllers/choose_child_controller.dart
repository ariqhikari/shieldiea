import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shieldiea/app/data/child_model.dart';
import 'package:shieldiea/app/routes/app_pages.dart';

class ChooseChildController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final children = <ChildModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getChilds();
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

  moveToDetection() async {
    String? token = await getToken();

    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await _firestore
        .collection('children')
        .where('user_id', isEqualTo: userId)
        .get();

    for (var doc in snapshot.docs) {
      await _firestore
          .collection('children')
          .doc(doc.id)
          .update({'token_fcm': token});
    }
    Get.offNamed(Routes.DETECTION);
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_firebase', token!);
    log("FCM $token");

    return token;
  }
}
