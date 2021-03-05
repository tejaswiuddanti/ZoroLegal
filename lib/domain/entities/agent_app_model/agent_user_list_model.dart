import 'dart:convert';

Vendorassign vendorassignFromJson(String str) => Vendorassign.fromJson(json.decode(str));

String vendorassignToJson(Vendorassign data) => json.encode(data.toJson());

class Vendorassign {
    Vendorassign({
        this.users,
    });

    List<User> users;

    factory Vendorassign.fromJson(Map<String, dynamic> json) => Vendorassign(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}

class User {
    User({
        this.resId,
        this.fName,
        this.email,
        this.phone,
        this.password,
    });

    String resId;
    String fName;
    String email;
    String phone;
    String password;

    factory User.fromJson(Map<String, dynamic> json) => User(
        resId: json["res_id"],
        fName: json["f_name"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "res_id": resId,
        "f_name": fName,
        "email": email,
        "phone": phone,
        "password": password,
    };



     @override
  String toString() {
    return '$resId''$fName''$email''$phone''$password'.toLowerCase()+'$resId''$fName''$email''$phone''$password'.toUpperCase();
  }
}
