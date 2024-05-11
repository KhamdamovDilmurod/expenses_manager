import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  String id;
  String name;
  String password;
  String phoneNumber;
  bool isManager;
  Timestamp createdOn;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.password,
    required this.phoneNumber,
    required this.isManager,
    required this.createdOn,
  });

  EmployeeModel.fromJson(Map<String, Object?> json)
      : this(
          id: json['id']! as String,
          name: json['name']! as String,
          password: json['password']! as String,
          phoneNumber: json['phoneNumber']! as String,
          isManager: json['isManager']! as bool,
          createdOn: json['createdOn']! as Timestamp,
        );

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? password,
    String? phoneNumber,
    bool? isManager,
    Timestamp? createdOn,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isManager: isManager ?? this.isManager,
      createdOn: createdOn ?? this.createdOn,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'phoneNumber': phoneNumber,
      'isManager': isManager,
      'createdOn': createdOn,
    };
  }
}
