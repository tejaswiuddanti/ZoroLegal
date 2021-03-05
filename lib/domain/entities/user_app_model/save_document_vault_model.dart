import 'dart:convert';

SaveDocumentmodel saveDocumentmodelFromJson(String str) => SaveDocumentmodel.fromJson(json.decode(str));

String saveDocumentmodelToJson(SaveDocumentmodel data) => json.encode(data.toJson());

class SaveDocumentmodel {
    SaveDocumentmodel({
        this.message,
        this.status,
    });

    String message;
    int status;

    factory SaveDocumentmodel.fromJson(Map<String, dynamic> json) => SaveDocumentmodel(
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
    };
}