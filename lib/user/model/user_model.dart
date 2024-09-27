import 'package:trx/core/base/base_model.dart';

class UserModel extends BaseModel {
  User? user;
  UserModel({this.user});
  @override
  fromJson(Map<String, dynamic> json) => UserModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );
  @override
  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}

class User {
  String? fullName;
  String? userName;
  String? email;
  String? macAddress;
  User({this.macAddress, this.email, this.userName, this.fullName});

  factory User.fromJson(Map<String, dynamic> json) => User(
        userName: json["userName"],
        fullName: json["fullName"],
        email: json["email"],
        macAddress: json["macAddress"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "fullName": fullName,
        "email": email,
        "macAddress": macAddress,
      };
}
