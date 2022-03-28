import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_prac/api_service.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/controller.dart';
import 'package:login_prac/utils/sesssion_manager.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _employIDController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _employIDValidate = false;
  bool _passwordValidate = false;
  String version = Constants.version;
  //logInValidator(){}

  bool formValidator() {
    String employID = _employIDController.text;
    String password = _passwordController.text;
    setState(() {
      if (employID == null || employID.isEmpty) {
        _employIDValidate = true;
      } else {
        _employIDValidate = false;
      }
      if (password == null || password.isEmpty) {
        _passwordValidate = true;
      } else {
        _passwordValidate = false;
      }
    });
    if (!_employIDValidate && !_passwordValidate) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text(
                      'Fair',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 80,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
                    child: Text(
                      'Group',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 80,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 260.0, 0.0, 0.0),
                    child: Text(
                      'CRM',
                      style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 105.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _employIDController,
                    decoration: InputDecoration(
                      errorText:
                          _employIDValidate ? 'Value Can\'t Be Empty' : null,
                      labelText: 'Employee ID',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      errorText:
                          _passwordValidate ? 'Value Can\'t Be Empty' : null,
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    obscureText: true,
                  )
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    bool isValid = formValidator();
                    isValid == true
                        ? Fluttertoast.showToast(
                            msg: "Loging In..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0)
                        : Fluttertoast.showToast(
                            msg: "Field Missing",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                    print(_employIDController.text);
                    print(_passwordController.text);
                    if (isValid) {
                      var model = LogInRequest(
                          password: _passwordController.text,
                          employID: _employIDController.text);
                      var response = await ApiService.login(model);
                      print(response.result);
                      if (response.result.toLowerCase().trim() == 'success') {
                        Constants.employeeId = _employIDController.text.trim();
                        storeLocalSetEmployeeID(
                            Constants.employeeIDKey, Constants.employeeId);
                        storeLocalSetLogInStatus(
                            Constants.logInStatusKey, response.result);
                        Navigator.of(context).pushReplacementNamed('/summery');
                      } else if (response.result.toLowerCase().trim() ==
                          'fail') {
                        Fluttertoast.showToast(
                            msg: "Wrong UserID or Password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Server Error",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }

                    //Navigator.of(context).pushNamed('/summery');
                  },
                  child: Container(
                    height: 40.0,
                    width: 150.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.lightBlueAccent,
                      color: Colors.blue[800],
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: 300.0,
            // )
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: GestureDetector(
                onTap: () async {
                  Fluttertoast.showToast(
                      msg: "Loading..",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.pushNamed(context, '/changePasswordPage');
                },
                child: SizedBox(
                  height: 60.0,
                  //width: 170.0,
                  child: Material(
                    //borderRadius: BorderRadius.(20.0),
                    //shadowColor: Color.fromARGB(255, 65, 133, 250),
                    //color: Colors.white,

                    child: Center(
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //     FooterView(children: <Widget>[], footer: new Footer(
            //   child: Padding(
            //     padding: new EdgeInsets.all(10.0),
            //     child: Text('Version 1.0.6\nDeveloped By Fair Group, IT Software Team'),
            //   ),
            // ),
            // //flex: 1,
            // )
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(top: 50.0, right: 10.0),
              child: Text(
                'Version $version\nDeveloped By Fair Group,\nIT Software Team',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
