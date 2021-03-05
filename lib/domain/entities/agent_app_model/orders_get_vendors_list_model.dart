import 'dart:convert';

GetVendorList getVendorListFromJson(String str) => GetVendorList.fromJson(json.decode(str));

String getVendorListToJson(GetVendorList data) => json.encode(data.toJson());

class GetVendorList {
    GetVendorList({
        this.error,
        this.data,
    });

    bool error;
    List<Datum> data;

    factory GetVendorList.fromJson(Map<String, dynamic> json) => GetVendorList(
        error: json["error"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.vendorId,
        this.vendorName,
        this.vendorEmail,
    });

    String vendorId;
    String vendorName;
    String vendorEmail;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        vendorId: json["vendor_id"],
        vendorName: json["vendor_name"],
        vendorEmail: json["vendor_email"],
    );

    Map<String, dynamic> toJson() => {
        "vendor_id": vendorId,
        "vendor_name": vendorName,
        "vendor_email": vendorEmail,
    };
}