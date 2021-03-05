import 'dart:convert';

GetOrderDetailsModel getOrderDetailsModelFromJson(String str) => GetOrderDetailsModel.fromJson(json.decode(str));

String getOrderDetailsModelToJson(GetOrderDetailsModel data) => json.encode(data.toJson());

class GetOrderDetailsModel {
    GetOrderDetailsModel({
        this.filed,
        this.bookDate,
        this.vendorData,
        this.userData,
        this.vendorDocuments,
        this.userDocuments,
        this.disClosedRow,
        this.message,
        this.status,
    });

    List<Filed> filed;
    BookDate bookDate;
    VendorData vendorData;
    UserData userData;
    // dynamic vendorDocuments;
    dynamic userDocuments;
    List<VendorDocument> vendorDocuments;
    List<DisClosedRow> disClosedRow;
    // dynamic disClosedRow;
    String message;
    int status;

    factory GetOrderDetailsModel.fromJson(Map<String, dynamic> json) => GetOrderDetailsModel(
        filed:json["filed"]==[]?null: List<Filed>.from(json["filed"].map((x) => Filed.fromJson(x))),
        bookDate:json["bookDate"]==[]?null: BookDate.fromJson(json["bookDate"]),
        vendorData: VendorData.fromJson(json["vendorData"]),
        userData: UserData.fromJson(json["userData"]),
        // vendorDocuments: json["vendor_documents"],
        userDocuments: json["user_documents"],
         vendorDocuments:json["vendor_documents"]==null?json["vendor_documents"]: List<VendorDocument>.from(json["vendor_documents"].map((x) => VendorDocument.fromJson(x))),
        disClosedRow:json["dis_closed_row"]==null?json["dis_closed_row"]: List<DisClosedRow>.from(json["dis_closed_row"].map((x) => DisClosedRow.fromJson(x))),
        // disClosedRow: json["dis_closed_row"],
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "filed": List<dynamic>.from(filed.map((x) => x.toJson())),
        "bookDate": bookDate.toJson(),
        "vendorData": vendorData.toJson(),
        "userData": userData.toJson(),
        "vendor_documents": vendorDocuments,
        "user_documents": userDocuments,
        "dis_closed_row": disClosedRow,
        "message": message,
        "status": status,
    };
}
class VendorDocument {
    VendorDocument({
        this.docId,
        this.docName,
        this.docPath,
        this.docType,
        this.userId,
        this.msgId,
        this.senderRole,
        this.createdAt,
    });

    String docId;
    String docName;
    String docPath;
    String docType;
    String userId;
    String msgId;
    String senderRole;
    DateTime createdAt;

    factory VendorDocument.fromJson(Map<String, dynamic> json) => VendorDocument(
        docId: json["doc_id"],
        docName: json["doc_name"],
        docPath: json["doc_path"],
        docType: json["doc_type"],
        userId: json["user_id"],
        msgId: json["msg_id"],
        senderRole: json["sender_role"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "doc_id": docId,
        "doc_name": docName,
        "doc_path": docPath,
        "doc_type": docType,
        "user_id": userId,
        "msg_id": msgId,
        "sender_role": senderRole,
        "created_at": createdAt.toIso8601String(),
    };
}

class DisClosedRow {
    DisClosedRow({
        this.id,
        this.role,
        this.orderId,
    });

    String id;
    String role;
    String orderId;

    factory DisClosedRow.fromJson(Map<String, dynamic> json) => DisClosedRow(
        id: json["id"],
        role: json["role"],
        orderId: json["order_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "order_id": orderId,
    };
}

class BookDate {
    BookDate({
        this.bookingDate,
        this.bookingTime,
        this.orderStatus,
        this.formName,
    });

    String bookingDate;
    String bookingTime;
    String orderStatus;
    String formName;

    factory BookDate.fromJson(Map<String, dynamic> json) => BookDate(
        bookingDate: json["booking_date"],
        bookingTime: json["booking_time"],
        orderStatus: json["order_status"],
        formName: json["form_name"],
    );

    Map<String, dynamic> toJson() => {
        "booking_date": bookingDate,
        "booking_time": bookingTime,
        "order_status": orderStatus,
        "form_name": formName,
    };
}

class Filed {
    Filed({
        this.filedName,
        this.fieldValue,
        this.fieldType,
    });

    String filedName;
    String fieldValue;
    String fieldType;

    factory Filed.fromJson(Map<String, dynamic> json) => Filed(
        filedName: json["filed_name"],
        fieldValue: json["field_value"],
        fieldType: json["field_type"],
    );

    Map<String, dynamic> toJson() => {
        "filed_name": filedName,
        "field_value": fieldValue,
        "field_type": fieldType,
    };
}

class UserData {
    UserData({
        this.userName,
        this.email,
        this.phone,
    });

    String userName;
    String email;
    String phone;

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        userName: json["user_name"],
        email: json["email"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "user_name": userName,
        "email": email,
        "phone": phone,
    };
}

class VendorData {
    VendorData({
        this.vendorName,
        this.vendorEmail,
        this.vendorPhone,
    });

    dynamic vendorName;
    dynamic vendorEmail;
    dynamic vendorPhone;

    factory VendorData.fromJson(Map<String, dynamic> json) => VendorData(
        vendorName: json["vendor_name"],
        vendorEmail: json["vendor_email"],
        vendorPhone: json["vendor_phone"],
    );

    Map<String, dynamic> toJson() => {
        "vendor_name": vendorName,
        "vendor_email": vendorEmail,
        "vendor_phone": vendorPhone,
    };
}




