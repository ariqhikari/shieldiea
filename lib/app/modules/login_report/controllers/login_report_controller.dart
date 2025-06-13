import 'dart:developer'; // untuk log()
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shieldiea/app/routes/app_pages.dart';
import 'package:shieldiea/app/shared/shared.dart';

class LoginReportController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  Future<void> loginToReportior() async {
    final box = GetStorage();
    final data = box.read("dataParent") as Map<String, dynamic>?;

    if (data == null || !data.containsKey("password")) {
      showSnackBar("Data parent not found");
      return;
    }

    try {
      isLoading.value = true;
      if (passwordController.text == data["password"]) {
        // update firestroe user token nya
        String? token = await getToken();

        final userId = _auth.currentUser?.uid;
        if (userId == null) return;

        await _firestore
            .collection('users')
            .doc(userId)
            .update({'token_fcm': token});

        Get.offAndToNamed(Routes.MAIN);
      } else {
        showSnackBar("Wrong password");
      }
    } catch (e) {
      showSnackBar("An error occurred: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> getToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token_firebase', token!);
      log("FCM $token");
      return token;
    } catch (e) {
      log("Error getting FCM token: $e");
      return null;
    }
  }

  Future<void> checkLogin(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    log("Token stored: $token");
  }
}
