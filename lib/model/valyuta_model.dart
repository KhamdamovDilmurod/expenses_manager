import 'package:cloud_firestore/cloud_firestore.dart';

class ValyutaModel{
  String id;
  String name;
  Timestamp createdOn;

  ValyutaModel({
    required this.id,
    required this.name,
    required this.createdOn,
  });

  ValyutaModel.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    name: json['name']! as String,
    createdOn: json['createdOn']! as Timestamp,
  );

  ValyutaModel copyWith({
    String? id,
    String? name,
    Timestamp? createdOn,
  }) {
    return ValyutaModel(
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