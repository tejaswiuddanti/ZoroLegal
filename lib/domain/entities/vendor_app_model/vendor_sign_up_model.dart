// To parse this JSON data, do
//
//     final vendorSignUpmodel = vendorSignUpmodelFromJson(jsonString);

import 'dart:convert';

VendorSignUpmodel vendorSignUpmodelFromJson(String str) => VendorSignUpmodel.fromJson(json.decode(str));

String vendorSignUpmodelToJson(VendorSignUpmodel data) => json.encode(data.toJson());

class VendorSignUpmodel {
    VendorSignUpmodel({
        this.staus,
        this.message,
        this.data,
    });

    String staus;
    String message;
    List<Datum> data;

    factory VendorSignUpmodel.fromJson(Map<String, dynamic> json) => VendorSignUpmodel(
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
        this.email,
        this.phone,
        this.otp,
        this.role,
        this.stateId,
        this.cityId,
    });

    int resId;
    String fName;
    dynamic email;
    String phone;
    String otp;
    String role;
    String stateId;
    String cityId;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        resId: json["res_id"],
        fName: json["f_name"],
        email: json["email"],
        phone: json["phone"],
        otp: json["otp"],
        role: json["role"],
        stateId: json["state_id"],
        cityId: json["city_id"],
    );

    Map<String, dynamic> toJson() => {
        "res_id": resId,
        "f_name": fName,
        "email": email,
        "phone": phone,
        "otp": otp,
        "role": role,
        "state_id": stateId,
        "city_id": cityId,
    };
}
