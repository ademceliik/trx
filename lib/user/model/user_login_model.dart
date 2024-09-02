/* import 'package:trx/core/base/base_model.dart';

class UserLoginModel extends BaseModel {
  User? user;
  String? token; // Token ekledik

  UserLoginModel({this.user, this.token});

  @override
  fromJson(Map<String, dynamic> json) => UserLoginModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"], // Token'ı json'dan alıyoruz
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token, // Token'ı json'a ekliyoruz
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
 */