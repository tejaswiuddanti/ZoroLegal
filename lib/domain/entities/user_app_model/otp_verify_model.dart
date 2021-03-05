import 'dart:convert';

Otpmodel otpmodelFromJson(String str) => Otpmodel.fromJson(json.decode(str));

String otpmodelToJson(Otpmodel data) => json.encode(data.toJson());

class Otpmodel {
    Otpmodel({
        this.status,
        this.message,
    });

    int status;
    String message;

    factory Otpmodel.fromJson(Map<String, dynamic> json) => Otpmodel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
