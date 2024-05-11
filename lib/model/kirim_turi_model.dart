import 'package:cloud_firestore/cloud_firestore.dart';

class KirimTuriModel{
  String id;
  String name;
  Timestamp createdOn;

  KirimTuriModel({
    required this.id,
    required this.name,
    required this.createdOn,
  });

  KirimTuriModel.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    name: json['name']! as String,
    createdOn: json['createdOn']! as Timestamp,
  );

  KirimTuriModel copyWith({
    String? id,
    String? name,
    Timestamp? createdOn,
  }) {
    return KirimTuriModel(
        id: id ?? this.id,
        name: name ?? this.name,
        createdOn: createdOn ?? this.createdOn);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'createdOn': createdOn,
    };
  }

}