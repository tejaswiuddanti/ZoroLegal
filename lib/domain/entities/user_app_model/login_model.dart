import 'dart:convert';

Loginmodel loginmodelFromJson(String str) => Loginmodel.fromJson(json.decode(str));

String loginmodelToJson(Loginmodel data) => json.encode(data.toJson());

class Loginmodel {
    Loginmodel({
        this.staus,
        this.message,
        this.data,
    });

    String staus;
    String message;
    List<Datum> data;

    factory Loginmodel.fromJson(Map<String, dynamic> json) => Loginmodel(
        staus: json["staus"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
        this.role,
        this.specialization,
        this.experience,
        this.education,
        this.notes,
        this.password,
        this.country,
        this.image,
    });

    String resId;
    String fName;
    String lName;
    String email;
    String phone;
    String role;
    String specialization;
    String experience;
    String education;
    String notes;
    String password;
    String country;
    String image;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        resId: json["res_id"],
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        specialization: json["specialization"],
        experience: json["experience"],
        education: json["education"],
        notes: json["notes"],
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
        "role": role,
        "specialization": specialization,
        "experience": experience,
        "education": education,
        "notes": notes,
        "password": password,
        "country": country,
        "image": image,
    };
}