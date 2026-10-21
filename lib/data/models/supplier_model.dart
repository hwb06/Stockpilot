import '../../core/constants/app_db.dart';

class SupplierModel {
  const SupplierModel({
    this.id = '',
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.createdAt,
  });

  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final DateTime? createdAt;

  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
    id: json[DbCol.id] as String,
    name: json[DbCol.name] as String,
    email: json[DbCol.email] as String?,
    phone: json[DbCol.phone] as String?,
    address: json[DbCol.address] as String?,
    createdAt: DateTime.tryParse('${json[DbCol.createdAt]}'),
  );

  Map<String, dynamic> toJson() => {
    DbCol.name: name,
    DbCol.email: email,
    DbCol.phone: phone,
    DbCol.address: address,
  };
}