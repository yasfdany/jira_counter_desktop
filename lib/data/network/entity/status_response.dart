// To parse this JSON data, do
//
//     final statusResponse = statusResponseFromJson(jsonString);

import 'dart:convert';

List<StatusData> statusResponseFromJson(String str) =>
    List<StatusData>.from(json.decode(str).map((x) => StatusData.fromJson(x)));

String statusResponseToJson(List<StatusData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatusData {
  StatusData({
    this.self,
    this.description,
    this.iconUrl,
    this.name,
    this.untranslatedName,
    this.id,
    this.statusCategory,
    this.scope,
  });

  String? self;
  String? description;
  String? iconUrl;
  String? name;
  String? untranslatedName;
  String? id;
  StatusCategory? statusCategory;
  Scope? scope;

  factory StatusData.fromJson(Map<String, dynamic> json) => StatusData(
        self: json["self"],
        description: json["description"],
        iconUrl: json["iconUrl"],
        name: json["name"],
        untranslatedName: json["untranslatedName"],
        id: json["id"],
        statusCategory: StatusCategory.fromJson(json["statusCategory"]),
        scope: json["scope"] == null ? null : Scope.fromJson(json["scope"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "description": description,
        "iconUrl": iconUrl,
        "name": name,
        "untranslatedName": untranslatedName,
        "id": id,
        "statusCategory": statusCategory?.toJson(),
        "scope": scope?.toJson(),
      };
}

class Scope {
  Scope({
    this.type,
    this.project,
  });

  String? type;
  ProjectData? project;

  factory Scope.fromJson(Map<String, dynamic> json) => Scope(
        type: json["type"],
        project: ProjectData.fromJson(json["project"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "project": project?.toJson(),
      };
}

class ProjectData {
  ProjectData({
    this.id,
  });

  String? id;

  factory ProjectData.fromJson(Map<String, dynamic> json) => ProjectData(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class StatusCategory {
  StatusCategory({
    this.self,
    this.id,
    this.key,
    this.colorName,
    this.name,
  });

  String? self;
  int? id;
  String? key;
  String? colorName;
  String? name;

  factory StatusCategory.fromJson(Map<String, dynamic> json) => StatusCategory(
        self: json["self"],
        id: json["id"],
        key: json["key"],
        colorName: json["colorName"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "id": id,
        "key": key,
        "colorName": colorName,
        "name": name,
      };
}
