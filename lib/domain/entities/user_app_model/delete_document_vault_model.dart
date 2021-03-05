import 'dart:convert';

DeleteDocumentmodel deleteDocumentmodelFromJson(String str) => DeleteDocumentmodel.fromJson(json.decode(str));

String deleteDocumentmodelToJson(DeleteDocumentmodel data) => json.encode(data.toJson());

class DeleteDocumentmodel {
    DeleteDocumentmodel({
        this.staus,
        this.message,
        this.data,
    });

    String staus;
    String message;
    bool data;

    factory DeleteDocumentmodel.fromJson(Map<String, dynamic> json) => DeleteDocumentmodel(
        staus: json["staus"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "data": data,
    };
}
