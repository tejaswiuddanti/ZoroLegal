import 'dart:convert';

GetStatemodel getStatemodelFromJson(String str) => GetStatemodel.fromJson(json.decode(str));

String getStatemodelToJson(GetStatemodel data) => json.encode(data.toJson());

class GetStatemodel {
    GetStatemodel({
        this.states,
        this.message,
        this.success,
    });

    List<State> states;
    String message;
    int success;

    factory GetStatemodel.fromJson(Map<String, dynamic> json) => GetStatemodel(
        states: List<State>.from(json["states"].map((x) => State.fromJson(x))),
        message: json["message"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "states": List<dynamic>.from(states.map((x) => x.toJson())),
        "message": message,
        "success": success,
    };
}

class State {
    State({
        this.id,
        this.countryId,
        this.stateId,
        this.cityId,
        this.stateName,
    });

    String id;
    String countryId;
    String stateId;
    String cityId;
    String stateName;

    factory State.fromJson(Map<String, dynamic> json) => State(
        id: json["id"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        stateName: json["state_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
        "state_name": stateName,
    };
}
