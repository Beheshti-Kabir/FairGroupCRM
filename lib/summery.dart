// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_prac/New_Lead.dart';
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
    response = await http
        .get(Uri.parse('http://10.100.17.127:8090/rbd/leadInfoApi/getSummary'));

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
                  Text('Total No-Answer', style: TextStyle(fontSize: 20.0))
                ]),
                Column(children: [
                  Text(totalFollowUp, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text('Total In-progress', style: TextStyle(fontSize: 20.0))
                ]),
                Column(children: [
                  Text(totalInProgress, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text('Total Product not available',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0))
                ]),
                Column(children: [
                  Text(totalPna, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text('Total FollowUp', style: TextStyle(fontSize: 20.0))
                ]),
                Column(children: [
                  Text(totalFollowUp, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text('Total Cancel', style: TextStyle(fontSize: 20.0))
                ]),
                Column(children: [
                  Text(totalCancel, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
              TableRow(children: [
                Column(children: [
                  Text('Total Invoice', style: TextStyle(fontSize: 20.0))
                ]),
                Column(children: [
                  Text(totalInvoice, style: TextStyle(fontSize: 20.0))
                ]),
              ]),
            ],
          ),
          //if (isLoading)
          //Text("Data is loading...", style: TextStyle(fontSize: 40.0))
        ],
      ),
    );
  }
}
