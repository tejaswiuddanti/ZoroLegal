import 'dart:convert';

ForgotPasswordmodel forgotPasswordmodelFromJson(String str) => ForgotPasswordmodel.fromJson(json.decode(str));

String forgotPasswordmodelToJson(ForgotPasswordmodel data) => json.encode(data.toJson());

class ForgotPasswordmodel {
    ForgotPasswordmodel({
        this.status,
        this.message,
    });

    String status;
    String message;

    factory ForgotPasswordmodel.fromJson(Map<String, dynamic> json) => ForgotPasswordmodel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}