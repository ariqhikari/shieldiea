import 'package:get/get.dart';

import '../controllers/choose_child_controller.dart';

class ChooseChildBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseChildController>(
      () => ChooseChildController(),
    );
  }
}
