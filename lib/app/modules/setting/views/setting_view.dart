import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Block Porn Content'),
              value: controller.enablePornografi.value,
              onChanged: controller.togglePornografi,
            ),
            SwitchListTile(
              title: const Text('Block Violence Content'),
              value: controller.enableKekerasan.value,
              onChanged: controller.toggleKekerasan,
            ),
          ],
        ),
      ),
    );
  }
}
