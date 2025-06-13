import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
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

        // buatkan juga user profile di Firestore
        final user = auth.currentUser;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'nama': namaController.text.trim(),
          'email': email,
        });

        final box = GetStorage();
        box.write('dataParent', {
          'email': emailController.text,
          'password': passwordController.text,
        });

        Get.offNamed(Routes.CHOOSE_USER);
      } catch (e) {
        print("Error during registration: $e");
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
