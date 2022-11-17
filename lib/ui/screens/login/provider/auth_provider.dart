import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widget_helper/widget_helper.dart';

import '../../../../config/constant.dart';
import '../../../../data/network/services/remote_task_service.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) => AuthProvider(),
);

class AuthProvider extends ChangeNotifier {
  final RemoteTaskService remoteTaskService = RemoteTaskService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  SharedPreferences? _prefs;
  String? baseUrl;
  String? email;
  String? token;
  bool isLogged = false;
  bool loading = false;

  Future checkSession() async {
    _prefs ??= await SharedPreferences.getInstance();
    // _prefs?.clear();

    baseUrl = _prefs?.getString(Constant.jiraUrl);
    email = _prefs?.getString(Constant.jiraEmail);
    token = _prefs?.getString(Constant.jiraToken);
    isLogged = baseUrl.isNotNull && email.isNotNull && token.isNotNull;
    notifyListeners();
  }

  Future saveCredential() async {
    loading = true;
    notifyListeners();

    _prefs ??= await SharedPreferences.getInstance();
    _prefs?.setString(
      Constant.jiraUrl,
      "https://${urlController.text}.atlassian.net",
    );
    _prefs?.setString(Constant.jiraEmail, emailController.text);
    _prefs?.setString(Constant.jiraToken, tokenController.text);

    final json = await remoteTaskService.getStatuses();

    loading = false;
    notifyListeners();

    if (json.isNotNull) {
      baseUrl = urlController.text;
      email = emailController.text;
      token = tokenController.text;
      checkSession();
    } else {
      showToast(
        "Credential not valid",
      );

      _prefs?.clear();
    }
  }

  Future logout() async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs?.clear();
    isLogged = false;
    notifyListeners();
  }
}
