import 'entity/jira_project_response.dart';
import 'entity/status_response.dart';

abstract class ApiInterface {
  Future<Map<String, dynamic>?> getTasks({
    required String projectCode,
    required int startAt,
    int maxResult = 100,
  });

  Future<List<StatusData>?> getStatuses();

  Future<JiraProjectResponse?> getJiraProjects({
    required int startAt,
    int maxResult = 100,
  });
}
