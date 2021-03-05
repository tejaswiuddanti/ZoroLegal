import 'dart:convert';

Updateprofilemodel updateprofilemodelFromJson(String str) => Updateprofilemodel.fromJson(json.decode(str));

String updateprofilemodelToJson(Updateprofilemodel data) => json.encode(data.toJson());

class Updateprofilemodel {
    Updateprofilemodel({
        this.staus,
        this.message,
        this.data,
    });

    String staus;
    String message;
    Data data;

    factory Updateprofilemodel.fromJson(Map<String, dynamic> json) => Updateprofilemodel(
        staus: json["staus"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.resId,
        this.fName,
        this.lName,
        this.email,
        this.role,
        this.specialization,
        this.experience,
        this.education,
        this.notes,
        this.phone,
        this.country,
        this.password,
        this.image,
    });

    String resId;
    String fName;
    String lName;
    String email;
    dynamic role;
    String specialization;
    String experience;
    String education;
    String notes;
    dynamic phone;
    dynamic country;
    String password;
    String image;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        resId: json["res_id"],
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        role: json["role"],
        specialization: json["specialization"],
        experience: json["experience"],
        education: json["education"],
        notes: json["notes"],
        phone: json["phone"],
        country: json["country"],
        password: json["password"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "res_id": resId,
        "f_name": fName,
        "l_name": lName,
        "email": email,
        "role": role,
        "specialization": specialization,
        "experience": experience,
        "education": education,
        "notes": notes,
        "phone": phone,
        "country": country,
        "password": password,
        "image": image,
    };
}