import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/constant.dart';
import '../api_client.dart';
import '../api_interface.dart';
import '../entity/jira_project_response.dart';
import '../entity/status_response.dart';

class RemoteTaskService extends ApiInterface {
  SharedPreferences? prefs;
  String? baseUrl;

  Future<void> loadBaseUrl() async {
    return await SharedPreferences.getInstance().then((prefs) {
      this.prefs ??= prefs;
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
    await loadBaseUrl();

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
      Response response = await ApiClient().get(url);

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
    await loadBaseUrl();

    try {
      Response response = await ApiClient().get(
        Uri.parse("$baseUrl/rest/api/3/status"),
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
    await loadBaseUrl();

    try {
      Response response = await ApiClient().get(Uri.parse(
        "$baseUrl/rest/api/3/project/search?maxResults=$maxResult&startAt=$startAt",
      ));

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
