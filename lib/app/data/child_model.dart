class ChildModel {
  final String id;
  final String parentId;
  final String name;

  ChildModel({required this.id, required this.parentId, required this.name});

  factory ChildModel.fromMap(String id, Map<String, dynamic> data) {
    return ChildModel(
      id: id,
      parentId: data['parent_id'] ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parent_id': parentId,
      'name': name,
    };
  }
}
