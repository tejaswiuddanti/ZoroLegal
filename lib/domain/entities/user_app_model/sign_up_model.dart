import 'dart:convert';

Signupmodel signupmodelFromJson(String str) => Signupmodel.fromJson(json.decode(str));

String signupmodelToJson(Signupmodel data) => json.encode(data.toJson());

class Signupmodel {
    Signupmodel({
        this.staus,
        this.message,
        this.data,
    });

    String staus;
    String message;
    List<Datum> data;

    factory Signupmodel.fromJson(Map<String, dynamic> json) => Signupmodel(
        staus: json["staus"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))??null,
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.resId,
        this.fName,
        this.lName,
        this.email,
        this.phone,
        this.otp,
        this.role,
        this.password,
        this.country,
        this.image,
    });

    int resId;
    String fName;
    dynamic lName;
    dynamic email;
    String phone;
    String otp;
    String role;
    String password;
    String country;
    String image;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        resId: json["res_id"],
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        phone: json["phone"],
        otp: json["otp"],
        role: json["role"],
        password: json["password"],
        country: json["country"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "res_id": resId,
        "f_name": fName,
        "l_name": lName,
        "email": email,
        "phone": phone,
        "otp": otp,
        "role": role,
        "password": password,
        "country": country,
        "image": image,
    };
}
