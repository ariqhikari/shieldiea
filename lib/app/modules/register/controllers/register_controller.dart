import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shieldiea/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();
  RxBool isLoading = false.obs;

  // register with firebase auth
  Future<void> registerWithFirebase() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final auth = FirebaseAuth.instance;
        final email = emailController.text.trim();
        final password = passwordController.text.trim();

        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        Get.offNamed(Routes.LOGIN);
      } catch (e) {
        Get.snackbar('Error', 'Registration failed: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confPasswordController.dispose();
    super.onClose();
  }
}
