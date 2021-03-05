import 'dart:convert';

Getordersmodel getordersmodelFromJson(String str) =>
    Getordersmodel.fromJson(json.decode(str));

String getordersmodelToJson(Getordersmodel data) => json.encode(data.toJson());

class Getordersmodel {
  Getordersmodel({
    this.staus,
    this.message,
    this.data,
  });

  String staus;
  String message;
  List<Datum> data;

  factory Getordersmodel.fromJson(Map<String, dynamic> json) => Getordersmodel(
        staus: json["staus"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.userId,
    this.userName,
    this.userMobile,
    this.userEmail,
    this.orderId,
    this.countryId,
    this.paymentStatus,
    this.paymentTransactionId,
    this.paymentDate,
    this.formName,
    this.price,
    this.rating,
    this.image,
    this.currency,
    this.orderStatus,
    this.categoriesStage,
    this.vendorName,
  });
  String userId;
  String userName;
  String userMobile;
  String userEmail;
  String orderId;
  String countryId;
  String paymentStatus;
  String paymentTransactionId;
  String currency;
  String paymentDate;
  String formName;
  String price;
  String rating;
  String image;
  String orderStatus;
  String categoriesStage;
  String vendorName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      userId: json["user_id"],
      userName: json["user_name"],
      userEmail: json["user_email"],
      userMobile: json["user_mobile"],
      orderId: json["order_id"],
      countryId: json["country_id"],
      paymentStatus: json["payment_status"],
      paymentTransactionId: json["payment_transaction_id"],
      paymentDate: json["payment_date"],
      formName: json["form_name"],
      price: json["price"],
      image: json["image"],
      currency: json["currency"],
      rating: json["rating"],
      orderStatus: json["order_status"],
      categoriesStage:json["categories_stage"],
      vendorName:json["vendor_name"]
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "user_mobile": userMobile,
        "order_id": orderId,
        "country_id": countryId,
        "payment_status": paymentStatus,
        "payment_transaction_id": paymentTransactionId,
        "payment_date": paymentDate,
        "form_name": formName,
        "price": price,
        "image": image,
        "order_status": orderStatus,
        "currency": currency,
        "categories_stage":categoriesStage,
        "vendor_name":vendorName
      };
}
