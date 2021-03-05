import 'dart:convert';

GetProfileCategory getProfileCategoryFromJson(String str) => GetProfileCategory.fromJson(json.decode(str));

String getProfileCategoryToJson(GetProfileCategory data) => json.encode(data.toJson());

class GetProfileCategory {
    GetProfileCategory({
        this.services,
        this.message,
        this.status,
    });

    List<Service> services;
    String message;
    String status;

    factory GetProfileCategory.fromJson(Map<String, dynamic> json) => GetProfileCategory(
        services: List<Service>.from(json["services"].map((x) => Service.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Service {
    Service({
        this.stage2Id,
        this.stage2Name,
    });

    String stage2Id;
    String stage2Name;

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        stage2Id: json["stage2_id"],
        stage2Name: json["stage2_name"],
    );

    Map<String, dynamic> toJson() => {
        "stage2_id": stage2Id,
        "stage2_name": stage2Name,
    };
}
