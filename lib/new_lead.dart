import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/itemdetails.dart';
import 'package:login_prac/todo.dart';
import 'package:login_prac/utils/sesssion_manager.dart';

import 'new_lead_json.dart';

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

class NewLead extends StatefulWidget {
  @override
  _NewLeadState createState() => _NewLeadState();
}

class _NewLeadState extends State<NewLead> {
  @override
  initState() {
    super.initState();
    getData();
    getEmployID();
  }

  getEmployID() async {
    salesManID = await localGetEmployeeID();
  }

  getData() async {
    print("inside getData");
    final response = await http.post(
        Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/getData'),
        //Uri.parse('http://10.100.18.167:8090/rbd/leadInfoApi/getData'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': Constants.employeeId,
        }));

    salesPersonJSON = json.decode(response.body)['salesPersonList'];
    leadSourceJSON = json.decode(response.body)['leadSourceList'];
    outletJSON = json.decode(response.body)['storeList'];
    professionJSON = json.decode(response.body)['professionList'];
    paymentMethodJSON = json.decode(response.body)['payModeList'];
    salesPersonNumber = salesPersonJSON.length;
    //outletNumber = outletJSON.length;
    leadSourceNumber = leadSourceJSON.length;

    //print(professionJSON.toString());

    professionNumber = professionJSON.length;
    for (var i = 0; i < professionNumber; i++) {
      String professionMiddle = professionJSON[i]['name'].toString();
      professionList.insert(0, professionMiddle);
    }

    print(professionList);
    paymentMethodNumber = paymentMethodJSON.length;
    for (var i = 0; i < paymentMethodNumber; i++) {
      String paymentMiddle = paymentMethodJSON[i]['name'].toString();
      paymentMethodList.insert(0, paymentMiddle);
    }
    print(paymentMethodList);

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
    for (var j = 0; j < leadSourceNumber; j++) {
      String leadSourceMiddle = leadSourceJSON[j]['name'] +
          ' & Code: ' +
          leadSourceJSON[j]['code'].toString();
      lead_source.insert(0, leadSourceMiddle);
      print(leadSourceMiddle);
    }
    print("Leaing Lead Loop");
  }

  //late List<String> sales_person_from_JSON;
  List<String> sales_person = [
    '',
  ];
  List<String> lead_source = [
    '',
  ];
  List<String> outlet = [
    'Uttara',
    'Dhanmondi',
    'Banani',
    'Gulshan',
    'Mirpur',
    '',
  ];
  List<Todo> detailsTable = [
    //Todo('1', 'tv', 'quantity', 'stock', 'unitPrice', 'totalPrice')
  ];

  final _leadNoController = TextEditingController();
  final _customerContactController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _projectTypeController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _remarkController = TextEditingController();
  final _salesPersonController = TextEditingController();
  final _outletController = TextEditingController();
  late final _professionController = TextEditingController();
  late final _paymentMethodController = TextEditingController();

  String leadNo = '';
  String customerContact = '';
  String customerName = '';
  String customerAddress = '';
  String customerEmail = '';
  String companyName = '';
  String website = '';
  String projectType = '';
  String projectDescription = '';
  String budget = '';
  String remark = '';
  String customerDOB = '';
  String leadDate = '';
  String salesManID = '';
  late var salesPersonJSON;
  late var leadSourceJSON;
  late var outletJSON;
  late var professionJSON;
  late var paymentMethodJSON;
  late var salesPersonNumber;
  late var outletNumber;
  late var leadSourceNumber;
  late var professionNumber;
  late var paymentMethodNumber;
  List<String> professionList = [''];
  List<String> paymentMethodList = [''];

  String _leadSourceController = '';

  bool _leadNoValidate = false;
  bool _customerContactValidate = false;
  bool _customerAddressValidate = false;
  bool _customerEmailValidate = false;
  bool _customerComapnyValidate = false;
  bool _customerNameValidate = false;
  bool _salesPersonValidate = false;
  bool _employIDValidate = false;
  bool isLoad = true;

  Future<String> createAlbum(New_lead_json new_lead_values) async {
    print('json value=' + new_lead_values.toJson().toString());
    var response = await http.post(
        Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/saveLeadInfo'),
        //Uri.parse('http://10.100.18.167:8090/rbd/leadInfoApi/saveLeadInfo'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(new_lead_values)
        //jsonEncode(
        //<String, dynamic>{'new_lead': json.encode(new_lead_values)})
        //   jsonEncode(<String, String>{
        // //'new_lead': jsonEncode(<String, String>{
        // 'leadNo': leadNo,
        // 'customerName': customerName,
        // 'customerContact': customerContact,
        // 'customerAddress': customerAddress,
        // 'customerEmail': customerEmail,
        // 'customerDOB': customerDOB,
        // 'companyName': companyName,
        // 'website': website,
        // 'projectType': projectType,
        // 'projectDescription': projectDescription,
        // 'budgetbudget': budget,
        // 'remark': remark,
        // 'leadDate': leadDate,
        // '_salesPersonController': _salesPersonController,
        // '_outletController': _outletController,
        // 'itemDetails': json.encode(detailsTable),
        // //}),})
        );

    print('Response=>${response.statusCode}');

    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      return 'Server issues';
    }
  }

  var itemsAddedNumber = 0;

  var long = "longitude";
  var lat = "latitude";
  //logInValidator(){}

  formValidator() {
    String customerContact = _customerContactController.text;
    String customerName = _customerNameController.text;
    String customerAddress = _customerAddressController.text;
    String customerEmail = _customerEmailController.text;
    String customerCompany = _companyNameController.text;
    String salesPersonn = _salesPersonController.text;

    setState(() {
      if (customerContact == null || customerContact.isEmpty) {
        _customerContactValidate = true;
      } else {
        _customerContactValidate = false;
      }
      if (salesPersonn == null || salesPersonn.isEmpty) {
        _salesPersonValidate = true;
      } else {
        _salesPersonValidate = false;
      }

      if (customerCompany == null || customerCompany.isEmpty) {
        _customerComapnyValidate = true;
      } else {
        _customerEmailValidate = false;
      }
      if (customerAddress == null || customerAddress.isEmpty) {
        _customerAddressValidate = true;
      } else {
        _customerAddressValidate = false;
      }
      if (customerName == null || customerName.isEmpty) {
        _customerNameValidate = true;
      } else {
        _customerNameValidate = false;
      }
      if (customerEmail == null || customerEmail.isEmpty) {
        _customerEmailValidate = true;
      } else {
        _customerEmailValidate = false;
      }

      if (Constants.employeeId == '' ||
          Constants.employeeId == null ||
          Constants.employeeId.isEmpty) {
        _employIDValidate = true;
      } else {
        _employIDValidate = false;
      }
    });
    if (!_customerContactValidate &&
        !_salesPersonValidate &&
        !_customerAddressValidate &&
        !_customerComapnyValidate &&
        !_customerEmailValidate &&
        !_customerNameValidate &&
        !_employIDValidate) {
      return true;
    } else {
      return false;
    }
  }

  var icnSize = 18.0;
  var dropColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('New Lead'),
      ),
      body: SingleChildScrollView(
        child: (Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Container(
            //   padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
            //   child: Column(
            //     // ignore: prefer_const_literals_to_create_immutables
            //     children: <Widget>[
            //       TextField(
            //         controller: _leadNoController,
            //         decoration: InputDecoration(
            //           errorText:
            //               _leadNoValidate ? 'Value Can\'t Be Empty' : null,
            //           labelText: 'Lead No*',
            //           labelStyle: TextStyle(
            //               fontWeight: FontWeight.bold, color: Colors.grey),
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.blue),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 15.0,
            ),
            // Container(
            //   padding: EdgeInsets.only(top: 0.0, left: 15.0, right: 20.0),
            //   child: TextButton(
            //     onPressed: () {
            //       DatePicker.showDatePicker(context, showTitleActions: true,
            //           //     onChanged: (date) {
            //           //   print('change $date in time zone ' +
            //           //       date.timeZoneOffset.inHours.toString());
            //           // },
            //           onConfirm: (date) {
            //         print('confirm $date');
            //         leadDate = date.toString();

            //         var lead_date_day = date.day.toInt() < 10
            //             ? '0' + date.day.toString()
            //             : date.day.toString();
            //         var lead_date_month = date.month.toInt() < 10
            //             ? '0' + date.month.toString()
            //             : date.month.toString();

            //         setState(() {
            //           leadDate = date.year.toString() +
            //               '-' +
            //               lead_date_month.toString() +
            //               '-' +
            //               lead_date_day.toString();
            //         });
            //       }, currentTime: DateTime.now());
            //     },
            //     child: Text(
            //       "Lead Date* : $leadDate",
            //       style: TextStyle(
            //           fontSize: 17,
            //           color: Colors.grey,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // // SizedBox(
            // //   height: 10.0,
            // // ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      errorText: _customerNameValidate
                          ? 'Value Can\'t Be Empty'
                          : null,
                      labelText: 'Customer Name*',
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
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _customerContactController,
                    decoration: InputDecoration(
                      errorText: _customerContactValidate
                          ? 'Value Can\'t Be Empty'
                          : null,
                      labelText: 'Customer Contact*',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _customerEmailController,
                    decoration: InputDecoration(
                      errorText: _customerEmailValidate
                          ? 'Value Can\'t Be Empty'
                          : null,
                      labelText: 'Customer Email*',
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
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _customerAddressController,
                    decoration: InputDecoration(
                      errorText: _customerAddressValidate
                          ? 'Value Can\'t Be Empty'
                          : null,
                      labelText: 'Customer Address*',
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
                  DatePicker.showDatePicker(context, showTitleActions: true,
                      //     onChanged: (date) {
                      //   print('change $date in time zone ' +
                      //       date.timeZoneOffset.inHours.toString());
                      // },
                      onConfirm: (date) {
                    print('confirm $date');
                    customerDOB = date.toString();
                    var customerDOB_date_day = date.day.toInt() < 10
                        ? '0' + date.day.toString()
                        : date.day.toString();
                    var customerDOB_date_month = date.month.toInt() < 10
                        ? '0' + date.month.toString()
                        : date.month.toString();
                    setState(() {
                      customerDOB = date.year.toString() +
                          '-' +
                          customerDOB_date_month.toString() +
                          '-' +
                          customerDOB_date_day.toString();
                    });
                  }, currentTime: DateTime.now());
                },
                child: Text(
                  "Customer DOB: $customerDOB",
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
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _companyNameController,
                    decoration: InputDecoration(
                      errorText: _customerComapnyValidate
                          ? 'Value Can\'t Be Empty'
                          : null,
                      labelText: 'Company Name*',
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
            // Container(
            //     padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text("Profession",
            //             style: TextStyle(
            //               fontSize: 17,
            //               color: Colors.grey,
            //               fontWeight: FontWeight.bold,
            //             )),
            //         Row(
            //           // ignore: pre
            //           //fer_const_literals_to_create_immutables
            //           children: <Widget>[
            //             DropdownButton<String>(
            //               value: _professionController.text,
            //               icon: const Icon(Icons.arrow_downward),
            //               iconSize: icnSize,
            //               elevation: 16,
            //               style: const TextStyle(color: Colors.blue),
            //               underline: Container(
            //                 height: 2,
            //                 color: dropColor,
            //               ),
            //               onChanged: (String? newValue_stepType) {
            //                 setState(() {
            //                   _professionController.text = newValue_stepType!;
            //                 });
            //               },
            //               items: professionList
            //                   .map<DropdownMenuItem<String>>((String value) {
            //                 return DropdownMenuItem<String>(
            //                   value: value,
            //                   child: Text(
            //                     value,
            //                     style: TextStyle(
            //                         color: Colors.grey,
            //                         fontWeight: FontWeight.bold),
            //                   ),
            //                 );
            //               }).toList(),
            //             ),
            //             SizedBox(
            //               width: 10.0,
            //             ),
            //           ],
            //         ),
            //       ],
            //     )),

            // Container(
            //     padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text("Payment Method",
            //             style: TextStyle(
            //               fontSize: 17,
            //               color: Colors.grey,
            //               fontWeight: FontWeight.bold,
            //             )),
            //         Row(
            //           // ignore: pre
            //           //fer_const_literals_to_create_immutables
            //           children: <Widget>[
            //             DropdownButton<String>(
            //               value: _paymentMethodController.text,
            //               icon: const Icon(Icons.arrow_downward),
            //               iconSize: icnSize,
            //               elevation: 16,
            //               style: const TextStyle(color: Colors.blue),
            //               underline: Container(
            //                 height: 2,
            //                 color: dropColor,
            //               ),
            //               onChanged: (String? newValue_payment) {
            //                 setState(() {
            //                   _paymentMethodController.text = newValue_payment!;
            //                 });
            //               },
            //               items: paymentMethodList
            //                   .map<DropdownMenuItem<String>>((String value) {
            //                 return DropdownMenuItem<String>(
            //                   value: value,
            //                   child: Text(
            //                     value,
            //                     style: TextStyle(
            //                         color: Colors.grey,
            //                         fontWeight: FontWeight.bold),
            //                   ),
            //                 );
            //               }).toList(),
            //             ),
            //             SizedBox(
            //               width: 10.0,
            //             ),
            //           ],
            //         ),
            //       ],
            //     )),
            Container(
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypeAheadFormField(
                      suggestionsCallback: (pattern) => professionList.where(
                        (item) => item.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                      ),
                      itemBuilder: (_, String item) => ListTile(
                          title: Text(item,
                              overflow: TextOverflow.ellipsis, maxLines: 2)),
                      onSuggestionSelected: (String val) {
                        this._professionController.text = val;
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
                            hintText: 'Search',
                            labelText: 'Profession',
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        controller: this._professionController,
                      ),
                    )
                  ],
                )),

            Container(
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypeAheadFormField(
                      suggestionsCallback: (pattern) => paymentMethodList.where(
                        (item) => item.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                      ),
                      itemBuilder: (_, String item) => ListTile(
                          title: Text(item,
                              overflow: TextOverflow.ellipsis, maxLines: 2)),
                      onSuggestionSelected: (String val) {
                        this._paymentMethodController.text = val;
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
                            hintText: 'Search',
                            labelText: 'Payment Method',
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        controller: this._paymentMethodController,
                      ),
                    )
                  ],
                )),

            // Container(
            //   padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
            //   child: Column(
            //     // ignore: prefer_const_literals_to_create_immutables
            //     children: <Widget>[
            //       TextField(
            //         controller: _websiteController,
            //         decoration: InputDecoration(
            //           labelText: 'Website',
            //           labelStyle: TextStyle(
            //               fontWeight: FontWeight.bold, color: Colors.grey),
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.blue),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
            //   child: Column(
            //     // ignore: prefer_const_literals_to_create_immutables
            //     children: <Widget>[
            //       TextField(
            //         controller: _projectTypeController,
            //         decoration: InputDecoration(
            //           labelText: 'Project Type',
            //           labelStyle: TextStyle(
            //               fontWeight: FontWeight.bold, color: Colors.grey),
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.blue),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
            //   child: Column(
            //     // ignore: prefer_const_literals_to_create_immutables
            //     children: <Widget>[
            //       TextField(
            //         controller: _projectDescriptionController,
            //         decoration: InputDecoration(
            //           labelText: 'Project Description',
            //           labelStyle: TextStyle(
            //               fontWeight: FontWeight.bold, color: Colors.grey),
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.blue),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
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
            // Container(
            //   padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
            //   child: Column(
            //     // ignore: prefer_const_literals_to_create_immutables
            //     children: <Widget>[
            //       TextField(
            //         controller: _budgetController,
            //         decoration: InputDecoration(
            //           labelText: 'Budget',
            //           labelStyle: TextStyle(
            //               fontWeight: FontWeight.bold, color: Colors.grey),
            //           focusedBorder: UnderlineInputBorder(
            //             borderSide: BorderSide(color: Colors.blue),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            SizedBox(height: 15.0),

            Container(
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TypeAheadFormField(
                      suggestionsCallback: (pattern) => lead_source.where(
                        (item) => item.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                      ),
                      itemBuilder: (_, String item) => ListTile(
                          title: Text(item,
                              overflow: TextOverflow.ellipsis, maxLines: 2)),
                      onSuggestionSelected: (String val) {
                        this._leadNoController.text = val;
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
                            labelText: 'Lead Source',
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        controller: this._leadNoController,
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 15.0,
            ),

            Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //   Text("Sales Person",
                    //       style: TextStyle(
                    //         fontSize: 17,
                    //         color: Colors.grey,
                    //         fontWeight: FontWeight.bold,
                    //       )),
                    //   Row(
                    //     // ignore: pre
                    //     //fer_const_literals_to_create_immutables
                    //     children: <Widget>[
                    //       DropdownButton<String>(
                    //         value: _salesPersonController,
                    //         icon: const Icon(Icons.arrow_downward),
                    //         iconSize: icnSize,
                    //         elevation: 16,
                    //         style: const TextStyle(color: Colors.blue),
                    //         underline: Container(
                    //           height: 2,
                    //           color: dropColor,
                    //         ),
                    //         onChanged: (String? newValue_sales) {
                    //           setState(() {
                    //             _salesPersonController = newValue_sales!;
                    //             // List<String> salesPersonControllerMiddle =
                    //             //     _salesPersonController.split(' ');
                    //             // _salesPersonController =
                    //             //     salesPersonControllerMiddle[0];
                    //           });
                    //         },
                    //         items: sales_person
                    //             .map<DropdownMenuItem<String>>((String value) {
                    //           return DropdownMenuItem<String>(
                    //             value: value,
                    //             child: Text(value),
                    //           );
                    //         }).toList(),
                    //       ),
                    //       SizedBox(
                    //         width: 10.0,
                    //       ),
                    //     ],
                    //   ),
                    TypeAheadFormField(
                      suggestionsCallback: (pattern) => sales_person.where(
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
                        this._salesPersonController.text = val;
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
                            errorText: _customerComapnyValidate
                                ? 'Value Can\'t Be Empty'
                                : null,
                            hintText: 'Type',
                            labelText: 'Sales Person',
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        controller: this._salesPersonController,
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 15.0,
            ),

            // Container(
            //     padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         // Text("Outlet/Retail",
            //         //     style: TextStyle(
            //         //       fontSize: 17,
            //         //       color: Colors.grey,
            //         //       fontWeight: FontWeight.bold,
            //         //     )),
            //         // Row(
            //         //   // ignore: pre
            //         //   //fer_const_literals_to_create_immutables
            //         //   children: <Widget>[
            //         //     DropdownButton<String>(
            //         //       value: _outletController,
            //         //       icon: const Icon(Icons.arrow_downward),
            //         //       iconSize: icnSize,
            //         //       elevation: 16,
            //         //       style: const TextStyle(color: Colors.blue),
            //         //       underline: Container(
            //         //         height: 2,
            //         //         color: dropColor,
            //         //       ),
            //         //       onChanged: (String? newValue_outlet) {
            //         //         setState(() {
            //         //           _outletController = newValue_outlet!;
            //         //         });
            //         //       },
            //         //       items: outlet
            //         //           .map<DropdownMenuItem<String>>((String value) {
            //         //         return DropdownMenuItem<String>(
            //         //           value: value,
            //         //           child: Text(value),
            //         //         );
            //         //       }).toList(),
            //         //     ),
            //         //     SizedBox(
            //         //       width: 10.0,
            //         //     ),
            //         //   ],
            //         // ),
            //         TypeAheadFormField(
            //           suggestionsCallback: (pattern) => outlet.where(
            //             (item) => item.toLowerCase().contains(
            //                   pattern.toLowerCase(),
            //                 ),
            //           ),
            //           itemBuilder: (_, String item) =>
            //               ListTile(title: Text(item)),
            //           onSuggestionSelected: (String val) {
            //             this._outletController.text = val;
            //           },
            //           getImmediateSuggestions: true,
            //           hideSuggestionsOnKeyboardHide: false,
            //           hideOnEmpty: false,
            //           noItemsFoundBuilder: (context) => Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Text('No Suggestion'),
            //           ),
            //           textFieldConfiguration: TextFieldConfiguration(
            //             decoration: InputDecoration(
            //                 hintText: 'Type', labelText: 'Outlet/Retail'),
            //           ),
            //         )
            //       ],
            //     )),
            SizedBox(height: 20.0),
            // add item details
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  var response = await Navigator.pushNamed(
                      context, '/itemdetails',
                      arguments: detailsTable);

                  setState(() {
                    // itemsAddedNumber = response as int;
                    // print(itemsAddedNumber);
                    detailsTable = response as List<Todo>;
                  });
                },
                child: Container(
                  height: 40.0,
                  width: 90.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.lightBlueAccent,
                    color: Colors.blue[800],
                    elevation: 7.0,
                    child: Center(
                      child: Text(
                        "Add Item Details",
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Container(
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: Text('Items added: ${detailsTable.length}')),
            SizedBox(height: 15.0),
            // save
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (detailsTable.length == 0) {
                      Fluttertoast.showToast(
                          msg: "Product Missing!!\nADD ITEM DETAILS",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      if (isLoad) {
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
                          // leadNo = _leadNoController.text;
                          // customerContact = _customerContactController.text;
                          // customerName = _customerNameController.text;
                          // customerAddress = _customerAddressController.text;
                          // customerEmail = _customerEmailController.text;
                          // companyName = _companyNameController.text;
                          // website = _websiteController.text;
                          // projectType = _projectTypeController.text;
                          // projectDescription = _projectDescriptionController.text;
                          // budget = _budgetController.text;
                          // remark = _remarkController.text;
                          List<String> salesPersonControllerMiddle =
                              _salesPersonController.text.split(' ');
                          String _salesPersonControllerFinal =
                              salesPersonControllerMiddle[0];
                          List<String> leadSourceControllerMiddle =
                              _leadNoController.text.split('& Code:');
                          String _leadSourceControllerFinal =
                              leadSourceControllerMiddle[0];
                          var new_lead_values = New_lead_json(
                              profession: _professionController.text,
                              customerName: _customerNameController.text,
                              customerContact: _customerContactController.text,
                              customerAddress: _customerAddressController.text,
                              customerEmail: _customerEmailController.text,
                              customerDOB: customerDOB.toString(),
                              companyName: _companyNameController.text,
                              longitude: long,
                              lattitude: lat,
                              userID: salesManID,
                              leadSource: _leadSourceControllerFinal,
                              remark: _remarkController.text,
                              leadDate: 'leadDate',
                              salesPerson: _salesPersonControllerFinal,
                              paymentMethod: _paymentMethodController.text,
                              itemDetails: detailsTable);
                          var response = await createAlbum(new_lead_values);

                          if (response.toLowerCase().trim() == 'success') {
                            Navigator.of(context)
                                .pushReplacementNamed('/summery');
                          } else {
                            setState(
                              () {
                                isLoad = true;
                              },
                            );
                            Fluttertoast.showToast(
                                msg: response,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }

                          print('MyResponse=>$response');
                        }

                        // var map = json.decode(res);
                        // if (map["result"].toLowerCase().trim() == 'success') {
                        //   Navigator.of(context).pushNamed('/summery');
                        //}
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
            SizedBox(height: 15.0),
          ],
        )),
      ),
    );
  }
}
