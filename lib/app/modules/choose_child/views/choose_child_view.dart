import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/choose_child_controller.dart';

class ChooseChildView extends GetView<ChooseChildController> {
  const ChooseChildView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChooseChildView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ChooseChildView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
