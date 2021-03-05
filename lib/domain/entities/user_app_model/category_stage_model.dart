import 'dart:convert';

Categorystagemodel categorystagemodelFromJson(String str) => Categorystagemodel.fromJson(json.decode(str));

String categorystagemodelToJson(Categorystagemodel data) => json.encode(data.toJson());

class Categorystagemodel {
    Categorystagemodel({
        this.staus,
        this.message,
        this.totalRow,
        this.data,
    });

    String staus;
    String message;
    int totalRow;
    List<Datum> data;

    factory Categorystagemodel.fromJson(Map<String, dynamic> json) => Categorystagemodel(
        staus: json["staus"],
        message: json["message"],
        totalRow: json["total_row"],
        data:List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))??json["data"],
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "total_row": totalRow,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.name,
        this.price,
        this.currency,
        this.malaysiaPrice,
        this.singaporePrice,
        this.category,
        this.fromType,
        this.image,
    });

    String id;
    String name;
    String price;
    String currency;
    String malaysiaPrice;
    String singaporePrice;
    String category;
    String fromType;
    String image;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        currency:json["currency"],
        malaysiaPrice: json["malaysia_price"],
        singaporePrice: json["singapore_price"],
        category: json["category"],
        fromType: json["from_type"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "currency":currency,
        "malaysia_price": malaysiaPrice,
        "singapore_price": singaporePrice,
        "category": category,
        "from_type": fromType,
        "image": image,
    };
}