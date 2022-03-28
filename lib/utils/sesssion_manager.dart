import 'package:login_prac/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future storeLocalSetEmployeeID(String key, String value) async {
  final _sharedPreferences = await SharedPreferences.getInstance();

  await _sharedPreferences.setString(key, value);
}

Future storeLocalSetLogInStatus(String key, String value) async {
  final _sharedPreferences = await SharedPreferences.getInstance();

  await _sharedPreferences.setString(key, value);
}

Future<bool> localLoginStatus() async {
  final _sharedPreferences = await SharedPreferences.getInstance();
  var value = _sharedPreferences.getString(Constants.logInStatusKey);
  print('checked status =>' + value.toString());
  if (value == 'success') {
    return true;
  } else {
    return false;
  }
  //return value !=null?true:false;
}

Future<String> localGetEmployeeID() async {
  final _sharedPreferences = await SharedPreferences.getInstance();
  var value = _sharedPreferences.getString(Constants.employeeIDKey);
  //bool valueCheck = value!.isEmpty;
  print('checked ID =>' + value.toString());

  return value.toString();

  //return value !=null?true:false;
}
