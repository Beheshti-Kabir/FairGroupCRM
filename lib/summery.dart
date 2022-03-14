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
  String version = Constants.version;
  String employID = Constants.employeeId;

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
        //Uri.parse('http://10.100.18.167:8090/rbd/leadInfoApi/getSummary'),
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
        title: Text('Summary For $employID'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 0.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/newlead');
                    },
                    child: Container(
                      height: 40.0,
                      //width: 110.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.blueAccent,
                        color: Colors.blue[800],
                        elevation: 7.0,
                        child: Center(
                          child: Text('New Lead',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/newleadtransaction');
                        },
                        child: SizedBox(
                          height: 40.0,
                          //width: 170.0,
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
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 90.0),
          Column(children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Stack(
                      children: <Widget>[
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
                            totalLead == "0"
                                ? Fluttertoast.showToast(
                                    msg: "No Data",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : Navigator.pushNamed(context, '/listsPage',
                                    arguments: 'TOTAL');
                          },
                          child: SizedBox(
                            height: 60.0,
                            //width: 170.0,
                            child: Material(
                              //borderRadius: BorderRadius.(20.0),
                              shadowColor: Color.fromARGB(255, 65, 133, 250),
                              color: Colors.white,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Total Lead\n' + totalLead,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Stack(
                      children: <Widget>[
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
                            totalInProgress == "0"
                                ? Fluttertoast.showToast(
                                    msg: "No Data",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : Navigator.pushNamed(context, '/listsPage',
                                    arguments: 'IN-PROGRESS');
                          },
                          child: SizedBox(
                            height: 60.0,
                            //width: 170.0,
                            child: Material(
                              //borderRadius: BorderRadius.(20.0),
                              shadowColor: Color.fromARGB(255, 65, 133, 250),
                              color: Colors.white,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Total New Lead\n' + totalInProgress,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                    child: Stack(
                      children: <Widget>[
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
                            totalNoAnswer == "0"
                                ? Fluttertoast.showToast(
                                    msg: "No Data",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : Navigator.pushNamed(context, '/listsPage',
                                    arguments: 'NO-ANSWER');
                          },
                          child: SizedBox(
                            height: 60.0,
                            //width: 170.0,
                            child: Material(
                              //borderRadius: BorderRadius.(20.0),
                              shadowColor: Color.fromARGB(255, 65, 133, 250),
                              color: Colors.white,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Total No Answer\n' + totalNoAnswer,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Stack(
                      children: <Widget>[
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
                            totalPna == "0"
                                ? Fluttertoast.showToast(
                                    msg: "No Data",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : Navigator.pushNamed(context, '/listsPage',
                                    arguments: 'PRODUCT-NOT-AVAILABLE');
                          },
                          child: SizedBox(
                            height: 60.0,
                            //width: 170.0,
                            child: Material(
                              //borderRadius: BorderRadius.(20.0),
                              shadowColor: Color.fromARGB(255, 65, 133, 250),
                              color: Colors.white,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Total Product Not Available\n' + totalPna,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                    child: Stack(
                      children: <Widget>[
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
                            totalFollowUp == "0"
                                ? Fluttertoast.showToast(
                                    msg: "No Data",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : Navigator.pushNamed(context, '/listsPage',
                                    arguments: 'FOLLOW-UP');
                          },
                          child: SizedBox(
                            height: 60.0,
                            //width: 170.0,
                            child: Material(
                              //borderRadius: BorderRadius.(20.0),
                              shadowColor: Color.fromARGB(255, 65, 133, 250),
                              color: Colors.white,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Total Follow Up\n' + totalFollowUp,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Stack(
                      children: <Widget>[
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
                            totalCancel == "0"
                                ? Fluttertoast.showToast(
                                    msg: "No Data",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : Navigator.pushNamed(context, '/listsPage',
                                    arguments: 'CANCEL');
                          },
                          child: SizedBox(
                            height: 60.0,
                            //width: 170.0,
                            child: Material(
                              //borderRadius: BorderRadius.(20.0),
                              shadowColor: Color.fromARGB(255, 65, 133, 250),
                              color: Colors.white,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Total Cancel\n' + totalCancel,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                    child: Stack(
                      children: <Widget>[
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
                            totalInvoice == "0"
                                ? Fluttertoast.showToast(
                                    msg: "No Data",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                                : Navigator.pushNamed(context, '/listsPage',
                                    arguments: 'INVOICED');
                          },
                          child: SizedBox(
                            height: 60.0,
                            //width: 170.0,
                            child: Material(
                              //borderRadius: BorderRadius.(20.0),
                              shadowColor: Color.fromARGB(255, 65, 133, 250),
                              color: Colors.white,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Total Invoiced\n' + totalInvoice,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
          // Table(
          //   defaultColumnWidth: FixedColumnWidth(180.0),
          //   border: TableBorder.all(
          //       color: Colors.blueAccent, style: BorderStyle.solid, width: 2),
          //   // ignore: prefer_const_literals_to_create_immutables
          //   children: [
          //     TableRow(children: [
          //       Column(children: [
          //         GestureDetector(
          //             onTap: () async {
          //               Fluttertoast.showToast(
          //                   msg: "Loading..",
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.TOP,
          //                   timeInSecForIosWeb: 1,
          //                   backgroundColor: Colors.red,
          //                   textColor: Colors.white,
          //                   fontSize: 16.0);
          //               Navigator.pushNamed(context, '/listsPage',
          //                   arguments: 'TOTAL');
          //             },
          //             child: Text('Total Lead',
          //                 style: TextStyle(fontSize: 20.0)))
          //       ]),
          //       Column(children: [
          //         Text(totalLead, style: TextStyle(fontSize: 20.0))
          //       ]),
          //     ]),
          //     TableRow(children: [
          //       Column(children: [
          //         GestureDetector(
          //             onTap: () async {
          //               Fluttertoast.showToast(
          //                   msg: "Loading..",
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.TOP,
          //                   timeInSecForIosWeb: 1,
          //                   backgroundColor: Colors.red,
          //                   textColor: Colors.white,
          //                   fontSize: 16.0);
          //               Navigator.pushNamed(context, '/listsPage',
          //                   arguments: 'NO-ANSWER');
          //             },
          //             child: Text('Total No Answer',
          //                 style: TextStyle(fontSize: 20.0)))
          //       ]),
          //       Column(children: [
          //         Text(totalNoAnswer, style: TextStyle(fontSize: 20.0))
          //       ]),
          //     ]),
          //     TableRow(children: [
          //       Column(children: [
          //         GestureDetector(
          //             onTap: () async {
          //               Fluttertoast.showToast(
          //                   msg: "Loading..",
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.TOP,
          //                   timeInSecForIosWeb: 1,
          //                   backgroundColor: Colors.red,
          //                   textColor: Colors.white,
          //                   fontSize: 16.0);
          //               Navigator.pushNamed(context, '/listsPage',
          //                   arguments: 'IN-PROGRESS');
          //             },
          //             child: Text('Total In-Progress',
          //                 style: TextStyle(fontSize: 20.0)))
          //       ]),
          //       Column(children: [
          //         Text(totalInProgress, style: TextStyle(fontSize: 20.0))
          //       ]),
          //     ]),
          //     TableRow(children: [
          //       Column(children: [
          //         GestureDetector(
          //             onTap: () async {
          //               Fluttertoast.showToast(
          //                   msg: "Loading..",
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.TOP,
          //                   timeInSecForIosWeb: 1,
          //                   backgroundColor: Colors.red,
          //                   textColor: Colors.white,
          //                   fontSize: 16.0);
          //               Navigator.pushNamed(context, '/listsPage',
          //                   arguments: 'PRODUCT-NOT-AVAILABLE');
          //             },
          //             child: Text('Total Product Not Available',
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(fontSize: 20.0)))
          //       ]),
          //       Column(children: [
          //         Text(totalPna, style: TextStyle(fontSize: 20.0))
          //       ]),
          //     ]),
          //     TableRow(children: [
          //       Column(children: [
          //         GestureDetector(
          //             onTap: () async {
          //               Fluttertoast.showToast(
          //                   msg: "Loading..",
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.TOP,
          //                   timeInSecForIosWeb: 1,
          //                   backgroundColor: Colors.red,
          //                   textColor: Colors.white,
          //                   fontSize: 16.0);
          //               Navigator.pushNamed(context, '/listsPage',
          //                   arguments: 'FOLLOW-UP');
          //             },
          //             child: Text('Total Follow Up',
          //                 style: TextStyle(fontSize: 20.0)))
          //       ]),
          //       Column(children: [
          //         Text(totalFollowUp, style: TextStyle(fontSize: 20.0))
          //       ]),
          //     ]),
          //     TableRow(children: [
          //       Column(children: [
          //         GestureDetector(
          //             onTap: () async {
          //               Fluttertoast.showToast(
          //                   msg: "Loading..",
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.TOP,
          //                   timeInSecForIosWeb: 1,
          //                   backgroundColor: Colors.red,
          //                   textColor: Colors.white,
          //                   fontSize: 16.0);
          //               Navigator.pushNamed(context, '/listsPage',
          //                   arguments: 'CANCEL');
          //             },
          //             child: Text('Total Cancel',
          //                 style: TextStyle(fontSize: 20.0)))
          //       ]),
          //       Column(children: [
          //         Text(totalCancel, style: TextStyle(fontSize: 20.0))
          //       ]),
          //     ]),
          //     TableRow(children: [
          //       Column(children: [
          //         GestureDetector(
          //             onTap: () async {
          //               Fluttertoast.showToast(
          //                   msg: "Loading..",
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.TOP,
          //                   timeInSecForIosWeb: 1,
          //                   backgroundColor: Colors.red,
          //                   textColor: Colors.white,
          //                   fontSize: 16.0);
          //               Navigator.pushNamed(context, '/listsPage',
          //                   arguments: 'INVOICED');
          //             },
          //             child: Text('Total Invoiced',
          //                 style: TextStyle(fontSize: 20.0)))
          //       ]),
          //       Column(children: [
          //         Text(totalInvoice, style: TextStyle(fontSize: 20.0))
          //       ]),
          //     ]),
          //   ],
          // ),
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
          // Container(
          //   alignment: Alignment.topLeft,
          //   padding: EdgeInsets.only(top: 50.0, left: 10.0),
          //   child: Text(
          //     'Logged In As $employID',
          //     textAlign: TextAlign.left,

          //     style: TextStyle(color: Colors.grey,),
          //   ),
          // ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(top: 50.0, right: 10.0),
            child: Text(
              'Version $version\nDeveloped By Fair Group,\nIT Software Team',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.grey),
            ),
          )
          //if (isLoading)
          //Text("Data is loading...", style: TextStyle(fontSize: 40.0))
        ],
      ),
    );
  }
}
