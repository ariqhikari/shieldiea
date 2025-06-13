import 'package:get/get.dart';

import '../controllers/login_report_controller.dart';

class LoginReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginReportController>(
      () => LoginReportController(),
    );
  }
}
