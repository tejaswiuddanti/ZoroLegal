import 'dart:convert';

Submitformmodel submitformmodelFromJson(String str) => Submitformmodel.fromJson(json.decode(str));

String submitformmodelToJson(Submitformmodel data) => json.encode(data.toJson());

class Submitformmodel {
    Submitformmodel({
        this.staus,
        this.message,
        this.data,
        this.newData,
    });

    String staus;
    String message;
    List<Datum> data;
    NewData newData;

    factory Submitformmodel.fromJson(Map<String, dynamic> json) => Submitformmodel(
        staus: json["staus"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        newData: NewData.fromJson(json["new_data"]),
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "new_data": newData.toJson(),
    };
}

class Datum {
    Datum({
        this.listReferenceId,
        this.formSubmissionListRefId,
        this.submitedFormFiledId,
        this.submitedFormFiledValue,
        this.created,
    });

    String listReferenceId;
    int formSubmissionListRefId;
    String submitedFormFiledId;
    String submitedFormFiledValue;
    DateTime created;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        listReferenceId: json["list_reference_id"],
        formSubmissionListRefId: json["form_submission_list_ref_id"],
        submitedFormFiledId: json["submited_form_filed_id"],
        submitedFormFiledValue: json["submited_form_filed_value"],
        created: DateTime.parse(json["created"]),
    );

    Map<String, dynamic> toJson() => {
        "list_reference_id": listReferenceId,
        "form_submission_list_ref_id": formSubmissionListRefId,
        "submited_form_filed_id": submitedFormFiledId,
        "submited_form_filed_value": submitedFormFiledValue,
        "created": created.toIso8601String(),
    };
}

class NewData {
    NewData({
        this.orderId,
        this.transactionId,
        this.price,
        this.serviceId,
        this.serviceStage,
        this.serviceName,
        this.walletBalance,
        this.country,
        this.vendorId,
    });

    int orderId;
    String transactionId;
    String price;
    String serviceId;
    String serviceStage;
    String serviceName;
    String walletBalance;
    String country;
    String vendorId;

    factory NewData.fromJson(Map<String, dynamic> json) => NewData(
        orderId: json["order_id"],
        transactionId: json["transaction_id"],
        price: json["price"]??null,
        serviceId: json["service_id"],
        serviceStage: json["service_stage"],
        serviceName: json["service_name"],
        walletBalance: json["wallet_balance"],
        country: json["country"],
        vendorId: json["vendorId"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "transaction_id": transactionId,
        "price": price,
        "service_id": serviceId,
        "service_stage": serviceStage,
        "service_name": serviceName,
        "wallet_balance": walletBalance,
        "country": country,
        "vendorId": vendorId,
    };
}
