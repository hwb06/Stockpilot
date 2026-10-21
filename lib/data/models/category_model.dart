import '../../core/constants/app_db.dart';

class CategoryModel {
  const CategoryModel({required this.id, required this.name});

  final String id;
  final String name;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json[DbCol.id] as String,
    name: json[DbCol.name] as String,
  );
}
