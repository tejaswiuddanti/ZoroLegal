import 'dart:convert';

GetOrderChatmodel getOrderChatmodelFromJson(String str) => GetOrderChatmodel.fromJson(json.decode(str));

String getOrderChatmodelToJson(GetOrderChatmodel data) => json.encode(data.toJson());

class GetOrderChatmodel {
    GetOrderChatmodel({
        this.data,
        this.message,
        this.status,
    });

    List<Datum> data;
    String message;
    int status;

    factory GetOrderChatmodel.fromJson(Map<String, dynamic> json) => GetOrderChatmodel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Datum {
    Datum({
        this.msgId,
        this.message,
        this.senderId,
        this.orderId,
        this.createdAt,
        this.fName,
        this.lName,
        this.email,
        this.role,
        this.shared,
    });

    String msgId;
    String message;
    String senderId;
    String orderId;
    DateTime createdAt;
    String fName;
    String lName;
    String email;
    String role;
    List<Shared> shared;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        msgId: json["msg_id"],
        message: json["message"],
        senderId: json["sender_id"],
        orderId: json["order_id"],
        createdAt: DateTime.parse(json["created_at"]),
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        role: json["role"],
        shared: List<Shared>.from(json["shared"].map((x) => Shared.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "msg_id": msgId,
        "message": message,
        "sender_id": senderId,
        "order_id": orderId,
        "created_at": createdAt.toIso8601String(),
        "f_name": fName,
        "l_name": lName,
        "email": email,
        "role": role,
        "shared": List<dynamic>.from(shared.map((x) => x.toJson())),
    };
}

class Shared {
    Shared({
        this.docName,
        this.docPath,
        this.docType,
    });

    String docName;
    String docPath;
    String docType;

    factory Shared.fromJson(Map<String, dynamic> json) => Shared(
        docName: json["doc_name"],
        docPath: json["doc_path"],
        docType: json["doc_type"],
    );

    Map<String, dynamic> toJson() => {
        "doc_name": docName,
        "doc_path": docPath,
        "doc_type": docType,
    };
}
