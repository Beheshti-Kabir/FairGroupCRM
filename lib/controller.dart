class LogInResponse {
  final String accessToken;
  final String result;

  LogInResponse({
    required this.accessToken,
    required this.result,
  });

  factory LogInResponse.fromJson(Map<String, dynamic> json) {
    return LogInResponse(
        accessToken: json["accessToken"] != null ? json["accessToken"] : "",
        result: json["result"] != null ? json["result"] : "");
  }
}

class LogInRequest {
  String employID;
  String password;

  LogInRequest({
    required this.employID,
    required this.password,
  });
  Map<String, dynamic> ToJson() {
    Map<String, dynamic> map = {
      'username': employID.trim(),
      'password': password.trim(),
    };

    return map;
  }
}
