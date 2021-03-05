import 'dart:convert';

AccountBalancemodel accountBalancemodelFromJson(String str) => AccountBalancemodel.fromJson(json.decode(str));

String accountBalancemodelToJson(AccountBalancemodel data) => json.encode(data.toJson());

class AccountBalancemodel {
    AccountBalancemodel({
        this.staus,
        this.message,
        this.currentAmount,
        this.currency,
        this.walletdata,
    });

    String staus;
    String message;
    String currentAmount;
    String currency;
    List<Walletdatum> walletdata;

    factory AccountBalancemodel.fromJson(Map<String, dynamic> json) => AccountBalancemodel(
        staus: json["staus"],
        message: json["message"],
        currentAmount: json["currentAmount"],
        currency:json["currency"],
        walletdata: List<Walletdatum>.from(json["walletdata"].map((x) => Walletdatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "currentAmount": currentAmount,
        "currency":currency,
        "walletdata": List<dynamic>.from(walletdata.map((x) => x.toJson())),
    };
}

class Walletdatum {
    Walletdatum({
        this.walletId,
        this.userId,
        this.time,
        this.date,
        this.ammount,
        this.transactionId,
        this.paymentStatus,
        this.purpose,
        this.transactionType,
        this.paymentMethod
    });

    String walletId;
    String userId;
    String time;
    String date;
    String ammount;
    String transactionId;
    String paymentStatus;
    String purpose;
    String transactionType;
    String paymentMethod;

    factory Walletdatum.fromJson(Map<String, dynamic> json) => Walletdatum(
        walletId: json["wallet_id"],
        userId: json["user_id"],
        time: json["time"],
        date: json["date"],
        ammount: json["ammount"],
        transactionId: json["transaction_id"],
        paymentStatus: json["payment_status"],
        purpose: json["purpose"],
        transactionType: json["transaction_type"],
        paymentMethod:json["payment_method"]
    );

    Map<String, dynamic> toJson() => {
        "wallet_id": walletId,
        "user_id": userId,
        "time": time,
        "date": date,
        "ammount": ammount,
        "transaction_id": transactionId,
        "payment_status": paymentStatus,
        "purpose": purpose,
        "transaction_type": transactionType,
        "payment_method":paymentMethod
    };
}
