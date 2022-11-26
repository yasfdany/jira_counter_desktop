import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/constant.dart';
import '../../../../data/model/story_point_data.dart';
import '../../../../data/network/entity/status_response.dart';
import '../../../../data/network/services/remote_task_service.dart';
import 'project_provider.dart';

final taskProvider = ChangeNotifierProvider<TaskProvider>(
  (ref) {
    final provider = ref.read(projectProvider);
    return TaskProvider(provider);
  },
);

class TaskProvider extends ChangeNotifier {
  final priority = {
    "Highest": 5,
    "High": 4,
    "Medium": 3,
    "Low": 2,
    "Lowest": 1,
  };
  final RemoteTaskService remoteTaskService = RemoteTaskService();
  final List<Map<String, dynamic>> filteredIssue = [];
  final List<Map<String, dynamic>> issues = [];
  final List<String> statuses = [];
  final List<String> selectedStatus = [];
  final List<StroyPointData> totalStoryPoint = [];

  SharedPreferences? _prefs;

  bool loading = true;
  int startAt = 0;
  int total = 0;
  String? selectedAccountId;

  late ProjectProvider projectProvider;

  TaskProvider(this.projectProvider);

  void reset() {
    filteredIssue.clear();
    selectedStatus.clear();
    totalStoryPoint.clear();
    selectedAccountId = null;
    notifyListeners();
  }

  void clearSelectedTask() {
    selectedAccountId = null;
    filteredIssue.clear();
    notifyListeners();
  }

  void doFilterIssueByAssignee(String selectedAccountId) {
    this.selectedAccountId = selectedAccountId;
    filteredIssue.clear();
    for (Map<String, dynamic> issue in issues) {
      final bool isSubTask = issue["fields"]?["issuetype"]?["subtask"] ?? false;
      final String accountId =
          (issue["fields"]?["assignee"]?["accountId"] ?? "");

      if (isSubTask) {
        if (selectedAccountId == accountId) {
          filteredIssue.add(issue);
        }
      }
    }
    filteredIssue.sort(
      (a, b) => priority[b["fields"]?["priority"]?["name"]]!.compareTo(
        priority[a["fields"]?["priority"]?["name"]]!,
      ),
    );
    notifyListeners();
  }

  Future loadData() async {
    await projectProvider.getProjects(reset: true);
    await getStatuses();
    getIssues(reset: true);
  }

  void addStatusFilter(String title) async {
    _prefs ??= await SharedPreferences.getInstance();

    if (selectedStatus.contains(title)) {
      selectedStatus.removeWhere((element) => element == title);
    } else {
      selectedStatus.add(title);
    }
    notifyListeners();

    _prefs?.setStringList(Constant.filterStatus, selectedStatus);
  }

  void removeStatusFilter(String title) async {
    _prefs ??= await SharedPreferences.getInstance();

    if (selectedStatus.contains(title)) {
      selectedStatus.remove(title);
      _prefs?.setStringList(Constant.filterStatus, selectedStatus);
      countStoryPoint();
      notifyListeners();
    }
  }

  Future getStatuses({
    bool reset = false,
  }) async {
    loadStatuses();
    _prefs ??= await SharedPreferences.getInstance();
    statuses.clear();

    if (reset) {
      selectedStatus.clear();
      _prefs?.remove(Constant.filterStatus);
    } else {
      selectedStatus.addAll(_prefs?.getStringList(Constant.filterStatus) ?? []);
    }

    final data = await remoteTaskService.getStatuses();
    saveStatuses(data ?? []);

    for (StatusData status in data ?? []) {
      if (status.name.isNotNull &&
          !statuses.contains(status.name!.toUpperCase()) &&
          status.scope?.project?.id == projectProvider.selectedProject?.id) {
        statuses.add(status.name!.toUpperCase());
      }
    }
    notifyListeners();
  }

  Future loadStatuses() async {
    _prefs ??= await SharedPreferences.getInstance();
    final List<String> jsonStatuses =
        _prefs?.getStringList(Constant.jiraIssueStatuses) ?? [];
    final List<StatusData> allStatuses = [];
    for (String json in jsonStatuses) {
      allStatuses.add(StatusData.fromJson(jsonDecode(json)));
    }

    statuses.clear();
    for (StatusData status in allStatuses) {
      if (status.name.isNotNull &&
          !statuses.contains(status.name!.toUpperCase()) &&
          status.scope?.project?.id == projectProvider.selectedProject?.id) {
        statuses.add(status.name!.toUpperCase());
      }
    }
    selectedStatus.clear();
    selectedStatus.addAll(_prefs?.getStringList(Constant.filterStatus) ?? []);
    notifyListeners();
  }

  void saveStatuses(List<StatusData> statuses) async {
    _prefs ??= await SharedPreferences.getInstance();
    final List<String> jsonStatuses = [];

    for (StatusData status in statuses) {
      jsonStatuses.add(jsonEncode(status.toJson()));
    }
    _prefs?.setStringList(Constant.jiraIssueStatuses, jsonStatuses);
  }

  Future getIssues({bool reset = false}) async {
    if (!projectProvider.selectedProject.isNotNull) {
      return;
    }

    if (reset) {
      totalStoryPoint.clear();
      issues.clear();
      startAt = 0;
      loading = true;
      notifyListeners();
    }

    if (selectedStatus.isEmpty) {
      loading = false;
      notifyListeners();
      return;
    }

    final json = await remoteTaskService.getTasks(
      projectCode: projectProvider.selectedProject!.key!,
      startAt: startAt,
      statuses: selectedStatus,
    );

    if (json.isNotNull) {
      total = json?["total"];
      for (dynamic data in json?["issues"]) {
        issues.add(Map<String, dynamic>.from(data));
      }

      if (startAt < total) {
        startAt += 100;
        getIssues();
      } else {
        loading = false;
      }

      countStoryPoint();
      if (selectedAccountId.isNotNull) {
        doFilterIssueByAssignee(selectedAccountId!);
      }
    } else {
      loading = false;
      notifyListeners();
    }
  }

  void countStoryPoint() {
    final Map<String, StroyPointData> dataContainer = {};

    totalStoryPoint.clear();
    for (Map<String, dynamic> issue in issues) {
      final bool isSubTask = issue["fields"]?["issuetype"]?["subtask"] ?? false;
      final String assigneeName =
          (issue["fields"]?["assignee"]?["displayName"] ?? "");
      final String accountId =
          (issue["fields"]?["assignee"]?["accountId"] ?? "");
      final double storyPoint = (issue["fields"]?["customfield_10016"] ?? 0);

      if (isSubTask) {
        if (assigneeName.isNotEmpty) {
          if (dataContainer.containsKey(accountId)) {
            dataContainer[accountId]?.point += storyPoint;
          } else {
            dataContainer[accountId] = StroyPointData(
              accountId: accountId,
              name: assigneeName,
              point: storyPoint,
            );
          }
        }
      }
    }
    totalStoryPoint.addAll(dataContainer.values);
    notifyListeners();
  }
}
