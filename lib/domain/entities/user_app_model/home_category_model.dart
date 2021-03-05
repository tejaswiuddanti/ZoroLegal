import 'dart:convert';

Homecategorymodel homecategorymodelFromJson(String str) => Homecategorymodel.fromJson(json.decode(str));

String homecategorymodelToJson(Homecategorymodel data) => json.encode(data.toJson());

class Homecategorymodel {
    Homecategorymodel({
        this.img,
        this.category,
    });

    String img;
    List<Category> category;

    factory Homecategorymodel.fromJson(Map<String, dynamic> json) => Homecategorymodel(
        img: json["img"],
        category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "img": img,
        "category": List<dynamic>.from(category.map((x) => x.toJson())),
    };
}

class Category {
    Category({
        this.categoryId,
        this.categoryName,
        this.categoryDescription,
        this.image,
        this.backgroundImage,
        this.countryId,
        this.created,
        this.modified,
        this.status,
        this.categoryImage,
    });

    String categoryId;
    String categoryName;
    String categoryDescription;
    String image;
    String backgroundImage;
    String countryId;
    DateTime created;
    DateTime modified;
    String status;
    String categoryImage;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryDescription: json["category_description"],
        image: json["image"],
        backgroundImage: json["background_image"],
        countryId: json["country_id"],
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
        status: json["status"],
        categoryImage: json["category_image"],
    );

    Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_description": categoryDescription,
        "image": image,
        "background_image": backgroundImage,
        "country_id": countryId,
        "created": "${created.year.toString().padLeft(4, '0')}-${created.month.toString().padLeft(2, '0')}-${created.day.toString().padLeft(2, '0')}",
        "modified": modified.toIso8601String(),
        "status": status,
        "category_image": categoryImage,
    };
}
