import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shieldiea/app/routes/app_pages.dart';
import 'package:shieldiea/app/shared/shared.dart';
import 'package:shieldiea/app/widgets/widgets.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: controller.formKeyLogin,
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
                                  height:
                                      MediaQuery.of(context).size.height / 7),
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
                          // * Email
                          Text(
                            'Email',
                            style:
                                boldNunitoFontStyle.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: 8),
                          InputText(
                            controller: controller.emailController,
                            hint: 'Type your email here',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email cannot be empty';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // * Password
                          Text(
                            'Password',
                            style:
                                boldNunitoFontStyle.copyWith(color: blackColor),
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
                          Button(
                            text: 'Login',
                            onTap: () async {
                              if (controller.formKeyLogin.currentState!
                                  .validate()) {
                                controller.loginWithFirebase();
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          // * Move to register
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dont have an account?',
                                style: semiBoldNunitoFontStyle.copyWith(
                                    color: grayColor),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.REGISTER);
                                },
                                child: Text(
                                  'Register',
                                  style: semiBoldNunitoFontStyle.copyWith(
                                    color: successColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => controller.isLoading.value == true
                  ? const Loading()
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
