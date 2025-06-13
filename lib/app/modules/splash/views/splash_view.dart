import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shieldiea/app/shared/shared.dart';
import 'package:shieldiea/app/widgets/widgets.dart';
import 'package:supercharged/supercharged.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        backgroundColor: greenColor,
        body: FutureBuilder(
          future: controller.moveToHome(),
          builder: (context, snapshot) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          "Snailly",
                          textAlign: TextAlign.center,
                          style: headingPrimaryFontStyle,
                        ),
                        Text(
                          "Safe browsing for the children",
                          textAlign: TextAlign.center,
                          style: headingSecondaryFontStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // * Version
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                child: Text(
                  'v1.0.0',
                  style: semiBoldNunitoFontStyle.copyWith(
                    color: '8DBE7C'.toColor(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
