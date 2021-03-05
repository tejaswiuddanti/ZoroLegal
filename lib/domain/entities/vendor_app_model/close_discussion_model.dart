import 'dart:convert';

CloseDiscussion closeDiscussionFromJson(String str) => CloseDiscussion.fromJson(json.decode(str));

String closeDiscussionToJson(CloseDiscussion data) => json.encode(data.toJson());

class CloseDiscussion {
    CloseDiscussion({
        this.staus,
        this.message,
    });

    String staus;
    String message;

    factory CloseDiscussion.fromJson(Map<String, dynamic> json) => CloseDiscussion(
        staus: json["staus"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
    };
}