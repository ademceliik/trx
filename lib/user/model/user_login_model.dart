import 'package:trx/core/base/base_model.dart';

class UserLoginModel extends BaseModel {
  User? user;
  UserLoginModel({this.user});
  @override
  fromJson(Map<String, dynamic> json) => UserLoginModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );
  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}

class User {
  String email;
  String password;
  User({required this.password, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
