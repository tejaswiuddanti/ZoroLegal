import 'dart:convert';

HomeSearchmodel homeSearchmodelFromJson(String str) => HomeSearchmodel.fromJson(json.decode(str));

String homeSearchmodelToJson(HomeSearchmodel data) => json.encode(data.toJson());

class HomeSearchmodel {
    HomeSearchmodel({
        this.services,
        this.success,
    });

    List<Service> services;
    int success;

    factory HomeSearchmodel.fromJson(Map<String, dynamic> json) => HomeSearchmodel(
        services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
        "success": success,
    };
}

class Service {
    Service({
        this.uiqueId,
        this.stage,
        this.stageId,
        this.stageName,
        this.stagePrice,
        this.countryId,
        this.currency
    });

    String uiqueId;
    String stage;
    String stageId;
    String stageName;
    String stagePrice;
    String countryId;
    String currency;

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        uiqueId: json["uique_id"],
        stage: json["stage"],
        stageId: json["stage_id"],
        stageName: json["stage_name"],
        stagePrice: json["stage_price"],
        countryId: json["country_id"],
        currency:json["currency"]
    );

    Map<String, dynamic> toJson() => {
        "uique_id": uiqueId,
        "stage": stage,
        "stage_id": stageId,
        "stage_name": stageName,
        "stage_price": stagePrice,
        "country_id": countryId,
        "currency":currency,
    };
    @override
  String toString() {
    return '$uiqueId''$stageName''$stagePrice''$stageId''$stage''$countryId''$currency'.toLowerCase()+'$uiqueId''$stageName''$stagePrice''$stageId''$stage''$countryId''$currency'.toUpperCase();
  }
}
