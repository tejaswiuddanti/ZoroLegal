import 'dart:convert';

Vendorassign vendorassignFromJson(String str) => Vendorassign.fromJson(json.decode(str));

String vendorassignToJson(Vendorassign data) => json.encode(data.toJson());

class Vendorassign {
    Vendorassign({
        this.error,
        this.message,
    });

    bool error;
    String message;

    factory Vendorassign.fromJson(Map<String, dynamic> json) => Vendorassign(
        error: json["error"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
    };
}
