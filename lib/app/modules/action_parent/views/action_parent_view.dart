import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/action_parent_controller.dart';

class ActionParentView extends GetView<ActionParentController> {
  const ActionParentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActionParentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ActionParentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
