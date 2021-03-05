import 'dart:convert';

GetProfilemodel getProfilemodelFromJson(String str) => GetProfilemodel.fromJson(json.decode(str));

String getProfilemodelToJson(GetProfilemodel data) => json.encode(data.toJson());

class GetProfilemodel {
    GetProfilemodel({
        this.staus,
        this.message,
        this.data,
    });

    String staus;
    String message;
    List<Datum> data;

    factory GetProfilemodel.fromJson(Map<String, dynamic> json) => GetProfilemodel(
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
        this.role,
        this.walletAmount,
        this.specialization,
        this.experience,
        this.education,
        this.notes,
        this.phone,
        this.country,
        this.password,
        this.image,
        this.certificates,
        this.services,
        
    });

    String resId;
    String fName;
    String lName;
    String email;
    String role;
    String walletAmount;
    String specialization;
    String experience;
    String education;
    String notes;
    String phone;
    String country;
    String password;
    String image;
    String certificates;
    List<Service> services;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        resId: json["res_id"],
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        role: json["role"],
        walletAmount: json["wallet_amount"],
        specialization: json["specialization"],
        experience: json["experience"],
        education: json["education"],
        notes: json["notes"],
        phone: json["phone"],
        country: json["country"],
        password: json["password"],
        image: json["image"],
        certificates:json["certificates"],
        services:List<Service>.from(json["services"].map((x) => Service.fromJson(x)))??null,
    );

    Map<String, dynamic> toJson() => {
        "res_id": resId,
        "f_name": fName,
        "l_name": lName,
        "email": email,
        "role": role,
        "wallet_amount": walletAmount,
        "specialization": specialization,
        "experience": experience,
        "education": education,
        "notes": notes,
        "phone": phone,
        "country": country,
        "password": password,
        "image": image,
        "certificates":certificates,
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
    };
}
class Service {
    Service({
        this.stage2Id,
        this.stage2Name,
    });

    String stage2Id;
    String stage2Name;

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        stage2Id: json["stage2_id"],
        stage2Name: json["stage2_name"],
    );

    Map<String, dynamic> toJson() => {
        "stage2_id": stage2Id,
        "stage2_name": stage2Name,
    };
}