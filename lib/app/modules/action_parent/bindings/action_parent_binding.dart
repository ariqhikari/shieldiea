import 'package:get/get.dart';

import '../controllers/action_parent_controller.dart';

class ActionParentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActionParentController>(
      () => ActionParentController(),
    );
  }
}
