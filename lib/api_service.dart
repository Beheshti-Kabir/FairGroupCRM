import 'package:http/http.dart' as http;
import 'package:login_prac/constants.dart';
import 'dart:convert';

import 'package:login_prac/controller.dart';

class ApiService {
  static Future<LogInResponse> login(LogInRequest controllerRequest) async {
    String localURL = Constants.globalURL;

    final response = await http.post(Uri.parse('$localURL/apiLogin'),
        body: json.encode(controllerRequest.ToJson()));
    if ((response.statusCode == 200)) {
      return LogInResponse.fromJson(json.decode(response.body));
    } else {
      return LogInResponse(result: 'Server Error', accessToken: '');
      //  throw Exception("Failed to load Data");
    }
  }
}
