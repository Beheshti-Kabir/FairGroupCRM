// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:login_prac/New_Lead.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/main.dart';
import 'package:login_prac/new_lead_transaction.dart';
import 'package:login_prac/summery.dart';

class FollowUpListsPage extends StatefulWidget {
  const FollowUpListsPage({Key? key}) : super(key: key);

  @override
  _FollowUpListsPageState createState() => _FollowUpListsPageState();

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

class _FollowUpListsPageState extends State<FollowUpListsPage> {
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
    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String searchDate = formatter.format(now);

    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/getFollowUpInfo'),
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
    //print("getStepType");
    //print(json.decode(response.body).toString());
    //var model = LeadListModel.fromJson();
    statusValue = jsonDecode(response.body)['leadList'];
    print(statusValue.toString());
    //print("\ntype"+statusValue[index].toString());

    //print(
    //    "\n2nd" +  dex]['leadProducts'][0]['LeadProduct'].toString());

    //print("done something =" + statusValue[index]['contactNo'].toString());
    // print(response.statuscode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!gotData) {
      getStepType();
      gotData = true;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("TODAYS FOLLOW UPS")),
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
                                        "${statusValue[index]['leadCreateTime'].toString().split(" ")[0]}\n at \n${statusValue[index]['leadCreateTime'].toString().split(" ")[1]}",
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text('Next Follow-up Date',
                                          style: TextStyle(fontSize: 20.0))),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['followupDate']
                                            .toString()
                                            .split("T")[0],
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text('Last Trsansaction Date',
                                          style: TextStyle(fontSize: 20.0))),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
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
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Lead Type',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['leadCategory']
                                            .toString(),
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Lead Prospect Type',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                        statusValue[index]['leadProspectType']
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
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text('Last Transaction Remarks',
                                        style: TextStyle(fontSize: 20.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
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
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
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
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
