import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Data Anak')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Anak'),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.addChild(nameController.text);
                    nameController.clear();
                  },
                  child: const Text("Tambah Anak"),
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
                                controller.updateChild(child.id, editName.text);
                                Get.back();
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.deleteChild(child.id),
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
    );
  }
}
