import 'package:http/http.dart' as http;

class ApiClient {
  static final client = http.Client();
  static const int timeout = 30000;
}
