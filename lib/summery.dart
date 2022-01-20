// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:login_prac/New_Lead.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/lists.dart';
import 'package:login_prac/main.dart';
import 'package:login_prac/new_lead_transaction.dart';

class SummeryPage extends StatefulWidget {
  @override
  _SummeryPageState createState() => _SummeryPageState();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/newlead': (BuildContext context) => new NewLead(),
        '/newleadtransaction': (BuildContext context) =>
            new NewLeadTransaction(),
        '/listsPage': (BuildContext context) => new ListsPage(),
        '/logInPage': (BuildContext context) => new MyHomePage(),
      },
    );
  }
}

class _SummeryPageState extends State<SummeryPage> {
  bool isLoading = false;
  bool gotData = false;

  late dynamic response;
  late var totalInvoice = '';
  late var totalPna = '';
  late var totalFollowUp = '';
  late var totalLead = '';
  late var totalCancel = '';
  late var totalInProgress = '';
  late var totalNoAnswer = '';

  @override
  initState() {
    super.initState();
    getSummary();
  }

  getSummary() async {
    setState(() {
      isLoading = true;

      //print(json.decode(response.body)['totalLead']);
      //result = json.decode(response.body);
      //print("lead=" + json.decode(response.body)['totalLead']);
      // result['leadInfo'];
    });
    response = await http.post(
        Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/getSummary'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': Constants.employeeId,
        }));

    setState(() {
      if (response.statusCode == 200) {
      } else {
        throw Exception('Failed to load album');
      }

      isLoading = false;
      totalInvoice = json.decode(response.body)['totalInvoiced'].toString();
      totalLead = json.decode(response.body)['totalLead'].toString();
      totalPna = json.decode(response.body)['totalPna'].toString();
      totalInProgress =
          json.decode(response.body)['totalInProgress'].toString();
      totalFollowUp = json.decode(response.body)['totalFollowup'].toString();
      totalCancel = json.decode(response.body)['totalCancel'].toString();
      totalNoAnswer = json.decode(response.body)['totalNoAnswer'].toString();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Summary'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/newlead');
                      },
                      child: Container(
                        height: 40.0,
                        width: 110.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.blueAccent,
                          color: Colors.blue[800],
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'New Lead',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(35.0, 20.0, 0.0, 0.0),
                child: Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/newleadtransaction');
                      },
                      child: Container(
                        height: 40.0,
                        width: 170.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.blueAccent,
                          color: Colors.blue[800],
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'New Lead Transacsion',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 90.0),
          // if (!isLoading)
          Table(
            defaultColumnWidth: FixedColumnWidth(180.0),
            border: TableBorder.all(
                color: Colors.blueAccent, style: BorderStyle.solid, width: 2),
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              TableRow(children: [
                Column(children: [
                  Text('Total Lead', style: TextStyle(fontSize: 20.0))
                ]),
                Column(children: [
                  Text(totalLead, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Loading..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushNamed(context, '/listsPage',
                            arguments: 'NO-ANSWER');
                      },
                      child: Text('Total No Answer',
                          style: TextStyle(fontSize: 20.0)))
                ]),
                Column(children: [
                  Text(totalNoAnswer, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Loading..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushNamed(context, '/listsPage',
                            arguments: 'IN-PROGRESS');
                      },
                      child: Text('Total In-Progress',
                          style: TextStyle(fontSize: 20.0)))
                ]),
                Column(children: [
                  Text(totalInProgress, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Loading..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushNamed(context, '/listsPage',
                            arguments: 'PRODUCT-NOT-AVAILABLE');
                      },
                      child: Text('Total Product Not Available',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0)))
                ]),
                Column(children: [
                  Text(totalPna, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Loading..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushNamed(context, '/listsPage',
                            arguments: 'FOLLOW-UP');
                      },
                      child: Text('Total Follow Up',
                          style: TextStyle(fontSize: 20.0)))
                ]),
                Column(children: [
                  Text(totalFollowUp, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Loading..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushNamed(context, '/listsPage',
                            arguments: 'CANCEL');
                      },
                      child: Text('Total Cancel',
                          style: TextStyle(fontSize: 20.0)))
                ]),
                Column(children: [
                  Text(totalCancel, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(
                            msg: "Loading..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushNamed(context, '/listsPage',
                            arguments: 'INVOICED');
                      },
                      child: Text('Total Invoiced',
                          style: TextStyle(fontSize: 20.0)))
                ]),
                Column(children: [
                  Text(totalInvoice, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Constants.employeeId = '';
                    //Navigator.of(context).pushReplacementNamed('/logInPage');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => new MyHomePage()),
                        (Route<dynamic> route) => false);
                  },
                  child: Container(
                    height: 40.0,
                    width: 170.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.blueAccent,
                      color: Colors.blue[800],
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //if (isLoading)
          //Text("Data is loading...", style: TextStyle(fontSize: 40.0))
        ],
      ),
    );
  }
}
