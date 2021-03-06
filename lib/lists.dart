// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

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

class ListsPage extends StatefulWidget {
  @override
  _ListsPageState createState() => _ListsPageState();

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/newlead': (BuildContext context) => new NewLead(),
        '/newleadtransaction': (BuildContext context) =>
            new NewLeadTransaction(),
        '/logInPage': (BuildContext context) => new MyHomePage(),
      },
    );
  }
}

class _ListsPageState extends State<ListsPage> {
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
  late String stepType = '';
  List<dynamic> statusValue = [];

  @override
  initState() {
    super.initState();
    print('init');
  }

  getStepType() async {
    // setState(() {
    //   isLoading = true;
    //   print("isLoading");
    //   //print(json.decode(response.body)['totalLead']);
    //   //result = json.decode(response.body);
    //   //print("lead=" + json.decode(response.body)['totalLead']);
    //   // result['leadInfo'];
    // });

    response = await http.post(
        Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/getDataByStatus'),
        //Uri.parse('http://10.100.18.167:8090/rbd/leadInfoApi/getDataByStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': Constants.employeeId,
          'stepType': stepType,
        }));
    //print("getStepType");
    //print(json.decode(response.body).toString());
    //var model = LeadListModel.fromJson();
    statusValue = jsonDecode(response.body)['leadList'];
    //print("\ntype"+statusValue[index].toString());

    //print(
    //    "\n2nd" +  dex]['leadProducts'][0]['LeadProduct'].toString());

    //print("done something =" + statusValue[index]['contactNo'].toString());
    // print(response.statuscode);
    setState(() {
      // if (response.statusCode == 200) {
      // } else {
      //throw Exception('Failed to load album');
      //}

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

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments as String;
    stepType = argument;
    print(stepType);

    if (!gotData) {
      getStepType();
      gotData = true;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
            "LAST " + statusValue.length.toString() + " " + stepType + " LEAD"),
      ),
      body: statusValue.isNotEmpty
          ? SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                      // width: 100.0,fa
                    ),
                    ListView.builder(
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
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Customer Name',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['customerName']
                                            .toString(),
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Customer Number',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['contactNo']
                                            .toString(),
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text('Customer Address',
                                          style: TextStyle(fontSize: 20.0))),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['address']
                                            .toString(),
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Company name',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['companyName']
                                            .toString()
                                            .split("T")[0],
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Lead Create Time',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['leadCreateTime']
                                                .toString()
                                                .split(" ")[0] +
                                            "\n at \n" +
                                            statusValue[index]['leadCreateTime']
                                                .toString()
                                                .split(" ")[1],
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Customer Mail',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['email'].toString(),
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text('Lead Source',
                                          style: TextStyle(fontSize: 20.0))),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['leadSource']
                                            .toString(),
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Step Type',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['stepType']
                                            .toString(),
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Created By',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['createdBy']
                                            .toString(),
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Products',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['productName']
                                            .toString()
                                            .substring(
                                                1,
                                                statusValue[index]
                                                            ['productName']
                                                        .toString()
                                                        .length -
                                                    1),
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => new SummeryPage()),
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
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
