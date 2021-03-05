import 'dart:convert';

SearchOrderidmodel searchOrderidmodelFromJson(String str) => SearchOrderidmodel.fromJson(json.decode(str));

String searchOrderidmodelToJson(SearchOrderidmodel data) => json.encode(data.toJson());

class SearchOrderidmodel {
    SearchOrderidmodel({
        this.staus,
        this.message,
        this.data,
    });

    String staus;
    String message;
    List<Datum> data;

    factory SearchOrderidmodel.fromJson(Map<String, dynamic> json) => SearchOrderidmodel(
        staus: json["staus"],
        message: json["message"],
        data:json["data"]==""?null: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.orderId,
        this.countryId,
        this.paymentStatus,
        this.paymentTransactionId,
        this.paymentDate,
        this.formName,
        this.price,
        this.currency,
        this.image,
    });

    String orderId;
    String countryId;
    String paymentStatus;
    String paymentTransactionId;
    String paymentDate;
    String formName;
    String price;
    String currency;
    String image;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderId: json["order_id"],
        countryId: json["country_id"],
        paymentStatus: json["payment_status"],
        paymentTransactionId: json["payment_transaction_id"],
        paymentDate: json["payment_date"],
        formName: json["form_name"],
        price: json["price"],
        currency: json["currency"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "country_id": countryId,
        "payment_status": paymentStatus,
        "payment_transaction_id": paymentTransactionId,
        "payment_date": paymentDate,
        "form_name": formName,
        "price": price,
        "currency": currency,
        "image": image,
    };
}
