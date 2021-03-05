import 'dart:convert';

Walletpaymentmodel walletpaymentmodelFromJson(String str) => Walletpaymentmodel.fromJson(json.decode(str));

String walletpaymentmodelToJson(Walletpaymentmodel data) => json.encode(data.toJson());

class Walletpaymentmodel {
    Walletpaymentmodel({
        this.message,
        this.success,
    });

    String message;
    int success;

    factory Walletpaymentmodel.fromJson(Map<String, dynamic> json) => Walletpaymentmodel(
        message: json["message"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
    };
}
