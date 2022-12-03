import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:login_prac/New_Lead.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/main.dart';
import 'package:login_prac/new_lead_transaction.dart';
import 'package:login_prac/summery.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _changePassword createState() {
    return _changePassword();
  }
}

class _changePassword extends State<ChangePasswordPage> {
  //@override
  final _employID = TextEditingController();
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _reNewPassword = TextEditingController();

  bool _employIDValidate = false;
  bool _oldPasswordValidate = false;
  bool _newPasswordValidate = false;
  bool _reNewPasswordValidate = false;

  bool isLoad = true;

  String employID = '';
  String oldPassword = '';
  String newPassword = '';
  String reNewPassword = '';

  formValidator() {
    String employIDVal = _employID.toString();
    //String meetDate = _meetDateController.text;
    String oldPasswordVal = _oldPassword.toString();
    String newPasswordVal = _newPassword.toString();
    String reNewpasswordVal = _reNewPassword.toString();
    setState(() {
      if (employIDVal == null || employIDVal.isEmpty) {
        _employIDValidate = true;
      } else {
        _employIDValidate = false;
      }
      if (oldPasswordVal == null || oldPasswordVal.isEmpty) {
        _oldPasswordValidate = true;
      } else {
        _oldPasswordValidate = false;
      }
      if (newPasswordVal == null || newPasswordVal.isEmpty) {
        _newPasswordValidate = true;
      } else {
        _newPasswordValidate = false;
      }
      if (reNewpasswordVal == null || reNewpasswordVal.isEmpty) {
        _reNewPasswordValidate = true;
      } else {
        _reNewPasswordValidate = false;
      }
      // if (meetDate == null || meet_date.isEmpty) {
      //   _meetDateVaidate = true;
      // } else {
      //   _meetDateVaidate = false;
      // }
    });
    if (!_employIDValidate &&
        !_oldPasswordValidate &&
        !_newPasswordValidate &&
        !_reNewPasswordValidate) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> createAlbum() async {
    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse(localURL + '/changePwd'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          'username': employID,
          'oldPassword': oldPassword,
          'newPassword': newPassword
        }
            // ),}

            ));
    var responsee = json.decode(response.body)['result'];
    if (response.statusCode == 200) {
      if (responsee.toString().toLowerCase().trim() == 'fail') {
        return 'EmployID & Password Don\'t Match';
      } else {
        return json.decode(response.body)['result'];
      }
    } else {
      return 'Server issues';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
          child: TextField(
            controller: _employID,
            decoration: InputDecoration(
              errorText: _employIDValidate ? 'Value Can\'t Be Empty' : null,
              labelText: 'Employ ID*',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
          child: TextField(
            controller: _oldPassword,
            decoration: InputDecoration(
              errorText: _oldPasswordValidate ? 'Value Can\'t Be Empty' : null,
              labelText: 'Old Password*',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
          child: TextField(
            controller: _newPassword,
            decoration: InputDecoration(
              errorText: _newPasswordValidate ? 'Value Can\'t Be Empty' : null,
              labelText: 'New Password*',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
          child: TextField(
            controller: _reNewPassword,
            decoration: InputDecoration(
              errorText:
                  _reNewPasswordValidate ? 'Value Can\'t Be Empty' : null,
              labelText: 'Re-Type New Password*',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        // save
        Container(
          child: Center(
            child: GestureDetector(
              onTap: () async {
                if (isLoad) {
                  bool isValid = formValidator();
                  if (isValid) {
                    Fluttertoast.showToast(
                        msg: "Saving Change..",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    setState(() {
                      isLoad = false;
                    });

                    if (_newPassword.text != _reNewPassword.text) {
                      Fluttertoast.showToast(
                          msg: "Typed Password Don't Match",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      setState(
                        () {
                          isLoad = true;
                        },
                      );
                    } else {
                      employID = _employID.text;
                      oldPassword = _oldPassword.text;
                      newPassword = _newPassword.text;
                      reNewPassword = _reNewPassword.text;

                      var response = await createAlbum();

                      if (response.toLowerCase().trim() == 'success') {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => new MyHomePage()),
                            (Route<dynamic> route) => false);
                      } else {
                        setState(
                          () {
                            isLoad = true;
                          },
                        );
                        Fluttertoast.showToast(
                            msg: response,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }

                      print('MyResponse=>$response');
                    }
                  }
                }
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
                      "Save Change",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
