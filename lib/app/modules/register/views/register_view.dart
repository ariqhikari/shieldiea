import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shieldiea/app/shared/shared.dart';
import 'package:shieldiea/app/widgets/widgets.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            SingleChildScrollView(
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
                          "assets/images/bg_circle_small.png",
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 350
                              : 275,
                          fit: BoxFit.fill,
                        ),
                        // * Title
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 8),
                              Text(
                                "Account Registration",
                                textAlign: TextAlign.center,
                                style: headingPrimaryFontStyle,
                              ),
                              Text(
                                "Regist date here for monitor the children",
                                textAlign: TextAlign.center,
                                style: headingSecondaryFontStyle,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    // * Form
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // * Name
                          Text(
                            'Name',
                            style:
                                boldNunitoFontStyle.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: 8),
                          InputText(
                            controller: controller.namaController,
                            hint: 'Type your name here',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name cannot be empty';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
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
                          const SizedBox(height: 16),
                          // * Confirm Password
                          Text(
                            'Confirm Password',
                            style:
                                boldNunitoFontStyle.copyWith(color: blackColor),
                          ),
                          const SizedBox(height: 8),
                          InputPassword(
                            controller: controller.confPasswordController,
                            hint: 'Type your password here',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password cannot be empty';
                              } else if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              } else if (controller.passwordController.text !=
                                  value) {
                                return 'Password and confirm password do not match';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          // * Button
                          Button(
                            text: 'Register',
                            onTap: () async {
                              if (controller.formKey.currentState!.validate()) {
                                // controller.registerAccountParent();
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          // * Move to login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'You have an account?',
                                style: semiBoldNunitoFontStyle.copyWith(
                                    color: grayColor),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Text(
                                  'Login',
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
