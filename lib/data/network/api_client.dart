import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constant.dart';

class ApiClient extends BaseClient {
  SharedPreferences? prefs;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    prefs ??= await SharedPreferences.getInstance();
    final email = prefs?.getString(Constant.jiraEmail);
    final token = prefs?.getString(Constant.jiraToken);
    final basicAuth = 'Basic ${base64.encode(utf8.encode('$email:$token'))}';

    final Map<String, String> headers = {};
    if (email != null && token != null) {
      headers["Authorization"] = basicAuth;
    }

    request.headers.addAll(headers);
    return request.send();
  }
}
