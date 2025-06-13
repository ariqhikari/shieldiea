import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_report_controller.dart';

class LoginReportView extends GetView<LoginReportController> {
  const LoginReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginReportView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LoginReportView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
