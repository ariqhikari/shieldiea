import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shieldiea/app/shared/shared.dart';
import 'package:shieldiea/app/widgets/widgets.dart';

import '../controllers/login_report_controller.dart';

class LoginReportView extends GetView<LoginReportController> {
  const LoginReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: whiteColor,
          body: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // * Heading
                  Stack(
                    children: [
                      // * Background Circle
                      Image.asset(
                        "assets/images/bg_circle.png",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 350
                            : MediaQuery.of(context).size.height / 2,
                        fit: BoxFit.fill,
                      ),
                      // * Title
                      Center(
                        child: Column(
                          children: [
                            // * Title
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 7),
                            Image.asset(
                              "assets/images/logo.png",
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Shieldiea",
                              textAlign: TextAlign.center,
                              style: headingPrimaryFontStyle,
                            ),
                            Text(
                              "Protecting Young Explorers Online",
                              textAlign: TextAlign.center,
                              style: headingSecondaryFontStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // * Choose User
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        // * Password
                        Text(
                          'Password',
                          style: boldNunitoFontStyle.copyWith(color: blackColor),
                        ),
                        const SizedBox(height: 8),
                        InputPassword(
                          controller: controller.passwordController,
                          hint: 'Type your password here',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password cannot be empty';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        // * Button
                        Obx(
                          () => controller.isLoading.value == true
                              ? makeLoadingIndicator()
                              : Button(
                                  text: 'Login',
                                  onTap: () async {
                                    if (controller.formKey.currentState!
                                        .validate()) {
                                      controller.loginToReportior();
                                    }
                                  },
                                ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
