import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/constant.dart';
import '../../../../data/network/entity/jira_project_response.dart';
import '../../../../data/network/services/remote_task_service.dart';

final projectProvider = ChangeNotifierProvider<ProjectProvider>(
  (ref) => ProjectProvider(),
);

class ProjectProvider extends ChangeNotifier {
  final RemoteTaskService remoteTaskService = RemoteTaskService();
  final List<JiraProject?> projects = [];

  bool loading = true;
  int startAt = 0;
  int total = 0;

  JiraProject? selectedProject;
  SharedPreferences? prefs;

  Future loadSelectedProject() async {
    prefs ??= await SharedPreferences.getInstance();

    final String? jsonSelectedProject = prefs?.getString(
      Constant.selectedProject,
    );
    if (jsonSelectedProject.isNotNull) {
      selectedProject = JiraProject.fromJson(
        jsonDecode(jsonSelectedProject!),
      );
      selectProject(selectedProject);
    } else {
      selectProject(projects.first);
    }
  }

  void saveProjects() async {
    prefs ??= await SharedPreferences.getInstance();
    final List<String> jsonProjectsList = [];
    for (JiraProject? project in projects) {
      jsonProjectsList.add(jsonEncode(project?.toJson()));
    }

    prefs?.setStringList(Constant.jiraProjects, jsonProjectsList);
  }

  Future loadProjects() async {
    prefs ??= await SharedPreferences.getInstance();
    final List<String> jsonProjectsList =
        prefs?.getStringList(Constant.jiraProjects) ?? [];
    projects.clear();
    for (String json in jsonProjectsList) {
      projects.add(JiraProject.fromJson(jsonDecode(json)));
    }
    if (projects.isNotEmpty) loadSelectedProject();
  }

  void selectProject(JiraProject? project) {
    selectedProject = project;
    prefs?.setString(
      Constant.selectedProject,
      jsonEncode(selectedProject?.toJson()),
    );
    notifyListeners();
  }

  Future getProjects({
    bool reset = false,
  }) async {
    if (reset) loadProjects();

    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      prefs ??= await SharedPreferences.getInstance();
      if (reset) {
        startAt = 0;
        loading = true;
        projects.clear();
        notifyListeners();
      }

      final JiraProjectResponse? response =
          await remoteTaskService.getJiraProjects(startAt: startAt);

      total = response?.total ?? 0;
      projects.addAll(response?.values ?? []);

      if (startAt < total) {
        startAt += 50;
        await getProjects();
      } else {
        loading = false;
        notifyListeners();

        if (projects.isNotEmpty) {
          await loadSelectedProject();
          saveProjects();
        }
      }
    }
  }
}
