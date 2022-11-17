import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/constant.dart';
import '../api_client.dart';
import '../api_interface.dart';
import '../entity/jira_project_response.dart';
import '../entity/status_response.dart';

class RemoteTaskService extends ApiInterface {
  SharedPreferences? prefs;
  String? basicAuth;
  String? baseUrl;

  Future<void> getBasicAuth() async {
    return await SharedPreferences.getInstance().then((prefs) {
      this.prefs ??= prefs;
      String? email = prefs.getString(Constant.jiraEmail);
      String? token = prefs.getString(Constant.jiraToken);
      basicAuth = 'Basic ${base64.encode(utf8.encode('$email:$token'))}';
      baseUrl = prefs.getString(Constant.jiraUrl);
    });
  }

  @override
  Future<Map<String, dynamic>?> getTasks({
    required String projectCode,
    required int startAt,
    int maxResult = 100,
    List<String> statuses = const [],
  }) async {
    await getBasicAuth();

    String statusQuery = "";
    bool isFirst = true;

    for (String status in statuses) {
      statusQuery += "${!isFirst ? " or " : ""}status=\"$status\"";
      isFirst = false;
    }

    statusQuery = Uri.encodeComponent(statusQuery);

    Uri url = Uri.parse(
      "$baseUrl/rest/api/3/search?maxResults=$maxResult&startAt=$startAt&jql=project=\"$projectCode\"${statusQuery.isNotEmpty ? " and ($statusQuery)" : ""}",
    );

    try {
      http.Response response = await ApiClient.client.get(
        url,
        headers: {
          "Authorization": "$basicAuth",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<List<StatusData>?> getStatuses() async {
    await getBasicAuth();

    try {
      http.Response response = await ApiClient.client.get(
        Uri.parse(
          "$baseUrl/rest/api/3/status",
        ),
        headers: {
          'Authorization': "$basicAuth",
        },
      );

      if (response.statusCode == 200) {
        return statusResponseFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Future<JiraProjectResponse?> getJiraProjects({
    required int startAt,
    int maxResult = 50,
  }) async {
    await getBasicAuth();

    try {
      http.Response response = await ApiClient.client.get(
        Uri.parse(
          "$baseUrl/rest/api/3/project/search?maxResults=$maxResult&startAt=$startAt",
        ),
        headers: {
          "Authorization": "$basicAuth",
        },
      );

      if (response.statusCode == 200) {
        return JiraProjectResponse.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
