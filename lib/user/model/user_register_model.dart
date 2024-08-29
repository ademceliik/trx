class UserRegisterModel {
  String? username;
  String? name;
  String? email;
  String? password;

  UserRegisterModel({this.username, this.name, this.email, this.password});

  UserRegisterModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
