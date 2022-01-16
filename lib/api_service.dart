import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_prac/controller.dart';

class ApiService {
  static Future<LogInResponse> login(LogInRequest controllerRequest) async {
    String url = "http://10.100.17.127:8090/rbd/LeadInfoApi/apiLogin";

    final response = await http.post(Uri.parse(url),
        body: json.encode(controllerRequest.ToJson()));
    if ((response.statusCode == 200)) {
      return LogInResponse.fromJson(json.decode(response.body));
    } else {
      return LogInResponse(result: 'lsdfjkdsf', accessToken: '');
      //  throw Exception("Failed to load Data");
    }
  }
}
