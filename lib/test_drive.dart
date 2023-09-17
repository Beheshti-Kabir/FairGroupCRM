// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:login_prac/New_Lead.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/main.dart';
import 'package:login_prac/new_lead_transaction.dart';
import 'package:login_prac/summery.dart';
import 'package:login_prac/test_drive_constants.dart';
import 'package:login_prac/utils/sesssion_manager.dart';

String resultOfUpdateStatus = '';

class TestDrivePage extends StatefulWidget {
  const TestDrivePage({Key? key}) : super(key: key);

  @override
  _TestDrivePageState createState() => _TestDrivePageState();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/newlead': (BuildContext context) => NewLead(),
        '/newleadtransaction': (BuildContext context) => NewLeadTransaction(),
        '/logInPage': (BuildContext context) => MyHomePage(),
      },
    );
  }
}

class _TestDrivePageState extends State<TestDrivePage> {
  bool isLoading = false;
  bool gotData = false;
  bool isSearching = false;
  String fromDateController = '';
  String toDateController = '';
  var fromDate = '';
  var toDate = '';
  var phoneNumber = '';
  final leadNoController = TextEditingController();

  late dynamic response;
  // late var totalInvoice = '';
  // late var totalPna = '';
  // late var totalFollowUp = '';
  // late var totalLead = '';
  // late var totalCancel = '';
  // late var totalInProgress = '';
  // late var totalNoAnswer = '';
  late String testDriveStatus = '';
  List<dynamic> statusValue = [];
  List<String> testDriveStatusList = ['', 'OPEN', 'APPROVED', 'DENIED'];
  String _testDriveStatus = '';
  String employID = '';
  String leadNo = '';

  @override
  initState() {
    super.initState();
    print('init');
    getEmployID();
  }

  bool formValidator() {
    String leadModeValid = _testDriveStatus;

    if (leadModeValid.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  getEmployID() async {
    employID = await localGetEmployeeID();
    print('getEmployID: $employID');
  }

  Future<String> chnageTDApprovalStatus(String leadNo, String status) async {
    String localURL = Constants.globalURL;
    resultOfUpdateStatus = '';

    var responsed = await http.post(Uri.parse('$localURL/approveLead'),
        //Uri.parse('http://10.100.17.125:8090/rbd/leadInfoApi/approveLeadR'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'leadNo': leadNo,
          'approvalStatus': status,
        }));

    print(status);
    String con = jsonDecode(responsed.body)['result'].toString();
    print('result=== $con');
    if (con == 'Success') {
      return 'Done';
    } else {
      return 'Failed';
    }
    //print('aaaaaaaaaaaaaaaaaaaa' + resultOfUpdateStatus);
  }

  getSearchData() async {
    setState(() {
      isSearching = true;
    });
    statusValue = [];
    // setState(() {
    //   isLoading = true;
    //   print("isLoading");
    //   //print(json.decode(response.body)['totalLead']);
    //   //result = json.decode(response.body);
    //   //print("lead=" + json.decode(response.body)['totalLead']);
    //   // result['leadInfo'];
    // });
    testDriveStatus = _testDriveStatus.toString();
    toDate = toDateController.toString();
    fromDate = fromDateController.toString();
    leadNo = leadNoController.text;
    print(leadNo.toString());
    print('date$toDate');

    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/getDataByStatus'),
        //Uri.parse('http://10.100.17.125:8090/rbd/leadInfoApi/getDataByStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': Constants.employeeId,
          'stepType': 'TEST-DRIVE',
          'toDate': toDate,
          'fromDate': fromDate,
          'phoneNo': phoneNumber,
          'allSearch': 'FALSE',
          'testDriveApprovalStatus': testDriveStatus,
          'leadNo': leadNo,
        }));

    statusValue = jsonDecode(response.body)['leadList'];
    print(statusValue.toString());

    setState(() {
      print(statusValue.length.toString());
      if (statusValue.isEmpty) {
        isSearching = false;
        Fluttertoast.showToast(
            msg: "NO DATA...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  getDateSearchNumber() {
    setState(() {
      toDateController = '';
      fromDateController = '';
      fromDateController = '';
    });
    getSearchData();
  }

  @override
  Widget build(BuildContext context) {
    //final argument = ModalRoute.of(context)
    //stepType = argument;
    //print(stepType);

    // if (!gotData) {
    //   getStepType();
    //   gotData = true;
    // }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Search Test Drive Lead"),
        ),
        body:
            // statusValue.isNotEmpty
            //     ?
            SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                  // width: 100.0,fa
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                  child: Container(
                      padding: EdgeInsets.only(left: 5.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.lightBlueAccent,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.topLeft,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: leadNoController,
                        decoration: InputDecoration(
                          labelText: 'Lead No* ',
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'OR',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightBlueAccent,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () async {
                        final DateTime? from = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2030));
                        if (from != null) {
                          setState(() {
                            //customerDOBdate = dob;
                            fromDateController = from.toString().split(' ')[0];
                            print(fromDateController.toString());
                          });
                        }
                        // DatePicker.showDatePicker(context,
                        //     showTitleActions: true,
                        //     //     onChanged: (date) {
                        //     //   print('change $date in time zone ' +
                        //     //       date.timeZoneOffset.inHours.toString());
                        //     // },
                        //     onConfirm: (date) {
                        //   print('confirm meating date $date');
                        //   fromDate.toString();
                        //   var taskDateDay = date.day.toInt() < 10
                        //       ? '0${date.day}'
                        //       : date.day.toString();
                        //   var taskDateMonth = date.month.toInt() < 10
                        //       ? '0${date.month}'
                        //       : date.month.toString();
                        //   setState(() {
                        //     fromDateController = '${date.year}-$taskDateMonth-$taskDateDay';
                        //   });
                        // }, currentTime: DateTime.now());
                      },
                      child: Text(
                        "From Date* : $fromDateController",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightBlueAccent,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () async {
                        final DateTime? to = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2030));
                        if (to != null) {
                          setState(() {
                            //customerDOBdate = dob;
                            toDateController = to.toString().split(' ')[0];
                            print(toDateController.toString());
                          });
                        }
                        // DatePicker.showDatePicker(context,
                        //     showTitleActions: true,
                        //     //     onChanged: (date) {
                        //     //   print('change $date in time zone ' +
                        //     //       date.timeZoneOffset.inHours.toString());
                        //     // },
                        //     onConfirm: (date) {
                        //   print('confirm meating date $date');
                        //   toDate.toString();
                        //   var taskDateDay = date.day.toInt() < 10
                        //       ? '0${date.day}'
                        //       : date.day.toString();
                        //   var taskDateMonth = date.month.toInt() < 10
                        //       ? '0${date.month}'
                        //       : date.month.toString();
                        //   setState(() {
                        //     toDateController = '${date.year}-$taskDateMonth-$taskDateDay';
                        //   });
                        // }, currentTime: DateTime.now());
                      },
                      child: Text(
                        "To Date* : $toDateController",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.lightBlueAccent,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Test-Drive Approval Status:",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              )),
                          Row(
                            // ignore: pre
                            //fer_const_literals_to_create_immutables
                            children: <Widget>[
                              DropdownButton<String>(
                                value: _testDriveStatus,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 18.0,
                                elevation: 16,
                                style: const TextStyle(color: Colors.blue),
                                underline: Container(
                                  height: 0,
                                  color: Colors.blue,
                                ),
                                onChanged: (String? newvalueSales) {
                                  setState(() {
                                    _testDriveStatus = newvalueSales!;
                                    // List<String> salesPersonControllerMiddle =
                                    //     _salesPersonController.split(' ');
                                    // _salesPersonController =
                                    //     salesPersonControllerMiddle[0];
                                  });
                                },
                                items: testDriveStatusList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          bool isValid = formValidator();
                          leadNoController.text.isNotEmpty
                              ? getDateSearchNumber()
                              : isValid == true
                                  ? Fluttertoast.showToast(
                                      msg: "Lead Mode Field Missing...",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0)
                                  : toDateController == ''
                                      ? Fluttertoast.showToast(
                                          msg: "To Date Field Missing..",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0)
                                      : fromDateController == ''
                                          ? Fluttertoast.showToast(
                                              msg: "From Date Field Missing..",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0)
                                          : getSearchData();
                        },
                        child: SizedBox(
                          height: 30.0,
                          width: 100.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.blueAccent,
                            color: Colors.blue[800],
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Search',
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
                isSearching == false
                    ? Container()
                    : statusValue.isNotEmpty
                        ? ListView.builder(
                            itemCount: statusValue.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, bottom: 10.0, right: 4.0),
                                  child: GestureDetector(
                                    onTap: () => {
                                      if (statusValue[index]['tdApprovalStatus']
                                              .toString() ==
                                          'APPROVED')
                                        {
                                          TestDriveConstants.leadNo =
                                              statusValue[index]['leadNo']
                                                  .toString(),
                                          TestDriveConstants.customerName =
                                              statusValue[index]['customerName']
                                                  .toString(),
                                          TestDriveConstants.customerNumber =
                                              statusValue[index]['contactNo']
                                                  .toString(),
                                          TestDriveConstants.tdModelName =
                                              statusValue[index]['tdModelName']
                                                  .toString(),
                                          TestDriveConstants.tdApprovalStatus =
                                              statusValue[index]
                                                      ['tdApprovalStatus']
                                                  .toString(),
                                          TestDriveConstants.tdRequestedTime =
                                              statusValue[index]
                                                      ['tdRequestedTime']
                                                  .toString(),
                                          TestDriveConstants.tdStatus =
                                              statusValue[index]['tdStatus']
                                                  .toString(),
                                          TestDriveConstants.tdTime =
                                              statusValue[index]['tdTime']
                                                  .toString(),
                                          TestDriveConstants.finance =
                                              statusValue[index]
                                                      ['isAutoFinance']
                                                  .toString(),
                                          Navigator.of(context)
                                              .pushNamed('/test-driveUpdate')
                                        }
                                      else
                                        {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "THIS LEAD IS OPEN/DENIED...\nPLESAE CONTACT ADMIN",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0)
                                        }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.blueAccent,
                                            width: 3.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Table(
                                        defaultColumnWidth:
                                            FixedColumnWidth(180.0),
                                        border: TableBorder.all(
                                            color: Colors.white,
                                            style: BorderStyle.solid,
                                            width: 2),
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          TableRow(children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Text('Lead No',
                                                    style: TextStyle(
                                                        fontSize: 20.0))),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                  statusValue[index]['leadNo']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text('Customer Name',
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                  statusValue[index]
                                                          ['customerName']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text('Customer Number',
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                  statusValue[index]
                                                          ['contactNo']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                          ]),
                                          // TableRow(children: [
                                          //   Padding(
                                          //     padding:
                                          //         const EdgeInsets.only(left: 4.0),
                                          //     child: Text('Company name',
                                          //         style: TextStyle(fontSize: 20.0)),
                                          //   ),
                                          //   Padding(
                                          //     padding:
                                          //         const EdgeInsets.only(left: 4.0),
                                          //     child: Text(
                                          //         statusValue[index]['companyName']
                                          //             .toString()
                                          //             .split("T")[0],
                                          //         style: TextStyle(fontSize: 20.0)),
                                          //   ),
                                          // ]),
                                          TableRow(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text('Lead Create Time',
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                  "${statusValue[index]['leadCreateTime'].toString().split(" ")[0]}\n at \n${statusValue[index]['leadCreateTime'].toString().split(" ")[1]}",
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                          ]),
                                          // TableRow(children: [
                                          //   Padding(
                                          //     padding:
                                          //         const EdgeInsets.only(left: 4.0),
                                          //     child: Text('Customer Mail',
                                          //         style: TextStyle(fontSize: 20.0)),
                                          //   ),
                                          //   Padding(
                                          //     padding:
                                          //         const EdgeInsets.only(left: 4.0),
                                          //     child: Text(
                                          //         statusValue[index]['email']
                                          //             .toString(),
                                          //         style: TextStyle(fontSize: 20.0)),
                                          //   ),
                                          // ]),
                                          // TableRow(children: [
                                          //   Padding(
                                          //     padding:
                                          //         const EdgeInsets.only(left: 4.0),
                                          //     child: Text('Lead Type',
                                          //         style: TextStyle(fontSize: 20.0)),
                                          //   ),
                                          //   Padding(
                                          //     padding:
                                          //         const EdgeInsets.only(left: 4.0),
                                          //     child: Text(
                                          //         statusValue[index]['leadCategory']
                                          //             .toString(),
                                          //         style: TextStyle(fontSize: 20.0)),
                                          //   ),
                                          // ]),
                                          // TableRow(children: [
                                          //   Padding(
                                          //     padding:
                                          //         const EdgeInsets.only(left: 4.0),
                                          //     child: Text('Lead Prospect Type',
                                          //         style: TextStyle(fontSize: 20.0)),
                                          //   ),
                                          //   Padding(
                                          //     padding:
                                          //         const EdgeInsets.only(left: 4.0),
                                          //     child: Text(
                                          //         statusValue[index]
                                          //                 ['leadProspectType']
                                          //             .toString(),
                                          //         style: TextStyle(fontSize: 20.0)),
                                          //   ),
                                          // ]),
                                          TableRow(children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Text('Model Name',
                                                    style: TextStyle(
                                                        fontSize: 20.0))),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                  statusValue[index]
                                                          ['tdModelName']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                          ]),
                                          (statusValue[index]['tdApprovalStatus']
                                                          .toString() ==
                                                      'OPEN' &&
                                                  (Constants.employeeId ==
                                                          'T00100' ||
                                                      Constants.employeeId ==
                                                          'M00129'))
                                              ? TableRow(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0),
                                                    child: Text(
                                                        'Change Approval Status',
                                                        style: TextStyle(
                                                            fontSize: 20.0)),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              elevation: 24,
                                                              shadowColor:
                                                                  Colors.black,
                                                              title: Text(
                                                                'Status Change',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        25),
                                                              ),
                                                              content: Text(
                                                                'What status do you want for the Lead No: ${statusValue[index]['leadNo']} ?',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              actions: [
                                                                CupertinoDialogAction(
                                                                  onPressed:
                                                                      () async {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Saving..",
                                                                        toastLength:
                                                                            Toast
                                                                                .LENGTH_SHORT,
                                                                        gravity:
                                                                            ToastGravity
                                                                                .TOP,
                                                                        timeInSecForIosWeb:
                                                                            1,
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            16.0);
                                                                    var respon = await chnageTDApprovalStatus(
                                                                        statusValue[index]['leadNo']
                                                                            .toString(),
                                                                        'APPROVED');
                                                                    // print('asdasdasdasd=====' +
                                                                    //     respon
                                                                    //         .toString());
                                                                    if (respon
                                                                            .toString() ==
                                                                        'Done') {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Status Change to APPROVED..",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .TOP,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0);
                                                                      setState(
                                                                          () {
                                                                        statusValue[index]['tdApprovalStatus'] =
                                                                            'APPROVED';
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    } else {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "There might be some issue.\nPlease try again..",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .TOP,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0);
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    'Approved',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                CupertinoDialogAction(
                                                                  onPressed:
                                                                      () async {
                                                                    Fluttertoast.showToast(
                                                                        msg:
                                                                            "Saving..",
                                                                        toastLength:
                                                                            Toast
                                                                                .LENGTH_SHORT,
                                                                        gravity:
                                                                            ToastGravity
                                                                                .TOP,
                                                                        timeInSecForIosWeb:
                                                                            1,
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            16.0);
                                                                    var respon = await chnageTDApprovalStatus(
                                                                        statusValue[index]['leadNo']
                                                                            .toString(),
                                                                        'DENIED');
                                                                    print('asdasdasdasd=====$resultOfUpdateStatus');
                                                                    if (respon ==
                                                                        'Done') {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "Status Change to DENIED..",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .TOP,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0);
                                                                      setState(
                                                                          () {
                                                                        statusValue[index]['tdApprovalStatus'] =
                                                                            'DENIED';
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    } else {
                                                                      Fluttertoast.showToast(
                                                                          msg:
                                                                              "There might be some issue.\nPlease try again..",
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,
                                                                          gravity: ToastGravity
                                                                              .TOP,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          textColor: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0);
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    'Denied',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        style: TextButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.lightBlue[
                                                                    100]),
                                                        child: Text(
                                                            statusValue[index][
                                                                    'tdApprovalStatus']
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Colors
                                                                    .black)),
                                                      )),
                                                ])
                                              : TableRow(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0),
                                                    child: Text(
                                                        'Approval Status',
                                                        style: TextStyle(
                                                            fontSize: 20.0)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0),
                                                    child: Text(
                                                        statusValue[index][
                                                                'tdApprovalStatus']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20.0)),
                                                  ),
                                                ]),
                                          TableRow(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text('Requested Time',
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                  statusValue[index]
                                                          ['tdRequestedTime']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Text('Test-Drive Status',
                                                    style: TextStyle(
                                                        fontSize: 20.0))),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                  statusValue[index]['tdStatus']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text('Test-Drive Time',
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                  statusValue[index]['tdTime']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text('Auto Finance',
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                  statusValue[index]
                                                          ['isAutoFinance']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),

                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => SummeryPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: SizedBox(
                          height: 40.0,
                          width: 170.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.blueAccent,
                            color: Colors.blue[800],
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                'Summary Page',
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
                SizedBox(
                  height: 20.0,
                )
                //if (isLoading)
                //Text("Data is loading...", style: TextStyle(fontSize: 40.0))
              ],
            ),
          ),
        )
        // : Center(
        //     child: CircularProgressIndicator(),
        //   ),
        );
  }
}
