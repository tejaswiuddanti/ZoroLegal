import 'dart:convert';

GetDocumentVaultmodel getDocumentVaultmodelFromJson(String str) => GetDocumentVaultmodel.fromJson(json.decode(str));

String getDocumentVaultmodelToJson(GetDocumentVaultmodel data) => json.encode(data.toJson());

class GetDocumentVaultmodel {
    GetDocumentVaultmodel({
        this.documents,
    });

    List<Document> documents;

    factory GetDocumentVaultmodel.fromJson(Map<String, dynamic> json) => GetDocumentVaultmodel(
        documents: List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
    };
}

class Document {
    Document({
        this.docId,
        this.docName,
        this.docPath,
        this.docType,
    });

    String docId;
    String docName;
    String docPath;
    String docType;

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        docId: json["doc_id"],
        docName: json["doc_name"],
        docPath: json["doc_path"],
        docType: json["doc_type"],
    );

    Map<String, dynamic> toJson() => {
        "doc_id": docId,
        "doc_name": docName,
        "doc_path": docPath,
        "doc_type": docType,
    };
}
