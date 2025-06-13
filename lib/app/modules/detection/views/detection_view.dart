import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shieldiea/app/shared/shared.dart';
import 'package:shieldiea/app/widgets/widgets.dart';

import '../controllers/detection_controller.dart';

class DetectionView extends GetView<DetectionController> {
  const DetectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return StatusBar(
      child: Scaffold(
        body: SingleChildScrollView(
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
                            height: MediaQuery.of(context).size.height / 8),
                        Text(
                          "Parental Detection",
                          textAlign: TextAlign.center,
                          style: headingPrimaryFontStyle,
                        ),
                        Text(
                          "Make sure you grant permission to start monitoring!",
                          textAlign: TextAlign.center,
                          style: headingSecondaryFontStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              Obx(() => Button(
                onTap: controller.toggleCapture,
                text: controller.isMonitoring.value ? "Stop Monitoring" : "Start Monitoring",
              )),

            ],
          ),
        ),
      ),
    );
  }
}
