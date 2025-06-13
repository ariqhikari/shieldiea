import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shieldiea/app/data/child_model.dart';

class MainController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final children = <ChildModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await _firestore
        .collection('children')
        .where('user_id', isEqualTo: userId)
        .get();

    children.value = snapshot.docs
        .map((doc) => ChildModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addChild(String name) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('children').add({
      'user_id': userId,
      'name': name,
    });
    fetchChildren();
  }

  Future<void> updateChild(String id, String name) async {
    await _firestore.collection('children').doc(id).update({'name': name});
    fetchChildren();
  }

  Future<void> deleteChild(String id) async {
    await _firestore.collection('children').doc(id).delete();
    fetchChildren();
  }
}
