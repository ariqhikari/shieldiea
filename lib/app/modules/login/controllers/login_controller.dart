import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Future<String?> getToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('token_firebase', token!);

  //   return token;
  // }

  // create login with firebase auth
  Future<void> loginWithFirebase() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        // Import FirebaseAuth at the top: import 'package:firebase_auth/firebase_auth.dart';
        final auth = FirebaseAuth.instance;
        final email = emailController.text.trim();
        final password = passwordController.text.trim();

        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Optionally get the Firebase Messaging token
        // await getToken();

        // Navigate to home on successful login
        // Get.offNamed(Routes.HOME);
      } on FirebaseAuthException catch (e) {
        String message = 'Login failed';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        }
        Get.snackbar('Error', message);
      } catch (e) {
        Get.snackbar('Error', 'Login failed: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
