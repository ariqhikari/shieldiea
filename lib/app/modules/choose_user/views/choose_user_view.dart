import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shieldiea/app/routes/app_pages.dart';
import 'package:shieldiea/app/shared/shared.dart';
import 'package:shieldiea/app/widgets/widgets.dart';
import 'package:supercharged/supercharged.dart';

import '../controllers/choose_user_controller.dart';

class ChooseUserView extends GetView<ChooseUserController> {
  const ChooseUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: greenColor,
        body: SingleChildScrollView(
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
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ChooseUserCard(
                          icon: 'assets/icons/ic_parent.svg',
                          title: "Parent",
                          onTap: () {
                            Get.toNamed(Routes.LOGIN_REPORT);
                          },
                        ),
                        const SizedBox(width: 10),
                        ChooseUserCard(
                          icon: 'assets/icons/ic_child.svg',
                          title: "Kids",
                          onTap: () {
                            Get.toNamed(Routes.CHOOSE_CHILD);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 6.6),
                    // * Version
                    Text(
                      'v1.0.0',
                      style: semiBoldNunitoFontStyle.copyWith(
                        color: '8DBE7C'.toColor(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
