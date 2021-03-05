import 'dart:convert';

GetCountrymodel getCountrymodelFromJson(String str) => GetCountrymodel.fromJson(json.decode(str));

String getCountrymodelToJson(GetCountrymodel data) => json.encode(data.toJson());

class GetCountrymodel {
    GetCountrymodel({
        this.country,
        this.success,
    });

    List<Country> country;
    int success;

    factory GetCountrymodel.fromJson(Map<String, dynamic> json) => GetCountrymodel(
        country: List<Country>.from(json["country"].map((x) => Country.fromJson(x))),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "country": List<dynamic>.from(country.map((x) => x.toJson())),
        "success": success,
    };
}

class Country {
    Country({
        this.id,
        this.country,
        this.currency,
        this.createAt,
    });

    String id;
    String country;
    String currency;
    DateTime createAt;

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        country: json["country"],
        currency: json["currency"],
        createAt: DateTime.parse(json["create_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "currency": currency,
        "create_at": createAt.toIso8601String(),
    };
}
