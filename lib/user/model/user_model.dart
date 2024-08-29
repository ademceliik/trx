import 'package:trx/core/base/base_model.dart';

class UserModel extends BaseModel {
  User? user;
  UserModel({this.user});
  @override
  fromJson(Map<String, dynamic> json) => UserModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );
  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}

class User {
  String? fullName;
  String? userName;
  String email;
  String password;
  User(
      {required this.password,
      required this.email,
      this.userName,
      this.fullName});

  factory User.fromJson(Map<String, dynamic> json) => User(
        userName: json["userName"],
        fullName: json["fullName"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "fullName": fullName,
        "email": email,
        "password": password,
      };
}


/* class UserModel {
  String? name;
  String? username;
  String? email;

  UserModel({this.name, this.username, this.email});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    return data;
  }
}
 */