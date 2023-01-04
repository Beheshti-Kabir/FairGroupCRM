// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:login_prac/New_Lead.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/lists.dart';
import 'package:login_prac/logInPage.dart';
import 'package:login_prac/main.dart';
import 'package:login_prac/new_lead_transaction.dart';
import 'package:login_prac/utils/sesssion_manager.dart';

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
  // late var totalInvoice = '';
  // late var totalPna = '';
  // late var totalFollowUp = '';
  // late var totalLead = '';
  // late var totalCancel = '';
  // late var totalInProgress = '';
  // late var totalNoAnswer = '';
  String version = Constants.version;
  String employID = '';
  List<dynamic> stepNameList = [];
  List<dynamic> stepNameValueList = [];
  int number = 0;
  int count = 0;
  int next = 1;
  int row = 0;
  int totalLead = 0;
  int followUpDateCount = 0;
  late var dataJSON;

  @override
  initState() {
    super.initState();
    getEmployID();
  }

  getEmployID() async {
    employID = await localGetEmployeeID();
    print('getEmployID: ' + employID);
    getFollowUpData();
    getSummary();
  }

  getFollowUpData() async {
    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String searchDate = formatter.format(now);

    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse(localURL + '/getFollowUpInfo'),
        //Uri.parse('http://10.100.17.125:8090/rbd/leadInfoApi/getFollowUpInfo'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': Constants.employeeId,
          'searchDate': searchDate,
          'allSearch': 'FALSE'
        }));
    var statusValue = jsonDecode(response.body)['leadList'];
    print(statusValue.toString());
    followUpDateCount = statusValue.length;
    print(searchDate);
    print('===============================' + followUpDateCount.toString());
    setState(() {});
  }

  getSummary() async {
    setState(() {});

    print('obj=$employID');
    String localURL = Constants.globalURL;
    response = await http.post(Uri.parse(localURL + '/getSummary'),
        //Uri.parse('http://10.100.17.125:8090/rbd/leadInfoApi/getSummary'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': employID,
        }));
    print('toooooooooooo' + json.decode(response.body)[0][0].toString());
    dataJSON = json.decode(response.body);
    number = dataJSON.length;
    row = (number / 2).round();
    for (int i = 0; i < number; i++) {
      stepNameList.add(dataJSON[i][0].toString());
      stepNameValueList.add(dataJSON[i][1].toString());
      // if (dataJSON[i][0].toString() != 'CANCEL' ||
      //     dataJSON[i][0].toString() != 'INVOICED' ||
      //     dataJSON[i][0].toString() != 'LOST' ||
      //     dataJSON[i][0].toString() != 'INVALID') {
      //   totalLead += int.parse(dataJSON[i][1].toString());
      // }
      if (dataJSON[i][0].toString() != 'LOST') {
        if (dataJSON[i][0].toString() != 'INVOICED') {
          if (dataJSON[i][0].toString() != 'CANCEL') {
            if (dataJSON[i][0].toString() != 'INVALID') {
              totalLead += int.parse(dataJSON[i][1].toString());
            }
          }
        }
      }
    }
    print('total LEAD ============' + totalLead.toString());
    print(stepNameValueList.toString());
    setState(() {
      if (response.statusCode == 200) {
        isLoading = true;
      } else {
        print(response.body);
        throw Exception('Failed to load album');
      }

      // isLoading = false;
      // totalInvoice = json.decode(response.body)['totalInvoiced'].toString();
      // totalLead = json.decode(response.body)['totalLead'].toString();
      // totalPna = json.decode(response.body)['totalPna'].toString();
      // totalInProgress =
      //     json.decode(response.body)['totalInProgress'].toString();
      // totalFollowUp = json.decode(response.body)['totalFollowup'].toString();
      // totalCancel = json.decode(response.body)['totalCancel'].toString();
      // totalNoAnswer = json.decode(response.body)['totalNoAnswer'].toString();
    });
  }

  Widget build(BuildContext context) {
    if (!gotData) {
      getSummary();
      gotData = true;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Badge(
          showBadge: (followUpDateCount > 0) ? true : false,
          position: BadgePosition.topEnd(top: 05, end: 05),
          badgeContent: Text(
            followUpDateCount.toString(),
            style: const TextStyle(
                fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          child: IconButton(
            icon: Icon(Icons.notifications_active_outlined),
            onPressed: () {
              if (followUpDateCount == 0) {
                Fluttertoast.showToast(
                    msg: "No Pending Follow-up Leads",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                Navigator.of(context).pushNamed('/followUpListsPage');
              }
            },
          ),
        ),
        title: Text('Summary For $employID'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.manage_search,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/searchDateLead');
            },
          )
        ],
      ),
      body: (stepNameList.isNotEmpty)
          ? SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 25.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/newlead');
                              },
                              child: Container(
                                height: 60.0,
                                // width: 110.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(25.0),
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
                            padding:
                                EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 25.0),
                            child: Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('/newleadtransaction');
                                  },
                                  child: SizedBox(
                                    height: 60.0,
                                    //width: 170.0,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(25.0),
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
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
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
                                  totalLead == "0"
                                      ? Fluttertoast.showToast(
                                          msg: "No Data",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0)
                                      : Navigator.pushNamed(
                                          context, '/listsPage',
                                          arguments: 'TOTAL');
                                },
                                child: SizedBox(
                                  height: 60.0,
                                  //width: MediaQuery.of(context).size.width,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(25.0),
                                    //borderRadius: BorderRadius.(20.0),
                                    shadowColor:
                                        Color.fromARGB(255, 65, 133, 250),
                                    color: Colors.white,
                                    elevation: 7.0,
                                    child: Center(
                                      child: Text(
                                        'TOTAL ' +
                                            'LEAD' +
                                            '\n' +
                                            totalLead.toString(),
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
                            ),
                          ),
                        ]),
                    Column(
                      children: <Widget>[
                        ListView.builder(
                            itemCount: row,
                            primary: false,
                            //scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              // if (index == 0) {
                              //   count = 0;
                              //   next = 1;
                              // } else {
                              //   count = count + 2;
                              //   next = count + 1;
                              // }
                              return
                                  // Container(
                                  //   padding:
                                  //       EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  //   child: Stack(
                                  //     children: <Widget>[
                                  //       GestureDetector(
                                  //         onTap: () async {
                                  //           Fluttertoast.showToast(
                                  //               msg: "Loading..",
                                  //               toastLength: Toast.LENGTH_SHORT,
                                  //               gravity: ToastGravity.TOP,
                                  //               timeInSecForIosWeb: 1,
                                  //               backgroundColor: Colors.red,
                                  //               textColor: Colors.white,
                                  //               fontSize: 16.0);
                                  //           stepNameValueList[index] == "0"
                                  //               ? Fluttertoast.showToast(
                                  //                   msg: "No Data",
                                  //                   toastLength: Toast.LENGTH_SHORT,
                                  //                   gravity: ToastGravity.TOP,
                                  //                   timeInSecForIosWeb: 1,
                                  //                   backgroundColor: Colors.red,
                                  //                   textColor: Colors.white,
                                  //                   fontSize: 16.0)
                                  //               : Navigator.pushNamed(
                                  //                   context, '/listsPage',
                                  //                   arguments: stepNameList[index]);
                                  //         },
                                  //         child: SizedBox(
                                  //           height: 60.0,
                                  //           //width: 170.0,
                                  //           child: Material(
                                  //             //borderRadius: BorderRadius.(20.0),
                                  //             shadowColor:
                                  //                 Color.fromARGB(255, 65, 133, 250),
                                  //             color: Colors.white,
                                  //             elevation: 7.0,
                                  //             child: Center(
                                  //               child: Text(
                                  //                 'TOTAL ' +
                                  //                     stepNameList[index]
                                  //                         .toString() +
                                  //                     '\n' +
                                  //                     stepNameValueList[index]
                                  //                         .toString(),
                                  //                 style: TextStyle(
                                  //                   color: Colors.black,
                                  //                   fontWeight: FontWeight.bold,
                                  //                 ),
                                  //                 textAlign: TextAlign.center,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // );
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 7, 10, 7),
                                        child: Stack(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () async {
                                                Fluttertoast.showToast(
                                                    msg: "Loading..",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                stepNameValueList[index * 2] ==
                                                        "0"
                                                    ? Fluttertoast.showToast(
                                                        msg: "No Data",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.TOP,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0)
                                                    : Navigator.pushNamed(
                                                        context, '/listsPage',
                                                        arguments: stepNameList[
                                                            index * 2]);
                                              },
                                              child: SizedBox(
                                                height: 60.0,
                                                //width: 170.0,
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0),
                                                  //borderRadius: BorderRadius.(20.0),
                                                  shadowColor: Color.fromARGB(
                                                      255, 65, 133, 250),
                                                  color: Colors.white,
                                                  elevation: 7.0,
                                                  child: Center(
                                                    child: (stepNameList[
                                                                    index * 2]
                                                                .toString() ==
                                                            'IN-PROGRESS')
                                                        ? Text(
                                                            'TOTAL ZERO ACTIVITY LEAD\n' +
                                                                stepNameValueList[
                                                                        index *
                                                                            2]
                                                                    .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )
                                                        : Text(
                                                            'TOTAL ' +
                                                                stepNameList[
                                                                        index *
                                                                            2]
                                                                    .toString() +
                                                                '\n' +
                                                                stepNameValueList[
                                                                        index *
                                                                            2]
                                                                    .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ((index * 2) + 1 < number)
                                        ? Expanded(
                                            flex: 1,
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 7, 20, 7),
                                              child: Stack(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () async {
                                                      Fluttertoast.showToast(
                                                          msg: "Loading..",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity:
                                                              ToastGravity.TOP,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                      stepNameValueList[(index *
                                                                      2) +
                                                                  1] ==
                                                              "0"
                                                          ? Fluttertoast.showToast(
                                                              msg: "No Data",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .TOP,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0)
                                                          : Navigator.pushNamed(
                                                              context,
                                                              '/listsPage',
                                                              arguments:
                                                                  stepNameList[
                                                                      (index *
                                                                              2) +
                                                                          1]);
                                                    },
                                                    child: SizedBox(
                                                      height: 60.0,
                                                      //width: 170.0,
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.0),
                                                        //borderRadius: BorderRadius.(20.0),
                                                        shadowColor:
                                                            Color.fromARGB(255,
                                                                65, 133, 250),
                                                        color: Colors.white,
                                                        elevation: 7.0,
                                                        child: Center(
                                                          child: Text(
                                                            'TOTAL ' +
                                                                stepNameList[
                                                                        (index *
                                                                                2) +
                                                                            1]
                                                                    .toString() +
                                                                '\n' +
                                                                stepNameValueList[
                                                                        (index *
                                                                                2) +
                                                                            1]
                                                                    .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Expanded(flex: 1, child: Container())
                                  ]);
                            })
                      ],
                    ),

                    // /SizedBox(height: 50.0),
                    // Column(children: <Widget>[
                    //   Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Expanded(
                    //         flex: 1,
                    //         child: Container(
                    //           padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               GestureDetector(
                    //                 onTap: () async {
                    //                   Fluttertoast.showToast(
                    //                       msg: "Loading..",
                    //                       toastLength: Toast.LENGTH_SHORT,
                    //                       gravity: ToastGravity.TOP,
                    //                       timeInSecForIosWeb: 1,
                    //                       backgroundColor: Colors.red,
                    //                       textColor: Colors.white,
                    //                       fontSize: 16.0);
                    //                   totalLead == "0"
                    //                       ? Fluttertoast.showToast(
                    //                           msg: "No Data",
                    //                           toastLength: Toast.LENGTH_SHORT,
                    //                           gravity: ToastGravity.TOP,
                    //                           timeInSecForIosWeb: 1,
                    //                           backgroundColor: Colors.red,
                    //                           textColor: Colors.white,
                    //                           fontSize: 16.0)
                    //                       : Navigator.pushNamed(context, '/listsPage',
                    //                           arguments: 'TOTAL');
                    //                 },
                    //                 child: SizedBox(
                    //                   height: 60.0,
                    //                   //width: 170.0,
                    //                   child: Material(
                    //                     //borderRadius: BorderRadius.(20.0),
                    //                     shadowColor: Color.fromARGB(255, 65, 133, 250),
                    //                     color: Colors.white,
                    //                     elevation: 7.0,
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Total Lead\n' + totalLead,
                    //                         style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   SizedBox(
                    //     height: 20.0,
                    //   ),
                    //   Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Expanded(
                    //         flex: 1,
                    //         child: Container(
                    //           padding: EdgeInsets.all(10.0),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               GestureDetector(
                    //                 onTap: () async {
                    //                   Fluttertoast.showToast(
                    //                       msg: "Loading..",
                    //                       toastLength: Toast.LENGTH_SHORT,
                    //                       gravity: ToastGravity.TOP,
                    //                       timeInSecForIosWeb: 1,
                    //                       backgroundColor: Colors.red,
                    //                       textColor: Colors.white,
                    //                       fontSize: 16.0);
                    //                   totalInProgress == "0"
                    //                       ? Fluttertoast.showToast(
                    //                           msg: "No Data",
                    //                           toastLength: Toast.LENGTH_SHORT,
                    //                           gravity: ToastGravity.TOP,
                    //                           timeInSecForIosWeb: 1,
                    //                           backgroundColor: Colors.red,
                    //                           textColor: Colors.white,
                    //                           fontSize: 16.0)
                    //                       : Navigator.pushNamed(context, '/listsPage',
                    //                           arguments: 'IN-PROGRESS');
                    //                 },
                    //                 child: SizedBox(
                    //                   height: 60.0,
                    //                   //width: 170.0,
                    //                   child: Material(
                    //                     //borderRadius: BorderRadius.(20.0),
                    //                     shadowColor: Color.fromARGB(255, 65, 133, 250),
                    //                     color: Colors.white,
                    //                     elevation: 7.0,
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Total New Lead\n' + totalInProgress,
                    //                         style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         flex: 1,
                    //         child: Container(
                    //           padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               GestureDetector(
                    //                 onTap: () async {
                    //                   Fluttertoast.showToast(
                    //                       msg: "Loading..",
                    //                       toastLength: Toast.LENGTH_SHORT,
                    //                       gravity: ToastGravity.TOP,
                    //                       timeInSecForIosWeb: 1,
                    //                       backgroundColor: Colors.red,
                    //                       textColor: Colors.white,
                    //                       fontSize: 16.0);
                    //                   totalNoAnswer == "0"
                    //                       ? Fluttertoast.showToast(
                    //                           msg: "No Data",
                    //                           toastLength: Toast.LENGTH_SHORT,
                    //                           gravity: ToastGravity.TOP,
                    //                           timeInSecForIosWeb: 1,
                    //                           backgroundColor: Colors.red,
                    //                           textColor: Colors.white,
                    //                           fontSize: 16.0)
                    //                       : Navigator.pushNamed(context, '/listsPage',
                    //                           arguments: 'NO-ANSWER');
                    //                 },
                    //                 child: SizedBox(
                    //                   height: 60.0,
                    //                   //width: 170.0,
                    //                   child: Material(
                    //                     //borderRadius: BorderRadius.(20.0),
                    //                     shadowColor: Color.fromARGB(255, 65, 133, 250),
                    //                     color: Colors.white,
                    //                     elevation: 7.0,
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Total No Answer\n' + totalNoAnswer,
                    //                         style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   SizedBox(
                    //     height: 20.0,
                    //   ),
                    //   Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Expanded(
                    //         flex: 1,
                    //         child: Container(
                    //           padding: EdgeInsets.all(10.0),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               GestureDetector(
                    //                 onTap: () async {
                    //                   Fluttertoast.showToast(
                    //                       msg: "Loading..",
                    //                       toastLength: Toast.LENGTH_SHORT,
                    //                       gravity: ToastGravity.TOP,
                    //                       timeInSecForIosWeb: 1,
                    //                       backgroundColor: Colors.red,
                    //                       textColor: Colors.white,
                    //                       fontSize: 16.0);
                    //                   totalPna == "0"
                    //                       ? Fluttertoast.showToast(
                    //                           msg: "No Data",
                    //                           toastLength: Toast.LENGTH_SHORT,
                    //                           gravity: ToastGravity.TOP,
                    //                           timeInSecForIosWeb: 1,
                    //                           backgroundColor: Colors.red,
                    //                           textColor: Colors.white,
                    //                           fontSize: 16.0)
                    //                       : Navigator.pushNamed(context, '/listsPage',
                    //                           arguments: 'PRODUCT-NOT-AVAILABLE');
                    //                 },
                    //                 child: SizedBox(
                    //                   height: 60.0,
                    //                   //width: 170.0,
                    //                   child: Material(
                    //                     //borderRadius: BorderRadius.(20.0),
                    //                     shadowColor: Color.fromARGB(255, 65, 133, 250),
                    //                     color: Colors.white,
                    //                     elevation: 7.0,
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Total Product Not Available\n' + totalPna,
                    //                         style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         flex: 1,
                    //         child: Container(
                    //           padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               GestureDetector(
                    //                 onTap: () async {
                    //                   Fluttertoast.showToast(
                    //                       msg: "Loading..",
                    //                       toastLength: Toast.LENGTH_SHORT,
                    //                       gravity: ToastGravity.TOP,
                    //                       timeInSecForIosWeb: 1,
                    //                       backgroundColor: Colors.red,
                    //                       textColor: Colors.white,
                    //                       fontSize: 16.0);
                    //                   totalFollowUp == "0"
                    //                       ? Fluttertoast.showToast(
                    //                           msg: "No Data",
                    //                           toastLength: Toast.LENGTH_SHORT,
                    //                           gravity: ToastGravity.TOP,
                    //                           timeInSecForIosWeb: 1,
                    //                           backgroundColor: Colors.red,
                    //                           textColor: Colors.white,
                    //                           fontSize: 16.0)
                    //                       : Navigator.pushNamed(context, '/listsPage',
                    //                           arguments: 'FOLLOW-UP');
                    //                 },
                    //                 child: SizedBox(
                    //                   height: 60.0,
                    //                   //width: 170.0,
                    //                   child: Material(
                    //                     //borderRadius: BorderRadius.(20.0),
                    //                     shadowColor: Color.fromARGB(255, 65, 133, 250),
                    //                     color: Colors.white,
                    //                     elevation: 7.0,
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Total Follow Up\n' + totalFollowUp,
                    //                         style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   SizedBox(
                    //     height: 20.0,
                    //   ),
                    //   Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Expanded(
                    //         flex: 1,
                    //         child: Container(
                    //           padding: EdgeInsets.all(10.0),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               GestureDetector(
                    //                 onTap: () async {
                    //                   Fluttertoast.showToast(
                    //                       msg: "Loading..",
                    //                       toastLength: Toast.LENGTH_SHORT,
                    //                       gravity: ToastGravity.TOP,
                    //                       timeInSecForIosWeb: 1,
                    //                       backgroundColor: Colors.red,
                    //                       textColor: Colors.white,
                    //                       fontSize: 16.0);
                    //                   totalCancel == "0"
                    //                       ? Fluttertoast.showToast(
                    //                           msg: "No Data",
                    //                           toastLength: Toast.LENGTH_SHORT,
                    //                           gravity: ToastGravity.TOP,
                    //                           timeInSecForIosWeb: 1,
                    //                           backgroundColor: Colors.red,
                    //                           textColor: Colors.white,
                    //                           fontSize: 16.0)
                    //                       : Navigator.pushNamed(context, '/listsPage',
                    //                           arguments: 'CANCEL');
                    //                 },
                    //                 child: SizedBox(
                    //                   height: 60.0,
                    //                   //width: 170.0,
                    //                   child: Material(
                    //                     //borderRadius: BorderRadius.(20.0),
                    //                     shadowColor: Color.fromARGB(255, 65, 133, 250),
                    //                     color: Colors.white,
                    //                     elevation: 7.0,
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Total Cancel\n' + totalCancel,
                    //                         style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         flex: 1,
                    //         child: Container(
                    //           padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               GestureDetector(
                    //                 onTap: () async {
                    //                   Fluttertoast.showToast(
                    //                       msg: "Loading..",
                    //                       toastLength: Toast.LENGTH_SHORT,
                    //                       gravity: ToastGravity.TOP,
                    //                       timeInSecForIosWeb: 1,
                    //                       backgroundColor: Colors.red,
                    //                       textColor: Colors.white,
                    //                       fontSize: 16.0);
                    //                   totalInvoice == "0"
                    //                       ? Fluttertoast.showToast(
                    //                           msg: "No Data",
                    //                           toastLength: Toast.LENGTH_SHORT,
                    //                           gravity: ToastGravity.TOP,
                    //                           timeInSecForIosWeb: 1,
                    //                           backgroundColor: Colors.red,
                    //                           textColor: Colors.white,
                    //                           fontSize: 16.0)
                    //                       : Navigator.pushNamed(context, '/listsPage',
                    //                           arguments: 'INVOICED');
                    //                 },
                    //                 child: SizedBox(
                    //                   height: 60.0,
                    //                   //width: 170.0,
                    //                   child: Material(
                    //                     //borderRadius: BorderRadius.(20.0),
                    //                     shadowColor: Color.fromARGB(255, 65, 133, 250),
                    //                     color: Colors.white,
                    //                     elevation: 7.0,
                    //                     child: Center(
                    //                       child: Text(
                    //                         'Total Invoiced\n' + totalInvoice,
                    //                         style: TextStyle(
                    //                           color: Colors.black,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ]),
                    // // Table(
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
                      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              storeLocalSetEmployeeID(
                                  Constants.employeeIDKey, '');
                              storeLocalSetLogInStatus(
                                  Constants.logInStatusKey, 'fail');
                              //Navigator.of(context).pushReplacementNamed('/logInPage');
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => new LogInPage()),
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
                      padding:
                          EdgeInsets.only(top: 50.0, right: 10.0, bottom: 10.0),
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
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
