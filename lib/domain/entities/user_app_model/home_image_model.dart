import 'dart:convert';

Imagemodel imagemodelFromJson(String str) => Imagemodel.fromJson(json.decode(str));

String imagemodelToJson(Imagemodel data) => json.encode(data.toJson());

class Imagemodel {
    Imagemodel({
        this.staus,
        this.message,
        this.data,
    });

    String staus;
    String message;
    List<String> data;

    factory Imagemodel.fromJson(Map<String, dynamic> json) => Imagemodel(
        staus: json["staus"],
        message: json["message"],
        data: List<String>.from(json["data"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
    };
}