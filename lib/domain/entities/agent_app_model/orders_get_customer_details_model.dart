import 'dart:convert';

GetCustomerDetails getCustomerDetailsFromJson(String str) => GetCustomerDetails.fromJson(json.decode(str));

String getCustomerDetailsToJson(GetCustomerDetails data) => json.encode(data.toJson());

class GetCustomerDetails {
    GetCustomerDetails({
        this.staus,
        this.message,
        this.details,
    });

    String staus;
    String message;
    List<Detail> details;

    factory GetCustomerDetails.fromJson(Map<String, dynamic> json) => GetCustomerDetails(
        staus: json["staus"],
        message: json["message"],
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
    };
}

class Detail {
    Detail({
        this.resId,
        this.role,
        this.socialUId,
        this.fName,
        this.lName,
        this.email,
        this.phone,
        this.otp,
        this.specialization,
        this.experience,
        this.education,
        this.notes,
        this.image,
        this.certificates,
        this.status,
        this.country,
        this.stateId,
        this.cityId,
        this.loginType,
        this.password,
        this.currentAmount,
        this.paymentStatus,
        this.agentId,
        this.created,
        this.modified,
    });

    String resId;
    String role;
    dynamic socialUId;
    String fName;
    dynamic lName;
    String email;
    String phone;
    String otp;
    dynamic specialization;
    dynamic experience;
    dynamic education;
    dynamic notes;
    dynamic image;
    dynamic certificates;
    dynamic status;
    String country;
    String stateId;
    String cityId;
    String loginType;
    String password;
    String currentAmount;
    String paymentStatus;
    String agentId;
    DateTime created;
    DateTime modified;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        resId: json["res_id"],
        role: json["role"],
        socialUId: json["social_U_id"],
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        phone: json["phone"],
        otp: json["otp"],
        specialization: json["specialization"],
        experience: json["experience"],
        education: json["education"],
        notes: json["notes"],
        image: json["image"],
        certificates: json["certificates"],
        status: json["status"],
        country: json["country"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        loginType: json["login_type"],
        password: json["password"],
        currentAmount: json["current_amount"],
        paymentStatus: json["payment_status"],
        agentId: json["agent_id"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
    );

    Map<String, dynamic> toJson() => {
        "res_id": resId,
        "role": role,
        "social_U_id": socialUId,
        "f_name": fName,
        "l_name": lName,
        "email": email,
        "phone": phone,
        "otp": otp,
        "specialization": specialization,
        "experience": experience,
        "education": education,
        "notes": notes,
        "image": image,
        "certificates": certificates,
        "status": status,
        "country": country,
        "state_id": stateId,
        "city_id": cityId,
        "login_type": loginType,
        "password": password,
        "current_amount": currentAmount,
        "payment_status": paymentStatus,
        "agent_id": agentId,
        "created": "${created.year.toString().padLeft(4, '0')}-${created.month.toString().padLeft(2, '0')}-${created.day.toString().padLeft(2, '0')}",
        "modified": modified.toIso8601String(),
    };
}
