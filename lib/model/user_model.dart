import 'dart:convert';

class UserFields{
  static final String id = 'id';
  static final String name = 'name';
  static final String email = 'email';

  static List<String> getFields() => [id, name, email];
}

class User{
  int? id;
  final String name;
  final String email;

//<editor-fold desc="Data Methods">
   User({
    this.id,
    required this.name,
    required this.email,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User && runtimeType == other.runtimeType && id == other.id && name == other.name && email == other.email);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'User{' + ' id: $id,' + ' name: $name,' + ' email: $email,' + '}';
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserFields.id: this.id,
      UserFields.name: this.name,
      UserFields.email: this.email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: jsonDecode(map[UserFields.id]), // Access id directly from the map
      name: map[UserFields.name] as String, // Access name directly from the map
      email: map[UserFields.email] as String,
    );
  }

//</editor-fold>
}