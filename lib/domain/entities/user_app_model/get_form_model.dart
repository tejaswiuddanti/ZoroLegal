// To parse this JSON data, do
//
//     final getFormmodel = getFormmodelFromJson(jsonString);

import 'dart:convert';

GetFormmodel getFormmodelFromJson(String str) => GetFormmodel.fromJson(json.decode(str));

String getFormmodelToJson(GetFormmodel data) => json.encode(data.toJson());

class GetFormmodel {
    GetFormmodel({
        this.staus,
        this.message,
        this.data,
    });

    String staus;
    String message;
    List<Datum> data;

    factory GetFormmodel.fromJson(Map<String, dynamic> json) => GetFormmodel(
        staus: json["staus"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "staus": staus,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.formName,
        this.fields,
    });

    String formName;
    List<Field> fields;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        formName: json["form_name"],
        fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "form_name": formName,
        "fields": List<dynamic>.from(fields.map((x) => x.toJson())),
    };
}

class Field {
    Field({
        this.formFieldName,
        this.formValue,
        this.formFieldParamName,
        this.formFieldDatatype,
        this.required,
        this.formFieldSubValue,
    });

    String formFieldName;
    String formValue;
    String formFieldParamName;
    String formFieldDatatype;
    String required;
    List<FormFieldSubValue> formFieldSubValue;

    factory Field.fromJson(Map<String, dynamic> json) => Field(
        formFieldName: json["form_field_name"],
        formValue: json["form_value"],
        formFieldParamName: json["form_field_param_name"],
        formFieldDatatype: json["form_field_datatype"],
        required: json["required"],
        formFieldSubValue: List<FormFieldSubValue>.from(json["form_field_sub_value"].map((x) => FormFieldSubValue.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "form_field_name": formFieldName,
        "form_value": formValue,
        "form_field_param_name": formFieldParamName,
        "form_field_datatype": formFieldDatatype,
        "required": required,
        "form_field_sub_value": List<dynamic>.from(formFieldSubValue.map((x) => x.toJson())),
    };
}

class FormFieldSubValue {
    FormFieldSubValue({
        this.formFiledSubValueTableId,
        this.formFieldRefId,
        this.optionValue,
        this.created,
    });

    String formFiledSubValueTableId;
    String formFieldRefId;
    String optionValue;
    DateTime created;

    factory FormFieldSubValue.fromJson(Map<String, dynamic> json) => FormFieldSubValue(
        formFiledSubValueTableId: json["form_filed_sub_value_table_id"],
        formFieldRefId: json["form_field_ref_id"],
        optionValue: json["option_value"],
        created: DateTime.parse(json["created"]),
    );

    Map<String, dynamic> toJson() => {
        "form_filed_sub_value_table_id": formFiledSubValueTableId,
        "form_field_ref_id": formFieldRefId,
        "option_value": optionValue,
        "created": created.toIso8601String(),
    };
}
