// To parse this JSON data, do
//
//     final jiraProjectResponse = jiraProjectResponseFromJson(jsonString);

import 'dart:convert';

JiraProjectResponse jiraProjectResponseFromJson(String str) =>
    JiraProjectResponse.fromJson(json.decode(str));

String jiraProjectResponseToJson(JiraProjectResponse data) =>
    json.encode(data.toJson());

class JiraProjectResponse {
  JiraProjectResponse({
    this.self,
    this.maxResults,
    this.startAt,
    this.total,
    this.isLast,
    this.values,
  });

  String? self;
  int? maxResults;
  int? startAt;
  int? total;
  bool? isLast;
  List<JiraProject>? values;

  factory JiraProjectResponse.fromJson(Map<String, dynamic> json) =>
      JiraProjectResponse(
        self: json["self"],
        maxResults: json["maxResults"],
        startAt: json["startAt"],
        total: json["total"],
        isLast: json["isLast"],
        values: List<JiraProject>.from(
            json["values"].map((x) => JiraProject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "maxResults": maxResults,
        "startAt": startAt,
        "total": total,
        "isLast": isLast,
        "values": values != null
            ? List<dynamic>.from(values!.map((x) => x.toJson()))
            : null,
      };
}

class JiraProject {
  JiraProject({
    this.expand,
    this.self,
    this.id,
    this.key,
    this.name,
    this.avatarUrls,
    this.projectTypeKey,
    this.simplified,
    this.style,
    this.isPrivate,
    this.properties,
    this.entityId,
    this.uuid,
  });

  String? expand;
  String? self;
  String? id;
  String? key;
  String? name;
  AvatarUrls? avatarUrls;
  String? projectTypeKey;
  bool? simplified;
  String? style;
  bool? isPrivate;
  Properties? properties;
  String? entityId;
  String? uuid;

  factory JiraProject.fromJson(Map<String, dynamic> json) => JiraProject(
        expand: json["expand"],
        self: json["self"],
        id: json["id"],
        key: json["key"],
        name: json["name"],
        avatarUrls: AvatarUrls.fromJson(json["avatarUrls"]),
        projectTypeKey: json["projectTypeKey"],
        simplified: json["simplified"],
        style: json["style"],
        isPrivate: json["isPrivate"],
        properties: Properties.fromJson(json["properties"]),
        entityId: json["entityId"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "expand": expand,
        "self": self,
        "id": id,
        "key": key,
        "name": name,
        "avatarUrls": avatarUrls?.toJson(),
        "projectTypeKey": projectTypeKey,
        "simplified": simplified,
        "style": style,
        "isPrivate": isPrivate,
        "properties": properties?.toJson(),
        "entityId": entityId,
        "uuid": uuid,
      };
}

class AvatarUrls {
  AvatarUrls({
    this.the48X48,
    this.the24X24,
    this.the16X16,
    this.the32X32,
  });

  String? the48X48;
  String? the24X24;
  String? the16X16;
  String? the32X32;

  factory AvatarUrls.fromJson(Map<String, dynamic> json) => AvatarUrls(
        the48X48: json["48x48"],
        the24X24: json["24x24"],
        the16X16: json["16x16"],
        the32X32: json["32x32"],
      );

  Map<String, dynamic> toJson() => {
        "48x48": the48X48,
        "24x24": the24X24,
        "16x16": the16X16,
        "32x32": the32X32,
      };
}

class Properties {
  Properties();

  factory Properties.fromJson(Map<String, dynamic> json) => Properties();

  Map<String, dynamic> toJson() => {};
}
