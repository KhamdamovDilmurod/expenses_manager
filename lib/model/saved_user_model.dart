import 'package:cloud_firestore/cloud_firestore.dart';

class SavedUserModel {
  String id;
  String name;
  String password;
  String phoneNumber;
  bool isManager;

  SavedUserModel({
    required this.id,
    required this.name,
    required this.password,
    required this.phoneNumber,
    required this.isManager,
  });

  SavedUserModel.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    name: json['name']! as String,
    password: json['password']! as String,
    phoneNumber: json['phoneNumber']! as String,
    isManager: json['isManager']! as bool,
  );

  SavedUserModel copyWith({
    String? id,
    String? name,
    String? password,
    String? phoneNumber,
    bool? isManager,
  }) {
    return SavedUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isManager: isManager ?? this.isManager,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'phoneNumber': phoneNumber,
      'isManager': isManager,
    };
  }
}
