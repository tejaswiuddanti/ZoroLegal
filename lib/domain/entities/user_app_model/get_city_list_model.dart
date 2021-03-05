import 'dart:convert';

GetCitymodel getCitymodelFromJson(String str) => GetCitymodel.fromJson(json.decode(str));

String getCitymodelToJson(GetCitymodel data) => json.encode(data.toJson());

class GetCitymodel {
    GetCitymodel({
        this.cities,
        this.message,
        this.success,
    });

    List<City> cities;
    String message;
    int success;

    factory GetCitymodel.fromJson(Map<String, dynamic> json) => GetCitymodel(
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
        message: json["message"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
        "message": message,
        "success": success,
    };
}

class City {
    City({
        this.id,
        this.countryId,
        this.stateId,
        this.cityId,
        this.cityName,
    });

    String id;
    String countryId;
    String stateId;
    String cityId;
    String cityName;

    factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        cityName: json["city_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
        "city_name": cityName,
    };
}
