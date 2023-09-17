import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/material/dropdown.dart';
////import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/todo_new_lead_transaction.dart';
import 'package:login_prac/utils/sesssion_manager.dart';

// class CustomPicker extends CommonPickerModel {
//   String digits(int value, int length) {
//     return '$value'.padLeft(length, "0");
//   }

//   CustomPicker({DateTime? currentTime, LocaleType? locale})
//       : super(locale: locale) {
//     this.currentTime = currentTime ?? DateTime.now();
//     setLeftIndex(this.currentTime.hour);
//     setMiddleIndex(this.currentTime.minute);
//     setRightIndex(this.currentTime.second);
//   }

//   @override
//   String? leftStringAtIndex(int index) {
//     if (index >= 0 && index < 24) {
//       return digits(index, 2);
//     } else {
//       return null;
//     }
//   }

//   @override
//   String? middleStringAtIndex(int index) {
//     if (index >= 0 && index < 60) {
//       return digits(index, 2);
//     } else {
//       return null;
//     }
//   }

//   @override
//   String? rightStringAtIndex(int index) {
//     if (index >= 0 && index < 60) {
//       return digits(index, 2);
//     } else {
//       return null;
//     }
//   }

//   @override
//   String leftDivider() {
//     return "|";
//   }

//   @override
//   String rightDivider() {
//     return "|";
//   }

//   @override
//   List<int> layoutProportions() {
//     return [1, 2, 1];
//   }

//   @override
//   DateTime finalTime() {
//     return currentTime.isUtc
//         ? DateTime.utc(
//             currentTime.year,
//             currentTime.month,
//             currentTime.day,
//             currentLeftIndex(),
//             currentMiddleIndex(),
//             currentRightIndex())
//         : DateTime(
//             currentTime.year,
//             currentTime.month,
//             currentTime.day,
//             currentLeftIndex(),
//             currentMiddleIndex(),
//             currentRightIndex());
//   }
// }

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
  final _lostToController = TextEditingController();
  // final _meetDateController = TextEditingController();
  // final _executionDateController = TextEditingController();
  // final _followupDateController = TextEditingController();
  final _remarkController = TextEditingController();
  // final _salesPersonController = TextEditingController();
  //final _stepNoControler = TextEditingController();

  late final _leadProspectController = TextEditingController();
  final _todoController = TextEditingController();
  late final _stepController = TextEditingController();
  late final _cancelReasonController = TextEditingController();
  late final _modelNameController = TextEditingController();

  late final _financeContoller = TextEditingController();
  late final _modelNameControllerFinal = TextEditingController();

  bool _leadNoValidate = false;
  // bool _meetDateVaidate = false;
  bool _employIDValidate = false;
  // bool _salesPersonValidate = false;
  // bool _personNameValidate = false;
  // bool _personContactValidate = false;
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
  String finance = '';
  String tdApprovalStatus = '';
  String tdStatus = '';
  String lostTo = '';
  String stepNo = '';
  String employID = '';
  String customerDOB = '';
  String leadProspectType = '';
  String modelName = '';
  String requestedtdTime = '';
  List<String> todoTypeList = [''];
  List<String> stepNoList = [''];
  List<String> modelList = [''];
  List<String> financeList = ['', 'YES', 'NO'];
  List<String> sales_person = [''];
  List<String> leadNoList = [''];
  List<String> leadProspectTypeList = ['', 'HOT', 'WARM', 'COLD'];
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
  var requestedTD_date = '';

  List<Todo_New_Lead_Transaction> newLeadTransactionSend = [];

  late Todo_New_Lead_Transaction newLeadTransactionModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeadData();
    getLocation();
    getEmployID();

    //serviceEnable();
  }

  getEmployID() async {
    employID = await localGetEmployeeID();
  }

  getLeadData() async {
    print("inside getData");
    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/getLeadData'),
        //Uri.parse('http://10.100.18.167:8090/rbd/leadInfoApi/getLeadData'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'userID': Constants.employeeId,
        }));
    print('getLeadData  ====${json.decode(response.body)}');
    salesPersonJSON = json.decode(response.body)['salesPersonList'];
    todoJSON = json.decode(response.body)['todoList'];
    stepJSON = json.decode(response.body)['stepList'];
    leadNoJSON = json.decode(response.body)['leadList'];
    modelListJSON = json.decode(response.body)['modelList'];

    salesPersonNumber = salesPersonJSON.length;

    // print(salesPersonJSON[4]['empCode'].toString() +
    //     ' ' +
    //     salesPersonJSON[4]['empName']);
    // print("leaving getData");
    setState(() {
      for (var i = 0; i < salesPersonNumber; i++) {
        String salesPersonMiddle =
            '${salesPersonJSON[i]['empCode']} ' + salesPersonJSON[i]['empName'];
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
      modelNumber = modelListJSON.length;
      for (var i = 0; i < modelNumber; i++) {
        String modelListMiddle = modelListJSON[i].toString();
        modelList.insert(0, modelListMiddle);
      }

      leadNoNumber = leadNoJSON.length;
      for (var i = 0; i < leadNoNumber; i++) {
        String leadNoMiddle = leadNoJSON[i]['title'].toString();
        leadNoList.insert(0, leadNoMiddle);
      }
      // print(todoTypeList);
      // print(stepNoList);
      // print(leadNoList);
    });
  }

  formValidator() {
    String leadNo = _leadNoController.text;
    //String meetDate = _meetDateController.text;
    // String salesPerson = _salesPersonController.text;
    // String personNameValidation = _personNameController.text;
    // String personContactValidation = _personContactController.text;
    setState(() {
      if (leadNo.isEmpty) {
        _leadNoValidate = true;
      } else {
        _leadNoValidate = false;
      }

      if (Constants.employeeId == '' || Constants.employeeId.isEmpty) {
        _employIDValidate = true;
      } else {
        _employIDValidate = false;
      }
    });
    if (!_leadNoValidate && !_employIDValidate) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> createAlbum() async {
    String employIDD = await localGetEmployeeID();
    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/saveLeadTransaction'),
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
          'customerDOB': customerDOB,
          'remarks': remarks,
          'salesPerson': employIDD,
          'stepNo': stepNo,
          'lattitute': lat,
          'longitute': long,
          'userID': employIDD,
          'cancelReason': cancelReason,
          'lostToWhom': lostTo,
          'leadProspectType': leadProspectType,
          'tdModelName': modelName,
          'tdRequestedTime': _testDriveDateController,
          'tdApprovalStatus': tdApprovalStatus,
          'tdStatus': tdStatus,
          'isAutoFinance': finance
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

  void modelNameAddFunction() {
    if (_modelNameController.text == '') {
      Fluttertoast.showToast(
          msg: "Select a model name..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (_modelNameControllerFinal.text != '') {
        setState(() {
          _modelNameControllerFinal.text =
              '${_modelNameControllerFinal.text} , ${_modelNameController.text}';
          _modelNameController.text = '';
        });
      } else {
        setState(() {
          _modelNameControllerFinal.text = _modelNameController.text;
          _modelNameController.text = '';
        });
      }
    }
  }

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
  String _testDriveDateController = '';
  String _testDriveTime = '';
  String _testDriveDate = '';

  late var salesPersonJSON;
  late var salesPersonNumber;
  late var todoJSON;
  late var stepJSON;
  late var modelListJSON;
  late var leadNoJSON;

  int stepNumber = 0;
  late var todoNumber;
  late var leadNoNumber;
  late var modelNumber;

  var icnSize = 18.0;
  var dropColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('New Lead Transacsion'),
      ),
      body: (stepNumber > 0)
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                              _leadNoController.text = val;
                              leadNoControllerMiddle =
                                  _leadNoController.text.split('-');
                              setState(() {
                                _personNameController.text =
                                    leadNoControllerMiddle[1];
                                _personContactController.text =
                                    leadNoControllerMiddle[2];
                                customerDOB = leadNoControllerMiddle[3];
                                if (customerDOB == 'null') {
                                  customerDOB = '2022-01-01';
                                }
                                String leadCategoryControllerMiddle =
                                    leadNoControllerMiddle[4];
                                if (leadCategoryControllerMiddle == 'null') {
                                  _leadProspectController.text = '';
                                } else {
                                  _leadProspectController.text =
                                      leadCategoryControllerMiddle;
                                }
                              });
                              print(_leadNoController.text);
                            },
                            getImmediateSuggestions: true,
                            hideSuggestionsOnKeyboardHide: false,
                            hideOnEmpty: false,
                            noItemsFoundBuilder: (context) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('No Suggestion'),
                            ),
                            textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                  errorText: _leadNoValidate
                                      ? 'Value Can\'t Be Empty'
                                      : null,
                                  hintText: 'Type',
                                  labelText: 'Lead No*',
                                  labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold)),
                              controller: _leadNoController,
                            ),
                          )
                        ],
                      )),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 20.0, right: 20.0),
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
                          "Customer Name: ${_personNameController.text}",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 20.0, right: 18.0),
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
                          "Customer Contact: ${_personContactController.text}",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 13.0, right: 20.0),
                    child: TextButton(
                      onPressed: () async {
                        final DateTime? dob = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2030));
                        if (dob != null) {
                          setState(() {
                            //customerDOBdate = dob;
                            customerDOB = dob.toString().split(' ')[0];
                            print(customerDOB.toString());
                          });
                        }
                        // DatePicker.showDatePicker(context,
                        //     showTitleActions: true,
                        //     //     onChanged: (date) {
                        //     //   print('change $date in time zone ' +
                        //     //       date.timeZoneOffset.inHours.toString());
                        //     // },
                        //     onConfirm: (date) {
                        //   print('confirm $date');
                        //   customerDOB = date.toString();
                        //   var customerdobDateDay = date.day.toInt() < 10
                        //       ? '0${date.day}'
                        //       : date.day.toString();
                        //   var customerdobDateMonth = date.month.toInt() < 10
                        //       ? '0${date.month}'
                        //       : date.month.toString();
                        //   setState(() {
                        //     customerDOB = '${date.year}-$customerdobDateMonth-$customerdobDateDay';
                        //   });
                        // }, currentTime: DateTime.now());
                      },
                      child: Text(
                        "Customer DOB: $customerDOB",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20.0,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  // Container(
                  //     padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text("Enquiry Step Type*",
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
                  //               //isExpanded: true,
                  //               value: _leadProspectController.text,
                  //               icon: const Icon(Icons.arrow_downward),
                  //               iconSize: icnSize,
                  //               elevation: 15,
                  //               style: const TextStyle(color: Colors.blue),
                  //               underline: Container(
                  //                 height: 2,
                  //                 color: dropColor,
                  //               ),
                  //               onChanged: (String? newValue_prospectType) {
                  //                 setState(() {
                  //                   _leadProspectController.text =
                  //                       newValue_prospectType!;
                  //                   // _cancelReasonController.text = '';
                  //                   // _lostToController.text = '';
                  //                   //print(_stepController.text.toString());
                  //                 });
                  //                 // setState(() {});
                  //               },
                  //               items: leadProspectTypeList
                  //                   .map<DropdownMenuItem<String>>((String value) {
                  //                 return DropdownMenuItem<String>(
                  //                   value: value,
                  //                   child: Text(
                  //                     value,
                  //                     style: TextStyle(
                  //                         color: Colors.grey,
                  //                         //fontWeight: FontWeight.bold,
                  //                         fontSize: 16),
                  //                   ),
                  //                 );
                  //               }).toList(),
                  //             ),
                  //             // SizedBox(
                  //             //   width: 10.0,
                  //             // ),
                  //           ],
                  //         ),
                  //       ],
                  //     )),
                  // // Container(
                  //     padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                  //     child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           TypeAheadFormField(
                  //             suggestionsCallback: (pattern) => todoTypeList.where(
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
                  //               this._todoController.text = val;
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
                  //                   labelText: 'Mode Of Follow Up*',
                  //                   labelStyle: TextStyle(
                  //                       color: Colors.grey,
                  //                       fontWeight: FontWeight.bold)),
                  //               controller: this._todoController,
                  //             ),
                  //           ),
                  //         ])),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Mode of Follow Up*",
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
                              //isExpanded: true,
                              value: _todoController.text,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: icnSize,
                              elevation: 16,
                              style: const TextStyle(color: Colors.blue),
                              underline: Container(
                                height: 2,
                                color: dropColor,
                              ),
                              onChanged: (String? newvalueSteptype) {
                                setState(() {
                                  _todoController.text = newvalueSteptype!;
                                  // _cancelReasonController.text = '';
                                  // _lostToController.text = '';
                                  //print(_stepController.text.toString());
                                });
                                // setState(() {});
                              },
                              items: todoTypeList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
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
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 20.0, right: 20.0),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        TextField(
                          controller: _todoDescriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Todo Description',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 15.0, right: 20.0),
                    child: TextButton(
                      onPressed: () async {
                        final TimeOfDay? start = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.dial);
                        if (start != null) {
                          setState(() {
                            //customerDOBdate = dob;

                            _meetDateController =
                                '${DateTime.now().toString().split(' ')[0]} ${start.toString().split('(')[1].split(')')[0]}:00';
                            print(_meetDateController.toString());
                            meet_date = _meetDateController.toString();
                          });
                        }
                        // DatePicker.showTimePicker(context,
                        //     showTitleActions: true,
                        //     //     onChanged: (date) {
                        //     //   print('change $date in time zone ' +
                        //     //       date.timeZoneOffset.inHours.toString());
                        //     // },
                        //     onConfirm: (date) {
                        //   print('confirm meating date $date');
                        //   meet_date = date.toString();
                        //   var meetMinute = date.minute.toInt() < 10
                        //       ? '0${date.minute}'
                        //       : date.minute.toString();
                        //   var meetDateDay = date.day.toInt() < 10
                        //       ? '0${date.day}'
                        //       : date.day.toString();
                        //   var meetDateMonth = date.month.toInt() < 10
                        //       ? '0${date.month}'
                        //       : date.month.toString();
                        //   setState(() {
                        //     _meetDateController = '${date.year}-$meetDateMonth-$meetDateDay at ${date.hour}:$meetMinute';
                        //   });
                        // }, currentTime: DateTime.now());
                      },
                      child: Text(
                        "Start Time* : $_meetDateController",
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 15.0, right: 20.0),
                    child: TextButton(
                      onPressed: () async {
                        final TimeOfDay? end = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.dial);
                        if (end != null) {
                          setState(() {
                            _executionDateController =
                                '${DateTime.now().toString().split(' ')[0]} ${end.toString().split('(')[1].split(')')[0]}:00';
                            print(_executionDateController.toString());
                            execution_date =
                                _executionDateController.toString();
                          });
                        }
                        // DatePicker.showDateTimePicker(context,
                        //     showTitleActions: true,
                        //     //     onChanged: (date) {
                        //     //   print('change $date in time zone ' +
                        //     //       date.timeZoneOffset.inHours.toString());
                        //     // },
                        //     onConfirm: (date) {
                        //   print('confirm $date');
                        //   execution_date = date.toString();
                        //   var executionMinute = date.minute.toInt() < 10
                        //       ? '0${date.minute}'
                        //       : date.minute.toString();
                        //   var executionDateDay = date.day.toInt() < 10
                        //       ? '0${date.day}'
                        //       : date.day.toString();
                        //   var executionDateMonth = date.month.toInt() < 10
                        //       ? '0${date.month}'
                        //       : date.month.toString();
                        //   setState(() {
                        //     _executionDateController = '${date.year}-$executionDateMonth-$executionDateDay at ${date.hour}:$executionMinute';
                        //   });
                        // }, currentTime: DateTime.now());
                      },
                      child: Text(
                        "End Time: $_executionDateController",
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 15.0, right: 20.0),
                    child: TextButton(
                      onPressed: () async {
                        final DateTime? follow = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2030));
                        if (follow != null) {
                          setState(() {
                            //customerDOBdate = dob;
                            followUp_date = follow.toString();
                            _followupDateController =
                                follow.toString().split(' ')[0];
                            print(_followupDateController.toString());
                          });
                        }
                        // DatePicker.showDateTimePicker(context,
                        //     showTitleActions: true,
                        //     //     onChanged: (date) {
                        //     //   print('change $date in time zone ' +
                        //     //       date.timeZoneOffset.inHours.toString());
                        //     // },
                        //     onConfirm: (date) {
                        //   print('confirm $date');
                        //   followUp_date = date.toString();
                        //   var followupMinute = date.minute.toInt() < 10
                        //       ? '0${date.minute}'
                        //       : date.minute.toString();
                        //   var followupDateDay = date.day.toInt() < 10
                        //       ? '0${date.day}'
                        //       : date.day.toString();
                        //   var followupDateMonth = date.month.toInt() < 10
                        //       ? '0${date.month}'
                        //       : date.month.toString();
                        //   setState(() {
                        //     _followupDateController = '${date.year}-$followupDateMonth-$followupDateDay at ${date.hour}:$followupMinute';
                        //   });
                        // }, currentTime: DateTime.now());
                      },
                      child: Text(
                        "Follow-Up Date*: $_followupDateController",
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 20.0, right: 20.0),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        TextField(
                          controller: _remarkController,
                          decoration: const InputDecoration(
                            labelText: 'Remarks',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
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
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Enquiry Step Type*",
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
                                //isExpanded: true,
                                value: _stepController.text,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: icnSize,
                                elevation: 16,
                                style: const TextStyle(color: Colors.blue),
                                underline: Container(
                                  height: 2,
                                  color: dropColor,
                                ),
                                onChanged: (String? newvalueSteptype) {
                                  setState(() {
                                    _stepController.text = newvalueSteptype!;
                                    _cancelReasonController.text = '';
                                    _lostToController.text = '';
                                    //print(_stepController.text.toString());
                                  });
                                  // setState(() {});
                                },
                                items: stepNoList.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
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
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 20.0, right: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Cancel Reason",
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
                                    //isExpanded: true,
                                    value: _cancelReasonController.text,
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: icnSize,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.blue),
                                    underline: Container(
                                      height: 2,
                                      color: dropColor,
                                    ),
                                    onChanged: (String? newvalueCancelreason) {
                                      setState(() {
                                        _cancelReasonController.text =
                                            newvalueCancelreason!;
                                      });
                                    },
                                    items: cancelReasonList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 17.0),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              ),
                            ],
                          ))
                      : Container(),
                  (_cancelReasonController.text.toString() ==
                          'Lost to Competitor')
                      ? Container(
                          padding: const EdgeInsets.only(
                              top: 0.0, left: 20.0, right: 20.0),
                          child: Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: <Widget>[
                              TextField(
                                controller: _lostToController,
                                decoration: const InputDecoration(
                                  labelText: 'Lost To Whom',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  (_stepController.text.toString() == 'TEST-DRIVE')
                      ? Container(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 20.0, right: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Which Model : ",
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
                                    //isExpanded: true,
                                    value: _modelNameController.text,
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: icnSize,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.blue),
                                    underline: Container(
                                      height: 2,
                                      color: dropColor,
                                    ),
                                    onChanged: (String? newvalueModelname) {
                                      setState(() {
                                        _modelNameController.text =
                                            newvalueModelname!;

                                        print(_modelNameController.text.length);
                                      });
                                    },
                                    items: modelList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 17.0),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  // SizedBox(
                                  //   height: 25.0,
                                  // ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () async {
                                              modelNameAddFunction();
                                            },
                                            child: SizedBox(
                                              height: 40.0,
                                              width: 60.0,
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                //shadowColor: Colors.lightBlueAccent,
                                                color: Colors.blue[800],
                                                elevation: 7.0,
                                                child: const Center(
                                                  child: Text(
                                                    "Add Model",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 50.0,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                _modelNameControllerFinal.text =
                                                    '';
                                                _modelNameController.text = '';
                                              });
                                            },
                                            child: SizedBox(
                                              height: 40.0,
                                              width: 60.0,
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                //shadowColor: Colors.lightBlueAccent,
                                                color: Colors.blue[800],
                                                elevation: 7.0,
                                                child: const Center(
                                                  child: Text(
                                                    "Cancel All\nModel",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Row(
                                // ignore: pre
                                //fer_const_literals_to_create_immutables
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 7.0, right: 5.0),
                                      child: Text(
                                        "Model Name: ${_modelNameControllerFinal.text}",
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 0.0,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 00.0, right: 20.0),
                                    child: TextButton(
                                      onPressed: () async {
                                        final DateTime? reqD =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2030));
                                        if (reqD != null) {
                                          setState(() {
                                            //customerDOBdate = dob;
                                            requestedTD_date = reqD.toString();
                                            _testDriveDate =
                                                reqD.toString().split(' ')[0];
                                            print(_testDriveDate.toString());
                                          });
                                        }
                                        // DatePicker.showDateTimePicker(context,
                                        //     showTitleActions: true,
                                        //     //     onChanged: (date) {
                                        //     //   print('change $date in time zone ' +
                                        //     //       date.timeZoneOffset.inHours.toString());
                                        //     // },
                                        //     onConfirm: (date) {
                                        //   print('confirm $date');
                                        //   requestedTD_date = date.toString();
                                        //   var requestedtdDateMinute =
                                        //       date.minute.toInt() < 10
                                        //           ? '0${date.minute}'
                                        //           : date.minute.toString();
                                        //   var requestedtdDateDay =
                                        //       date.day.toInt() < 10
                                        //           ? '0${date.day}'
                                        //           : date.day.toString();
                                        //   var requestedtdDateMonth =
                                        //       date.month.toInt() < 10
                                        //           ? '0${date.month}'
                                        //           : date.month.toString();
                                        //   setState(() {
                                        //     _testDriveDateController =
                                        //         '${date.year}-$requestedtdDateMonth-$requestedtdDateDay at ${date.hour}:$requestedtdDateMinute';
                                        //   });
                                        // }, currentTime: DateTime.now());
                                      },
                                      child: Text(
                                        "Requested Test-Drive Date*:\n$_testDriveDate",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 00.0, right: 20.0),
                                    child: TextButton(
                                      onPressed: () async {
                                        final TimeOfDay? reqT =
                                            await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                                initialEntryMode:
                                                    TimePickerEntryMode.dial);
                                        if (reqT != null) {
                                          setState(() {
                                            //customerDOBdate = dob;
                                            _testDriveTime =
                                                '${reqT.toString().split('(')[1].split(')')[0]}:00';
                                            _testDriveDateController =
                                                '$_testDriveDate $_testDriveTime';
                                            print(_testDriveTime.toString());
                                          });
                                        }
                                        // DatePicker.showDateTimePicker(context,
                                        //     showTitleActions: true,
                                        //     //     onChanged: (date) {
                                        //     //   print('change $date in time zone ' +
                                        //     //       date.timeZoneOffset.inHours.toString());
                                        //     // },
                                        //     onConfirm: (date) {
                                        //   print('confirm $date');
                                        //   requestedTD_date = date.toString();
                                        //   var requestedtdDateMinute =
                                        //       date.minute.toInt() < 10
                                        //           ? '0${date.minute}'
                                        //           : date.minute.toString();
                                        //   var requestedtdDateDay =
                                        //       date.day.toInt() < 10
                                        //           ? '0${date.day}'
                                        //           : date.day.toString();
                                        //   var requestedtdDateMonth =
                                        //       date.month.toInt() < 10
                                        //           ? '0${date.month}'
                                        //           : date.month.toString();
                                        //   setState(() {
                                        //     _testDriveDateController =
                                        //         '${date.year}-$requestedtdDateMonth-$requestedtdDateDay at ${date.hour}:$requestedtdDateMinute';
                                        //   });
                                        // }, currentTime: DateTime.now());
                                      },
                                      child: Text(
                                        "Requested Test-Drive Time*:\n$_testDriveTime",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 20.0),
                                child: const Text("Finance : ",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Row(
                                // ignore: pre
                                //fer_const_literals_to_create_immutables
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 20.0),
                                    child: DropdownButton<String>(
                                      //isExpanded: true,
                                      value: _financeContoller.text,
                                      icon: const Icon(Icons.arrow_downward),
                                      iconSize: icnSize,
                                      elevation: 16,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      underline: Container(
                                        height: 2,
                                        color: dropColor,
                                      ),
                                      onChanged: (String? newvalueModelname) {
                                        setState(() {
                                          _financeContoller.text =
                                              newvalueModelname!;

                                          print(_financeContoller.text.length);
                                        });
                                      },
                                      items: financeList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                //fontWeight: FontWeight.bold,
                                                fontSize: 17.0),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 25.0,
                                  // ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ))
                      : Container(),
                  const SizedBox(height: 30.0),
                  Container(
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          final DateTime dateTimeNow = DateTime.now();
                          print('asdadbbfinrwunv$meet_date');
                          final dateTimeCreatedAt =
                              DateTime.parse(_followupDateController);
                          final differenceInDays =
                              dateTimeCreatedAt.difference(dateTimeNow).inDays;
                          print(differenceInDays);
                          if (_stepController.text.toString() != 'TEST-DRIVE') {
                            _modelNameControllerFinal.text = '';
                            _testDriveDateController = '';
                          } else if (_stepController.text.toString() ==
                                  'TEST-DRIVE' &&
                              _modelNameControllerFinal.text == '') {
                            modelNameAddFunction();
                          }
                          if (_stepController.text.toString() == 'TEST-DRIVE' &&
                              _financeContoller.text == '') {
                            Fluttertoast.showToast(
                                msg: "Please Add a Finance Option!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            if (_stepController.text.toString() ==
                                    'TEST-DRIVE' &&
                                _modelNameControllerFinal.text == '') {
                              Fluttertoast.showToast(
                                  msg: "Please Add a Model First!!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              if (_stepController.text.toString() ==
                                      'TEST-DRIVE' &&
                                  _testDriveDateController == '') {
                                Fluttertoast.showToast(
                                    msg: "Please Add a Test Date First!!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                {
                                  if (differenceInDays < 0) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Previous Date Can't Be\nNext Follow-Up Date",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else if (differenceInDays > 30) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Next Follow-Up Date Can't\nBe More Than One Month",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else {
                                    if (_todoController.toString() == '') {
                                      Fluttertoast.showToast(
                                          msg: "Mode of FollowUp missing..",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      if (_stepController.text == '') {
                                        Fluttertoast.showToast(
                                            msg: "Enquiry Step Type Missing..",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        if (_followupDateController == '' &&
                                            _stepController.text !=
                                                'INVOICED' &&
                                            _stepController.text != 'BOOKED' &&
                                            _stepController.text != 'LOST') {
                                          Fluttertoast.showToast(
                                              msg: "Follow-Up Date Missing..",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          if (isLoad) {
                                            //isLoad = true;
                                            print("before validation");
                                            bool isValid = formValidator();
                                            print(isValid);
                                            if (isValid) {
                                              Fluttertoast.showToast(
                                                  msg: "Saving..",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);

                                              setState(() {
                                                isLoad = false;
                                              });
                                              if (_stepController.text == '') {}
                                              switch (_stepController.text) {
                                                case 'ENQUIRY':
                                                  _leadProspectController.text =
                                                      'IN-PROGRESS';
                                                  break;
                                                case 'FOLLOW-UP ( SHOWROOM VISIT )':
                                                  _leadProspectController.text =
                                                      'LEAD';
                                                  break;
                                                case 'FOLLOW-UP ( PHYSICAL MEETING )':
                                                  _leadProspectController.text =
                                                      'LEAD';
                                                  break;
                                                case 'CANCEL':
                                                  _leadProspectController.text =
                                                      'LEAD';
                                                  break;
                                                case 'DEMONSTRATION':
                                                  _leadProspectController.text =
                                                      'WARM';
                                                  break;
                                                case 'TEST-DRIVE':
                                                  _leadProspectController.text =
                                                      'HOT-LEAD';
                                                  break;
                                                case 'NEGOTITAION':
                                                  _leadProspectController.text =
                                                      'HOT-LEAD';
                                                  break;
                                                case 'NO-ANSWER':
                                                  _leadProspectController.text =
                                                      '';
                                                  break;
                                              }
                                              if (_stepController.text ==
                                                  'TEST-DRIVE') {
                                                tdApprovalStatus = 'OPEN';
                                                tdStatus = 'PENDING';
                                                modelName =
                                                    _modelNameControllerFinal
                                                        .text;
                                                finance =
                                                    _financeContoller.text;
                                                requestedtdTime =
                                                    _testDriveDateController;
                                              } else {
                                                tdApprovalStatus = '';
                                                tdStatus = '';
                                                modelName = '';
                                                finance = '';
                                                requestedtdTime = '';
                                              }
                                              leadNoControllerMiddle =
                                                  _leadNoController.text
                                                      .split('-');
                                              String leadNoControllerFinal =
                                                  leadNoControllerMiddle[0];
                                              leadinfo = leadNoControllerFinal;
                                              personName =
                                                  _personNameController.text;
                                              personContact =
                                                  _personContactController.text;
                                              todoType = _todoController.text;
                                              leadProspectType =
                                                  _leadProspectController.text;
                                              todoDescription =
                                                  _todoDescriptionController
                                                      .text;
                                              // have to set meet date
                                              remarks = _remarkController.text;
                                              salesPerson = employID;
                                              stepNo = _stepController.text;
                                              modelName =
                                                  _modelNameControllerFinal
                                                      .text;
                                              cancelReason =
                                                  _cancelReasonController.text
                                                      .toString();

                                              print("after controller");
                                              lostTo = _lostToController.text;
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
                                              var response =
                                                  await createAlbum();

                                              //print(json.encode(newLeadTransactionSend));
                                              if (response
                                                      .toLowerCase()
                                                      .trim() ==
                                                  'success') {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        '/summery');
                                              } else {
                                                setState(
                                                  () {
                                                    isLoad = true;
                                                  },
                                                );
                                                print(response);
                                                Fluttertoast.showToast(
                                                    msg: response,
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        },
                        child: SizedBox(
                          height: 40.0,
                          width: 150.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.lightBlueAccent,
                            color: Colors.blue[800],
                            elevation: 7.0,
                            child: const Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100.0),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
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
