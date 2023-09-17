// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:login_prac/New_Lead.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/main.dart';
import 'package:login_prac/new_lead_transaction.dart';
import 'package:login_prac/summery.dart';
import 'package:login_prac/utils/sesssion_manager.dart';

class SearchDateLead extends StatefulWidget {
  const SearchDateLead({Key? key}) : super(key: key);

  @override
  _SearchDateLeadState createState() => _SearchDateLeadState();

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

class _SearchDateLeadState extends State<SearchDateLead> {
  bool isLoading = false;
  bool gotData = false;
  bool isSearching = false;
  String fromDateController = '';
  String toDateController = '';
  var fromDate = '';
  var toDate = '';
  var phoneNumber = '';
  final phoneNumberController = TextEditingController();

  late dynamic response;
  // late var totalInvoice = '';
  // late var totalPna = '';
  // late var totalFollowUp = '';
  // late var totalLead = '';
  // late var totalCancel = '';
  // late var totalInProgress = '';
  // late var totalNoAnswer = '';
  late String stepType = '';
  List<dynamic> statusValue = [];
  List<String> leadModeList = [''];
  String _leadMode = '';
  String employID = '';

  @override
  initState() {
    super.initState();
    print('init');
    getEmployID();
  }

  bool formValidator() {
    String leadModeValid = _leadMode;

    if (leadModeValid.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  getEmployID() async {
    employID = await localGetEmployeeID();
    print('getEmployID: $employID');
    getSummary();
  }

  getSummary() async {
    setState(() {
      // isLoading = false;

      //print(json.decode(response.body)['totalLead']);
      //result = json.decode(response.body);
      //print("lead=" + json.decode(response.body)['totalLead']);
      // result['leadInfo'];
    });

    String localURL = Constants.globalURL;
    response = await http.post(Uri.parse('$localURL/getSummary'),
        //Uri.parse('http://fairbook.fairgroupbd.com/leadInfoApi/getSummary'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': employID,
        }));
    print('toooooooooooo${json.decode(response.body)[0][0]}');
    var dataJSON = json.decode(response.body);
    var number = dataJSON.length;
    for (int i = 0; i < number; i++) {
      leadModeList.add(dataJSON[i][0].toString());
      //stepNameValueList.add(dataJSON[i][1].toString());
      // if (dataJSON[i][0].toString() != 'CANCEL' ||
      //     dataJSON[i][0].toString() != 'INVOICED' ||
      //     dataJSON[i][0].toString() != 'LOST' ||
      //     dataJSON[i][0].toString() != 'INVALID') {
      //   totalLead += int.parse(dataJSON[i][1].toString());
      // }
      // if (dataJSON[i][0].toString() != 'LOST') {
      //   if (dataJSON[i][0].toString() != 'INVOICED') {
      //     if (dataJSON[i][0].toString() != 'CANCEL') {
      //       if (dataJSON[i][0].toString() != 'INVALID') {
      //         totalLead += int.parse(dataJSON[i][1].toString());
      //       }
      //     }
      //   }
      // }
    }
    //print('total LEAD ============' + totalLead.toString());
    print(leadModeList.toString());
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

  getSearchData() async {
    setState(() {
      isSearching = true;
    });
    // setState(() {
    //   isLoading = true;
    //   print("isLoading");
    //   //print(json.decode(response.body)['totalLead']);
    //   //result = json.decode(response.body);
    //   //print("lead=" + json.decode(response.body)['totalLead']);
    //   // result['leadInfo'];
    // });
    stepType = _leadMode.toString();
    toDate = toDateController.toString();
    fromDate = fromDateController.toString();
    phoneNumber = phoneNumberController.text;
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
          'stepType': stepType,
          'toDate': toDate,
          'fromDate': fromDate,
          'phoneNo': phoneNumber,
          'allSearch': 'FALSE'
        }));

    statusValue = jsonDecode(response.body)['leadList'];
    print(statusValue.toString());

    setState(() {
      print(statusValue.length.toString());
      if (statusValue.isEmpty) {
        isSearching = false;
        Fluttertoast.showToast(
            msg: "NO DATA IN THIS LEAD MODE...",
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
          title: Text("SEARCH LEAD LIST"),
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
                    child: TextButton(
                      onPressed: () async {
                        final DateTime? fromDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2030));
                        if (fromDate != null) {
                          setState(() {
                            //customerDOBdate = dob;
                            fromDateController =
                                fromDate.toString().split(' ')[0];
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
                        //     fromDateController =
                        //         '${date.year}-$taskDateMonth-$taskDateDay';
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
                        final DateTime? toDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2030));
                        if (toDate != null) {
                          setState(() {
                            //customerDOBdate = dob;
                            toDateController = toDate.toString().split(' ')[0];
                            print(toDate.toString());
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
                        //     toDateController =
                        //         '${date.year}-$taskDateMonth-$taskDateDay';
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
                          Text("Lead Mode",
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
                                value: _leadMode,
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
                                    _leadMode = newvalueSales!;
                                    // List<String> salesPersonControllerMiddle =
                                    //     _salesPersonController.split(' ');
                                    // _salesPersonController =
                                    //     salesPersonControllerMiddle[0];
                                  });
                                },
                                items: leadModeList
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

                Padding(
                  padding: const EdgeInsets.all(10),
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
                          TextField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              border: InputBorder.none,

                              // errorText: phoneNumberValid
                              //     ? 'Value Can\'t Be Empty'
                              //     : null,

                              labelText: 'Customer Contact : ',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.blue[700]),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(11)
                            ],
                          )
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
                          phoneNumberController.text.isNotEmpty
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
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 3.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Table(
                                    defaultColumnWidth: FixedColumnWidth(180.0),
                                    border: TableBorder.all(
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                        width: 2),
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text('Customer Name',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['customerName']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text('Customer Number',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['contactNo']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Text('Customer Address',
                                                style:
                                                    TextStyle(fontSize: 20.0))),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['address']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text('Company name',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['companyName']
                                                  .toString()
                                                  .split("T")[0],
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text('Lead Create Time',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              "${statusValue[index]['leadCreateTime'].toString().split(" ")[0]}\n at \n${statusValue[index]['leadCreateTime'].toString().split(" ")[1]}",
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Text('Next Follow-up Date',
                                                style:
                                                    TextStyle(fontSize: 20.0))),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['followupDate']
                                                  .toString()
                                                  .split("T")[0],
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Text(
                                                'Last Trsansaction Date',
                                                style:
                                                    TextStyle(fontSize: 20.0))),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]
                                                      ['lastTransactionDate']
                                                  .toString()
                                                  .split(" ")[0],
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      // TableRow(children: [
                                      //   Padding(
                                      //     padding: const EdgeInsets.only(left: 4.0),
                                      //     child: Text('Customer Mail',
                                      //         style: TextStyle(fontSize: 20.0)),
                                      //   ),
                                      //   Padding(
                                      //     padding: const EdgeInsets.only(left: 4.0),
                                      //     child: Text(
                                      //         statusValue[index]['email'].toString(),
                                      //         style: TextStyle(fontSize: 20.0)),
                                      //   ),
                                      // ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text('Lead Type',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['leadCategory']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text('Lead Prospect Type',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]
                                                      ['leadProspectType']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      // TableRow(children: [
                                      //   Padding(
                                      //       padding: const EdgeInsets.only(left: 4.0),
                                      //       child: Text('Lead Source',
                                      //           style: TextStyle(fontSize: 20.0))),
                                      //   Padding(
                                      //     padding: const EdgeInsets.only(left: 4.0),
                                      //     child: Text(
                                      //         statusValue[index]['leadSource']
                                      //             .toString(),
                                      //         style: TextStyle(fontSize: 20.0)),
                                      //   ),
                                      // ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text('Step Type',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['stepType']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text('Created By',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['createdBy']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text('Products',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['productName']
                                                  .toString()
                                                  .substring(
                                                      1,
                                                      statusValue[index][
                                                                  'productName']
                                                              .toString()
                                                              .length -
                                                          1),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              'Last Transaction Remarks',
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                              statusValue[index]['remarks']
                                                  .toString(),
                                              style: TextStyle(fontSize: 20.0)),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              );
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
