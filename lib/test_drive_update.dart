import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//import 'package:flutter/src/material/dropdown.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:login_prac/constants.dart';
import 'package:login_prac/test_drive_constants.dart';
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
//         ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
//             currentLeftIndex(), currentMiddleIndex(), currentRightIndex())
//         : DateTime(currentTime.year, currentTime.month, currentTime.day,
//             currentLeftIndex(), currentMiddleIndex(), currentRightIndex());
//   }
// }

class TestDriveUpdatePage extends StatefulWidget {
  const TestDriveUpdatePage({Key? key}) : super(key: key);

  @override
  _TestDriveUpdateState createState() => _TestDriveUpdateState();
}

class _TestDriveUpdateState extends State<TestDriveUpdatePage> {
  late final _modelNameController = TextEditingController();
  final _financeContoller = TextEditingController();
  final _testDriveStatusContoller = TextEditingController();
  bool isLoad = true;
  String testDrive_date = '';
  String _testDriveDateController = '';
  List<String> modelList = [''];
  List<String> testDriveStatusList = ['', 'PENDING', 'DONE'];
  List<String> financeList = ['', 'YES', 'NO'];

  String _modelNameControllerFinal = TestDriveConstants.tdModelName;
  String leadNo = TestDriveConstants.leadNo;
  String tdApprovalStatus = TestDriveConstants.tdApprovalStatus;
  String tdModelName = TestDriveConstants.tdModelName;
  String tdRequestedTime = TestDriveConstants.tdRequestedTime;
  String tdTime = TestDriveConstants.tdTime;
  String tdStatus = TestDriveConstants.tdStatus;
  String finance = TestDriveConstants.finance;
  String employID = '';

  @override
  void initState() {
    super.initState();
    getEmployID();
  }

  getEmployID() async {
    employID = await localGetEmployeeID();
    getLeadData();
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

    var modelListJSON = json.decode(response.body)['modelList'];

    // print(salesPersonJSON[4]['empCode'].toString() +
    //     ' ' +
    //     salesPersonJSON[4]['empName']);
    // print("leaving getData");

    int modelNumber = modelListJSON.length;
    for (var i = 0; i < modelNumber; i++) {
      String modelListMiddle = modelListJSON[i].toString();
      modelList.insert(0, modelListMiddle);
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
      if (_modelNameControllerFinal != '') {
        setState(() {
          _modelNameControllerFinal =
              '$_modelNameControllerFinal , ${_modelNameController.text}';
          _modelNameController.text = '';
        });
      } else {
        setState(() {
          _modelNameControllerFinal = _modelNameController.text;
          _modelNameController.text = '';
        });
      }
    }
  }

  Future<String> createAlbum() async {
    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse('$localURL/updateTestDriveData'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          //'new_lead_transaction': jsonEncode(<String, String>{
          'leadNo': leadNo,
          'tdModelName': tdModelName,
          'tdStatus': tdStatus,
          'tdTime': tdTime,
          'isAutoFinance': finance,
          'userID': employID
        }
            // ),}

            ));
    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      return 'Server issues';
    }
  }

  var icnSize = 18.0;
  var dropColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Test Drive Update'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Lead No: $leadNo",
                    style: const TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Customer Name: ${TestDriveConstants.customerName}",
                    style: const TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 20.0, right: 18.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  Text(
                    "Customer Contact: ${TestDriveConstants.customerNumber}",
                    style: const TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 20.0, right: 18.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  Text(
                    "Test-Drive Approval Status: $tdApprovalStatus",
                    style: const TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 20.0, right: 18.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  Text(
                    "Test-Drive Requested: ${TestDriveConstants.tdRequestedTime}",
                    style: const TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            (TestDriveConstants.tdStatus != 'DONE')
                ? Container(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Test-Drive Status*",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            DropdownButton<String>(
                              //isExpanded: true,
                              value: _testDriveStatusContoller.text,
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
                                  _testDriveStatusContoller.text =
                                      newvalueSteptype!;
                                  // _cancelReasonController.text = '';
                                  // _lostToController.text = '';
                                  //print(_stepController.text.toString());
                                });
                                // setState(() {});
                              },
                              items: testDriveStatusList
                                  .map<DropdownMenuItem<String>>(
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
                  )
                : Container(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 20.0, right: 18.0),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          "Test-Drive Status: ${TestDriveConstants.tdStatus}",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
            (TestDriveConstants.tdStatus != 'DONE')
                ? Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 10.0, right: 20.0),
                    child: TextButton(
                      onPressed: () async {
                        final TimeOfDay? tdDate = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            initialEntryMode: TimePickerEntryMode.dial);
                        if (tdDate != null) {
                          setState(() {
                            //customerDOBdate = dob;
                            _testDriveDateController =
                                '${DateTime.now().toString().split(' ')[0]} ${tdDate.toString().split('(')[1].split(')')[0]}:00';
                            print(_testDriveDateController.toString());
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
                        //   testDrive_date = date.toString();
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
                        //     _testDriveDateController =
                        //         '${date.year}-$meetDateMonth-$meetDateDay at ${date.hour}:$meetMinute';
                        //   });
                        // }, currentTime: DateTime.now());
                      },
                      child: Text(
                        "Test-Drive Time* : $_testDriveDateController",
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 20.0, right: 18.0),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          "Test-Drive Time: ${TestDriveConstants.tdTime}",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 10.0,
            ),
            (TestDriveConstants.tdStatus != 'DONE')
                ? Container(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                              items: modelList.map<DropdownMenuItem<String>>(
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
                                          _modelNameControllerFinal = '';
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
                                    left: 0.0, right: 5.0),
                                child: Text(
                                  "Model Name: $_modelNameControllerFinal",
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
                      ],
                    ))
                : Container(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 20.0, right: 18.0),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          "Test-Drive Model Name: ${TestDriveConstants.tdModelName}",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Finance*",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      DropdownButton<String>(
                        //isExpanded: true,
                        value: _financeContoller.text,
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
                            _financeContoller.text = newvalueSteptype!;
                            // _cancelReasonController.text = '';
                            // _lostToController.text = '';
                            //print(_stepController.text.toString());
                          });
                          // setState(() {});
                        },
                        items: financeList
                            .map<DropdownMenuItem<String>>((String value) {
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
            const SizedBox(height: 30.0),
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (_testDriveStatusContoller.text == 'DONE' &&
                        testDrive_date == '') {
                      Fluttertoast.showToast(
                          msg: "Input Test-Drive Time...",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      leadNo = TestDriveConstants.leadNo;
                      tdModelName = _modelNameControllerFinal;
                      tdStatus = _testDriveStatusContoller.text;
                      tdTime = testDrive_date.toString();
                      finance = _financeContoller.text;
                      print('leadNo====$leadNo');
                      print('leadNo====$tdModelName');
                      print('leadNo====$tdStatus');
                      print('leadNo====$tdTime');
                      print('leadNo====$finance');
                      print('leadNo====$employID');
                      var response = await createAlbum();

                      //print(json.encode(newLeadTransactionSend));
                      if (response.toLowerCase().trim() == 'success') {
                        Navigator.of(context).pushReplacementNamed('/summery');
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
