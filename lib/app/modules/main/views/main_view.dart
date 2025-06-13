import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shieldiea/app/extensions/extensions.dart';
import 'package:shieldiea/app/routes/app_pages.dart';
import 'package:shieldiea/app/shared/shared.dart';
import 'package:shieldiea/app/widgets/widgets.dart';
import 'package:supercharged/supercharged.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return StatusBar(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5,
              color: darkGreenColor,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      // * Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, Parents!",
                                style: extraBoldNunitoFontStyle.copyWith(
                                    fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateTime.now().dateYear,
                                style: mediumNunitoFontStyle,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Material(
                                  color: whiteColor.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      Get.toNamed(Routes.SETTING);
                                    },
                                    child: Center(
                                      child: SvgPicture.asset(
                                          'assets/icons/ic_setting.svg'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // * Card Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [defaultBoxShadow],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Summary Content Accessed',
                              style: semiBoldNunitoFontStyle.copyWith(
                                fontSize: 16,
                                color: grayColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSummaryCard(
                                    'App Accessed', '10', blueColor),
                                _buildSummaryCard(
                                    'Time Spent', '30m', yellowColor),
                                _buildSummaryCard('Negative', '3', redColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Child Data",
                        style: extraBoldNunitoFontStyle.copyWith(
                            fontSize: 18, color: blackColor),
                      ),
                      const SizedBox(height: 10),
                      InputText(
                        controller: nameController,
                        hint: 'Type your data name child here',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name cannot be empty';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      // * Button
                      Button(
                        text: 'Add Data',
                        onTap: () async {
                          controller.addChild(nameController.text);
                          nameController.clear();
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Obx(() {
                    return ListView.builder(
                      itemCount: controller.children.length,
                      itemBuilder: (context, index) {
                        final child = controller.children[index];
                        return ListTile(
                          title: Text(child.name),
                          subtitle: Text("Parent ID: ${child.parentId}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  final editName =
                                      TextEditingController(text: child.name);
                                  Get.defaultDialog(
                                    title: "Edit Anak",
                                    content: TextField(controller: editName),
                                    textConfirm: "Simpan",
                                    onConfirm: () {
                                      controller.updateChild(
                                          child.id, editName.text);
                                      Get.back();
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    controller.deleteChild(child.id),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: 'E1E3E5'.toColor(), width: 1),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              title,
              style: semiBoldNunitoFontStyle.copyWith(color: grayColor),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: extraBoldNunitoFontStyle.copyWith(
                color: color,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
