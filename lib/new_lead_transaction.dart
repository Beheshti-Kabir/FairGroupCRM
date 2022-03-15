import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:ffi';

//import 'package:flutter/src/material/dropdown.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/todo_new_lead_transaction.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

class NewLeadTransaction extends StatefulWidget {
  const NewLeadTransaction({Key? key}) : super(key: key);

  @override
  _NewLeadTransactionState createState() => _NewLeadTransactionState();
}

class _NewLeadTransactionState extends State<NewLeadTransaction> {
  final _leadNoController = TextEditingController();
  final _personNameController = TextEditingController();
  final _personContactController = TextEditingController();

  final _todoDescriptionController = TextEditingController();
  // final _meetDateController = TextEditingController();
  // final _executionDateController = TextEditingController();
  // final _followupDateController = TextEditingController();
  final _remarkController = TextEditingController();
  final _salesPersonController = TextEditingController();
  //final _stepNoControler = TextEditingController();

  final _todoController = TextEditingController();
  late final _stepController = TextEditingController();
  late final _cancelReasonController = TextEditingController();

  bool _leadNoValidate = false;
  bool _meetDateVaidate = false;
  bool _employIDValidate = false;
  bool _salesPersonValidate = false;
  bool _personNameValidate = false;
  bool _personContactValidate = false;
  bool isLoad = true;

  String leadinfo = '';
  String personName = '';
  String personContact = '';
  String todoType = '';
  String todoDescription = '';
  String meetDate = '';
  String executionDate = '';
  String followupDate = '';
  String remarks = '';
  String cancelReason = '';
  String salesPerson = '';
  String stepNo = '';
  List<String> todoTypeList = [''];
  List<String> stepNoList = [''];
  List<String> sales_person = [''];
  List<String> leadNoList = [''];
  List<String> cancelReasonList = [
    'Not interested Anymore',
    'Lost to Competitor',
    'Financial issue',
    'Better Offer from Competitor',
    'Product Not Available',
    ''
  ];
  late List<String> leadNoControllerMiddle;
  var meet_date = '';
  var execution_date = '';
  var followUp_date = '';

  List<Todo_New_Lead_Transaction> newLeadTransactionSend = [];

  late Todo_New_Lead_Transaction newLeadTransactionModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeadData();
    getLocation();

    //serviceEnable();
  }

  @override
  getLeadData() async {
    print("inside getData");
    final response = await http.post(
        Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/getLeadData'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': Constants.employeeId,
        }));

    salesPersonJSON = json.decode(response.body)['salesPersonList'];
    todoJSON = json.decode(response.body)['todoList'];
    stepJSON = json.decode(response.body)['stepList'];
    leadNoJSON = json.decode(response.body)['leadList'];

    salesPersonNumber = salesPersonJSON.length;

    // print(salesPersonJSON[4]['empCode'].toString() +
    //     ' ' +
    //     salesPersonJSON[4]['empName']);
    // print("leaving getData");
    for (var i = 0; i < salesPersonNumber; i++) {
      String salesPersonMiddle = salesPersonJSON[i]['empCode'].toString() +
          ' ' +
          salesPersonJSON[i]['empName'];
      sales_person.insert(0, salesPersonMiddle);
    }
    todoNumber = todoJSON.length;
    for (var i = 0; i < todoNumber; i++) {
      String todoMiddle = todoJSON[i].toString();
      todoTypeList.insert(0, todoMiddle);
    }

    stepNumber = stepJSON.length;
    for (var i = 0; i < stepNumber; i++) {
      String stepMiddle = stepJSON[i].toString();
      stepNoList.insert(0, stepMiddle);
    }

    leadNoNumber = leadNoJSON.length;
    for (var i = 0; i < leadNoNumber; i++) {
      String leadNoMiddle = leadNoJSON[i]['title'].toString();
      leadNoList.insert(0, leadNoMiddle);
    }
    print(todoTypeList);
    print(stepNoList);
    print(leadNoList);
  }

  formValidator() {
    String leadNo = _leadNoController.text;
    //String meetDate = _meetDateController.text;
    String salesPerson = _salesPersonController.text;
    String personNameValidation = _personNameController.text;
    String personContactValidation = _personContactController.text;
    setState(() {
      if (leadNo == null || leadNo.isEmpty) {
        _leadNoValidate = true;
      } else {
        _leadNoValidate = false;
      }
      if (personNameValidation == null || personNameValidation.isEmpty) {
        _personNameValidate = true;
      } else {
        _personNameValidate = false;
      }
      if (personContactValidation == null || personContactValidation.isEmpty) {
        _personContactValidate = true;
      } else {
        _personContactValidate = false;
      }
      if (Constants.employeeId == '' ||
          Constants.employeeId == null ||
          Constants.employeeId.isEmpty) {
        _employIDValidate = true;
      } else {
        _employIDValidate = false;
      }
      // if (meetDate == null || meet_date.isEmpty) {
      //   _meetDateVaidate = true;
      // } else {
      //   _meetDateVaidate = false;
      // }
      if (salesPerson == null || salesPerson.isEmpty) {
        _salesPersonValidate = true;
      } else {
        _salesPersonValidate = false;
      }
    });
    if (!_leadNoValidate &&
        !_personNameValidate &&
        !_personContactValidate &&
        !_salesPersonValidate &&
        !_employIDValidate) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> createAlbum() async {
    var response = await http.post(
        Uri.parse(
            'http://202.84.44.234:9085/rbd/leadInfoApi/saveLeadTransaction'),
        //'http://10.100.18.167:8090/rbd/leadInfoApi/saveLeadTransaction'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          'leadInfo': leadinfo,
          'personName': personName,
          'personContact': personContact,
          'todoType': todoType,
          'todoDescription': todoDescription,
          'meetDate': meet_date,
          'executionDate': execution_date,
          'followupDate': followUp_date,
          'remarks': remarks,
          'salesPerson': salesPerson,
          'stepNo': stepNo,
          'lattitute': lat,
          'longitute': long,
          'userID': Constants.employeeId,
          'cancelReason': cancelReason,
        }
            // ),}

            ));
    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      return 'Server issues';
    }
  }

  Future serviceEnable() async {
    await Geolocator.openLocationSettings();
  }

  void getPermission() async {
    LocationPermission per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied ||
        per == LocationPermission.deniedForever) {
      print("permission denied");
      LocationPermission per1 = await Geolocator.requestPermission();
      if (await Geolocator.checkPermission() == LocationPermission.denied ||
          await Geolocator.checkPermission() ==
              LocationPermission.deniedForever) {
        print("permission denied-2");
        Navigator.of(context).pop();
      }
    } else {
      Position currentLoc = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        long = currentLoc.longitude.toString();
        lat = currentLoc.latitude.toString();
      });
    }
  }

  @override
  var long = "longitude";
  var lat = "latitude";
  void getLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      getPermission();
    } else {
      await serviceEnable();
      if (await Geolocator.isLocationServiceEnabled()) {
        getPermission();
      } else {
        Navigator.of(context).pop();
      }

      //getLocation();
    }
  }

  //String _salesPersonController = '';
  String _meetDateController = '';
  String _followupDateController = '';
  String _executionDateController = '';

  late var salesPersonJSON;
  late var salesPersonNumber;
  late var todoJSON;
  late var stepJSON;
  late var leadNoJSON;
  late var stepNumber;
  late var todoNumber;
  late var leadNoNumber;

  var icnSize = 18.0;
  var dropColor = Colors.blue;
  Widget build(BuildContext context) {
    var leadNoValidate = _leadNoValidate;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('New Lead Transacsion'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypeAheadFormField(
                      suggestionsCallback: (pattern) => leadNoList.where(
                        (item) => item.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                      ),
                      itemBuilder: (_, String item) => ListTile(
                          title: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )),
                      onSuggestionSelected: (String val) {
                        this._leadNoController.text = val;
                        leadNoControllerMiddle =
                            _leadNoController.text.split('-');
                        setState(() {
                          _personNameController.text =
                              leadNoControllerMiddle[1];
                          _personContactController.text =
                              leadNoControllerMiddle[2];
                        });
                        print(_leadNoController.text);
                      },
                      getImmediateSuggestions: true,
                      hideSuggestionsOnKeyboardHide: false,
                      hideOnEmpty: false,
                      noItemsFoundBuilder: (context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No Suggestion'),
                      ),
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                            errorText: _leadNoValidate
                                ? 'Value Can\'t Be Empty'
                                : null,
                            hintText: 'Type',
                            labelText: 'Lead No*',
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        controller: this._leadNoController,
                      ),
                    )
                  ],
                )),
            Container(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  // TextField(
                  //   controller: _personNameController,
                  //   decoration: InputDecoration(
                  //     errorText:
                  //         _personNameValidate ? 'Value Can\'t Be Empty' : null,
                  //     labelText: 'Person Name*',
                  //     labelStyle: TextStyle(
                  //         fontWeight: FontWeight.bold, color: Colors.grey),
                  //     focusedBorder: UnderlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.blue),
                  //     ),
                  //   ),
                  // )
                  Text(
                    "Customer Name: " + _personNameController.text,
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 18.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  // TextField(
                  //   controller: _personContactController,
                  //   decoration: InputDecoration(
                  //     errorText: _personContactValidate
                  //         ? 'Value Can\'t Be Empty'
                  //         : null,
                  //     labelText: 'Person Contact*',
                  //     labelStyle: TextStyle(
                  //         fontWeight: FontWeight.bold, color: Colors.grey),
                  //     focusedBorder: UnderlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.blue),
                  //     ),
                  //   ),
                  // )
                  Text(
                    "Customer Contact: " + _personContactController.text,
                    style: TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TypeAheadFormField(
                        suggestionsCallback: (pattern) => todoTypeList.where(
                          (item) => item.toLowerCase().contains(
                                pattern.toLowerCase(),
                              ),
                        ),
                        itemBuilder: (_, String item) => ListTile(
                            title: Text(
                          item,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                        onSuggestionSelected: (String val) {
                          this._todoController.text = val;
                        },
                        getImmediateSuggestions: true,
                        hideSuggestionsOnKeyboardHide: false,
                        hideOnEmpty: false,
                        noItemsFoundBuilder: (context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('No Suggestion'),
                        ),
                        textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                              hintText: 'Type',
                              labelText: 'Todo',
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          controller: this._todoController,
                        ),
                      ),
                    ])),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _todoDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Todo Description',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 20.0),
              child: TextButton(
                onPressed: () {
                  DatePicker.showTimePicker(context, showTitleActions: true,
                      //     onChanged: (date) {
                      //   print('change $date in time zone ' +
                      //       date.timeZoneOffset.inHours.toString());
                      // },
                      onConfirm: (date) {
                    print('confirm meating date $date');
                    meet_date = date.toString();
                    var meet_minute = date.minute.toInt() < 10
                        ? '0' + date.minute.toString()
                        : date.minute.toString();
                    var meet_date_day = date.day.toInt() < 10
                        ? '0' + date.day.toString()
                        : date.day.toString();
                    var meet_date_month = date.month.toInt() < 10
                        ? '0' + date.month.toString()
                        : date.month.toString();

                    setState(() {
                      _meetDateController = date.year.toString() +
                          '-' +
                          meet_date_month.toString() +
                          '-' +
                          meet_date_day.toString() +
                          ' at ' +
                          date.hour.toString() +
                          ':' +
                          meet_minute.toString();
                    });
                  }, currentTime: DateTime.now());
                },
                child: Text(
                  "Start Time* : $_meetDateController",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 20.0),
              child: TextButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      //     onChanged: (date) {
                      //   print('change $date in time zone ' +
                      //       date.timeZoneOffset.inHours.toString());
                      // },
                      onConfirm: (date) {
                    print('confirm $date');
                    execution_date = date.toString();

                    var execution_minute = date.minute.toInt() < 10
                        ? '0' + date.minute.toString()
                        : date.minute.toString();
                    var execution_date_day = date.day.toInt() < 10
                        ? '0' + date.day.toString()
                        : date.day.toString();
                    var execution_date_month = date.month.toInt() < 10
                        ? '0' + date.month.toString()
                        : date.month.toString();

                    setState(() {
                      _executionDateController = date.year.toString() +
                          '-' +
                          execution_date_month.toString() +
                          '-' +
                          execution_date_day.toString() +
                          ' at ' +
                          date.hour.toString() +
                          ':' +
                          execution_minute.toString();
                    });
                  }, currentTime: DateTime.now());
                },
                child: Text(
                  "End Time: $_executionDateController",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 20.0),
              child: TextButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      //     onChanged: (date) {
                      //   print('change $date in time zone ' +
                      //       date.timeZoneOffset.inHours.toString());
                      // },

                      onConfirm: (date) {
                    print('confirm $date');
                    followUp_date = date.toString();

                    var followup_minute = date.minute.toInt() < 10
                        ? '0' + date.minute.toString()
                        : date.minute.toString();
                    var followUp_date_day = date.day.toInt() < 10
                        ? '0' + date.day.toString()
                        : date.day.toString();
                    var followUp_date_month = date.month.toInt() < 10
                        ? '0' + date.month.toString()
                        : date.month.toString();
                    setState(() {
                      _followupDateController = date.year.toString() +
                          '-' +
                          followUp_date_month.toString() +
                          '-' +
                          followUp_date_day.toString() +
                          ' at ' +
                          date.hour.toString() +
                          ':' +
                          followup_minute.toString();
                    });
                  }, currentTime: DateTime.now());
                },
                child: Text(
                  "Followup Date: $_followupDateController",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _remarkController,
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //SizedBox(height: 15.0),
            // Container(
            //     padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            //     child: Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           TypeAheadFormField(
            //             suggestionsCallback: (pattern) => sales_person.where(
            //               (item) => item.toLowerCase().contains(
            //                     pattern.toLowerCase(),
            //                   ),
            //             ),
            //             itemBuilder: (_, String item) => ListTile(
            //                 title: Text(
            //               item,
            //               overflow: TextOverflow.ellipsis,
            //               maxLines: 2,
            //             )),
            //             onSuggestionSelected: (String val) {
            //               this._salesPersonController.text = val;
            //             },
            //             getImmediateSuggestions: true,
            //             hideSuggestionsOnKeyboardHide: false,
            //             hideOnEmpty: false,
            //             noItemsFoundBuilder: (context) => Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text('No Suggestion'),
            //             ),
            //             textFieldConfiguration: TextFieldConfiguration(
            //               decoration: InputDecoration(
            //                   hintText: 'Type',
            //                   labelText: 'Sales Person',
            //                   labelStyle: TextStyle(
            //                       color: Colors.grey,
            //                       fontWeight: FontWeight.bold)),
            //               controller: this._salesPersonController,
            //             ),
            //           ),
            //         ])),
            // // Container(
            // //     padding: EdgeInsets.only(left: 20.0, right: 20.0),
            // //     child: Column(
            // //       mainAxisAlignment: MainAxisAlignment.start,
            // //       crossAxisAlignment: CrossAxisAlignment.start,
            // //       children: [
            // //         TypeAheadFormField(
            // //           suggestionsCallback: (pattern) => stepNoList.where(
            // //             (item) => item.toLowerCase().contains(
            // //                   pattern.toLowerCase(),
            // //                 ),
            // //           ),
            // //           itemBuilder: (_, String item) => ListTile(
            // //               title: Text(
            // //             item,
            // //             overflow: TextOverflow.ellipsis,
            // //             maxLines: 2,
            // //           )),
            // //           onSuggestionSelected: (String val) {
            // //             this._stepController.text = val;
            // //           },
            // //           getImmediateSuggestions: true,
            // //           hideSuggestionsOnKeyboardHide: false,
            // //           hideOnEmpty: false,
            // //           noItemsFoundBuilder: (context) => Padding(
            // //             padding: const EdgeInsets.all(8.0),
            // //             child: Text('No Suggestion'),
            // //           ),
            // //           textFieldConfiguration: TextFieldConfiguration(
            // //             decoration: InputDecoration(
            // //                 hintText: 'Type', labelText: 'Step No'),
            // //             controller: this._stepController,
            // //           ),
            // //         )
            // //       ],
            // //     )),

            Container(
                padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Step Type",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        )),
                    Row(
                      // ignore: pre
                      //fer_const_literals_to_create_immutables
                      children: <Widget>[
                        DropdownButton<String>(
                          value: _stepController.text,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: icnSize,
                          elevation: 16,
                          style: const TextStyle(color: Colors.blue),
                          underline: Container(
                            height: 2,
                            color: dropColor,
                          ),
                          onChanged: (String? newValue_stepType) {
                            setState(() {
                              _stepController.text = newValue_stepType!;
                              _cancelReasonController.text = '';
                              //print(_stepController.text.toString());
                            });
                            // setState(() {});
                          },
                          items: stepNoList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Colors.grey,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            );
                          }).toList(),
                        ),
                        // SizedBox(
                        //   width: 10.0,
                        // ),
                      ],
                    ),
                  ],
                )),

            (_stepController.text.toString() == 'CANCEL')
                ? Container(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cancel Reason",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            )),
                        Row(
                          // ignore: pre
                          //fer_const_literals_to_create_immutables
                          children: <Widget>[
                            DropdownButton<String>(
                              value: _cancelReasonController.text,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: icnSize,
                              elevation: 16,
                              style: const TextStyle(color: Colors.blue),
                              underline: Container(
                                height: 2,
                                color: dropColor,
                              ),
                              onChanged: (String? newValue_cancelReason) {
                                setState(() {
                                  _cancelReasonController.text =
                                      newValue_cancelReason!;
                                });
                              },
                              items: cancelReasonList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                      ],
                    ))
                : Container(),
            SizedBox(height: 20.0),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (isLoad) {
                      //isLoad = true;
                      print("before validation");
                      bool isValid = formValidator();
                      if (isValid) {
                        Fluttertoast.showToast(
                            msg: "Saving..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        setState(() {
                          isLoad = false;
                        });
                        List<String> salesPersonControllerMiddle =
                            _salesPersonController.text.split(' ');
                        String _salesPersonControllerFinal =
                            salesPersonControllerMiddle[0];
                        leadNoControllerMiddle =
                            _leadNoController.text.split('-');
                        String _leadNoControllerFinal =
                            leadNoControllerMiddle[0];
                        leadinfo = _leadNoControllerFinal;
                        personName = _personNameController.text;
                        personContact = _personContactController.text;
                        todoType = _todoController.text;
                        todoDescription = _todoDescriptionController.text;
                        // have to set meet date
                        remarks = _remarkController.text;
                        salesPerson = Constants.employeeId;
                        stepNo = _stepController.text;
                        cancelReason = _cancelReasonController.text
                            .toString()
                            .split('.')[1];
                        print("after controller");
                        // newLeadTransactionModel = Todo_New_Lead_Transaction(
                        //     leadinfo,
                        //     personName,
                        //     personContact,
                        //     todoType,
                        //     todoDescription,
                        //     meetDate,
                        //     executionDate,
                        //     followupDate,
                        //     remarks,
                        //     salesPerson,
                        //     stepNo);
                        //newLeadTransactionSend.add(newLeadTransactionModel);
                        var response = await createAlbum();

                        //print(json.encode(newLeadTransactionSend));
                        if (response.toLowerCase().trim() == 'success') {
                          Navigator.of(context)
                              .pushReplacementNamed('/summery');
                        } else {
                          setState(
                            () {
                              isLoad = true;
                            },
                          );
                          print(response);
                          Fluttertoast.showToast(
                              msg: response,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
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
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100.0),
          ],
        ),
      ),
    );
  }
}

void getLeadData() {}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
