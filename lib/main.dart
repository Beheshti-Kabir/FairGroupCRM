// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:async';
import 'dart:ui';
import 'package:footer/footer_view.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:login_prac/New_Lead.dart';
import 'package:login_prac/api_service.dart';
import 'package:login_prac/changePassword.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/follow_up_date_list.dart';
import 'package:login_prac/itemdetails.dart';
import 'package:login_prac/lists.dart';
import 'package:login_prac/logInPage.dart';
import 'package:login_prac/new_lead_new.dart';
import 'package:login_prac/new_lead_transaction.dart';
import 'package:login_prac/utils/sesssion_manager.dart';
import 'package:login_prac/search_lead_info.dart';
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
          '/newlead': (BuildContext context) => NewLeadNew(),
          '/newleadtransaction': (BuildContext context) => NewLeadTransaction(),
          '/itemdetails': (BuildContext context) => ItemDetails(),
          //'/logInPage': (BuildContext context) => MyHomePage(),
          '/listsPage': (BuildContext context) => ListsPage(),
          '/changePasswordPage': (BuildContext context) => ChangePasswordPage(),
          '/logInPage': (BuildContext context) => LogInPage(),
          '/searchDateLead': (BuildContext context) => SearchDateLead(),
          '/followUpListsPage': (BuildContext context) => FollowUpListsPage(),
        },
        home: MyHomePage(),
        builder: (context, widget) {
          /// Always Constant font size though change system font size
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  String route = '';
  void initState() {
    super.initState();
    getRoutePath();
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed(route));
  }

  getRoutePath() async {
    String vari = await localGetEmployeeID();
    Constants.employeeId = vari;
    print('main=' + vari);
    bool logInStatus = await localLoginStatus();
    if (logInStatus) {
      route = '/summery';
    } else {
      route = '/logInPage';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/fairgroup_logo.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
