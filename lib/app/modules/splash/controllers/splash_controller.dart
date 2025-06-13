import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shieldiea/app/routes/app_pages.dart';

class SplashController extends GetxController {
  moveToHome() async {
    bool isLogin = await getCurrentUser();

    Future.delayed(const Duration(seconds: 2), () async {
      if (isLogin) {
        Get.offAllNamed(Routes.CHOOSE_USER);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  // get current user with firebase auth
  Future<bool> getCurrentUser() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      return true; // User is logged in
    } else {
      return false; // No user is logged in
    }
  }
}
