// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:login_prac/New_Lead.dart';
import 'package:login_prac/api_service.dart';
import 'package:login_prac/itemdetails.dart';
import 'package:login_prac/new_lead_transaction.dart';
import 'controller.dart';
import 'summery.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/summery': (BuildContext context) => SummeryPage(),
        '/newlead': (BuildContext context) => NewLead(),
        '/newleadtransaction': (BuildContext context) => NewLeadTransaction(),
        '/itemdetails': (BuildContext context) => ItemDetails(),
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _employIDController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _employIDValidate = false;
  bool _passwordValidate = false;
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
      resizeToAvoidBottomInset: false,
      body: Column(
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
                    labelText: 'EmployID',
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
                  Fluttertoast.showToast(
                      msg: "Loging In..",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  bool isValid = formValidator();
                  print(_employIDController.text);
                  print(_passwordController.text);
                  if (isValid) {
                    var model = LogInRequest(
                        password: _passwordController.text,
                        employID: _employIDController.text);
                    var response = await ApiService.login(model);
                    print(response.accessToken);
                    if (response.result.toLowerCase().trim() == 'success') {
                      Navigator.of(context).pushNamed('/summery');
                    } else {
                      Fluttertoast.showToast(
                          msg: "Wrong UserID or Password",
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
        ],
      ),
    );
  }
}
