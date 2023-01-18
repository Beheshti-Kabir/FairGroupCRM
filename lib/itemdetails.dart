import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:login_prac/constants.dart';

import 'package:login_prac/todo.dart';

import 'new_lead_json.dart';

List<String> productNameList = [];
List<String> productSKUList = [];
List<String> productModelList = [];
List<String> productPriceList = [];
final _productNameSearchController = TextEditingController();
final _quantityController = TextEditingController();
late var productListJSON;
late var productListNumber;
bool productLoaded = false;

String productName = '';
String unitPrice = '';
String productRemarks = '';
String SKU = '';

final _productNameController = TextEditingController();
final _stockController = TextEditingController();
final _productNameController2 = TextEditingController();
final _unitPriceController = TextEditingController();
final _productModelController = TextEditingController();
final _remarksController = TextEditingController();

class ItemDetails extends StatefulWidget {
  const ItemDetails({Key? key}) : super(key: key);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  callBack() {
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    //getProduct();
  }

  final _totalPriceController = TextEditingController();
  final _prospectController = TextEditingController();
  final _productListController = '';
  var count = 0;

  String productModel = '';
  String quantity = '';
  String stock = '';
  String totalPrice = '';
  String prospectType = '';
  List<Todo> detailsTable = [];
  var icnSize = 18.0;
  var dropColor = Colors.blue;

  List<String> prospectTypeList = ['', 'HOT', 'WARM', 'COLD'];

  late Todo detailsModel;

  bool _quantityValidate = false;
  bool _productNameValidate = false;

  void clearController() {
    _productNameController.clear();
    _productModelController.clear();
    _quantityController.clear();
    _stockController.clear();
    _unitPriceController.clear();
    _totalPriceController.clear();
    _prospectController.clear();
  }

  addProduct() {
    bool isValid = formValidator();
    if (isValid) {
      count += 1;
      productRemarks = _remarksController.text;
      productName = _productNameController.text.toString();
      productModel = _productModelController.text.toString();
      quantity = _quantityController.text.toString();
      unitPrice = _unitPriceController.text.toString();
      prospectType = _prospectController.text.toString();
      //stock = _stockController.text.toString();
      //totalPrice = _totalPriceController.text.toString();
      detailsModel = Todo(
          productName: productName,
          productModel: productModel,
          quantity: quantity,
          productRemarks: productRemarks,
          unitPrice: unitPrice,
          prospectType: prospectType);
      //totalPrice: "totalPrice");
      detailsTable.add(detailsModel);
      clearController();
      setState(() {});
    }
  }

  formValidator() {
    String productNameValidation = _productNameController.text;
    String quantityValidation = _quantityController.text;
    setState(() {
      // if (productNameValidation == null || productNameValidation.isEmpty) {
      //   _productNameValidate = true;
      // } else {
      //   _productNameValidate = false;
      // }
      if (quantityValidation == null || quantityValidation.isEmpty) {
        _quantityValidate = true;
      } else {
        _quantityValidate = false;
      }
    });
    if (
        //!_productNameValidate &&
        !_quantityValidate) {
      return true;
    } else {
      return false;
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as List<Todo>;
    detailsTable = arguments;
    print('value:' + arguments.length.toString());
    setState(() {
      //count = arguments;
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Container(
            //     padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         //   Text("Product",
            //         //       style: TextStyle(
            //         //         fontSize: 17,
            //         //         color: Colors.grey,
            //         //         fontWeight: FontWeight.bold,
            //         //       )),
            //         //   Row(
            //         //     // ignore: pre
            //         //     //fer_const_literals_to_create_immutables
            //         //     children: <Widget>[
            //         //       DropdownButton<String>(
            //         //         value: _productListController,
            //         //         icon: const Icon(Icons.arrow_downward),
            //         //         iconSize: icnSize,
            //         //         elevation: 16,
            //         //         style: const TextStyle(color: Colors.blue),
            //         //         underline: Container(
            //         //           height: 2,
            //         //           color: dropColor,
            //         //         ),
            //         //         onChanged: (String? newValue_source) {
            //         //           setState(() {
            //         //             _productListController = newValue_source!;
            //         //           });
            //         //         },
            //         //         items: product_list
            //         //             .map<DropdownMenuItem<String>>((String value) {
            //         //           return DropdownMenuItem<String>(
            //         //             value: value,
            //         //             child: Text(value),
            //         //           );
            //         //         }).toList(),
            //         //       ),
            //         //       SizedBox(
            //         //         width: 10.0,
            //         //       ),
            //         //     ],
            //         //   ),
            //         // TypeAheadFormField(
            //         //   suggestionsCallback: (pattern) => product_list.where(
            //         //     (item) => item.toLowerCase().contains(
            //         //           pattern.toLowerCase(),
            //         //         ),
            //         //   ),
            //         //   itemBuilder: (_, String item) =>
            //         //       ListTile(title: Text(item)),
            //         //   onSuggestionSelected: (String val) {
            //         //     this._productNameController.text = val;
            //         //     print(_productNameController.text);
            //         //   },
            //         //   getImmediateSuggestions: true,
            //         //   hideSuggestionsOnKeyboardHide: false,
            //         //   hideOnEmpty: false,
            //         //   noItemsFoundBuilder: (context) => Padding(
            //         //     padding: const EdgeInsets.all(8.0),
            //         //     child: Text('No Suggestion'),
            //         //   ),
            //         //   textFieldConfiguration: TextFieldConfiguration(
            //         //     decoration: InputDecoration(
            //         //         hintText: 'Typing', labelText: 'Product'),
            //         //     controller: this._productNameController,
            //         //   ),
            //         // ),
            //       ],
            //     )),
            //
            Container(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
              child: Row(
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
                  Expanded(
                    child: Text(
                      "Product Name: " + _productNameController.text,
                      style: TextStyle(color: Colors.grey, fontSize: 18.0),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        _productNameSearchController.text = '';
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                              child: ShowDialog(
                            callBackFunction: callBack,
                          )),
                        );
                      });
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
              child: Row(
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
                  Expanded(
                    child: Text(
                      "Product Model: " + _productModelController.text,
                      style: TextStyle(color: Colors.grey, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            (Constants.companyCode == '2000')
                ? Container(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Row(
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
                        Expanded(
                          child: Text(
                            "Product Stock: " + _stockController.text,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            // Container(
            //     padding: EdgeInsets.only(left: 20.0, right: 20.0),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         TypeAheadFormField(
            //           suggestionsCallback: (pattern) => product_list.where(
            //             (item) => item.toLowerCase().contains(
            //                   pattern.toLowerCase(),
            //                 ),
            //           ),
            //           itemBuilder: (_, String item) => ListTile(
            //               title: Text(
            //             item,
            //             overflow: TextOverflow.ellipsis,
            //             maxLines: 2,
            //           )),
            //           onSuggestionSelected: (String val) {
            //             this._productNameSearchController.text = val;
            //             // leadNoControllerMiddle =
            //             //     _leadNoController.text.split('-');
            //             setState(() {
            //               // _personNameController.text =
            //               //     leadNoControllerMiddle[1];
            //               // _personContactController.text =
            //               //     leadNoControllerMiddle[2];
            //             });
            //             print(_productNameSearchController.text);
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
            //                 errorText: _productNameValidate
            //                     ? 'Value Can\'t Be Empty'
            //                     : null,
            //                 hintText: '',
            //                 labelText: 'Product Name',
            //                 labelStyle: TextStyle(
            //                     color: Colors.grey,
            //                     fontWeight: FontWeight.bold)),
            //             controller: this._productNameSearchController,
            //           ),
            //         )
            //       ],
            //     )),

            // SizedBox(
            //   height: 15.0,
            // ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _remarksController,
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
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      errorText:
                          _quantityValidate ? 'Value Can\'t Be Empty' : null,
                      labelText: 'Quantity*',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.number,
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
            //         controller: _stockController,
            //         decoration: InputDecoration(
            //           labelText: 'Stock',
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
                    controller: _unitPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Unit Price',
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
                padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enquiry Step Type*",
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
                          value: _prospectController.text,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: icnSize,
                          elevation: 15,
                          style: const TextStyle(color: Colors.blue),
                          underline: Container(
                            height: 2,
                            color: dropColor,
                          ),
                          onChanged: (String? newValue_prospectType) {
                            setState(() {
                              _prospectController.text = newValue_prospectType!;
                              // _cancelReasonController.text = '';
                              // _lostToController.text = '';
                              //print(_stepController.text.toString());
                            });
                            // setState(() {});
                          },
                          items: prospectTypeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Colors.grey,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 16),
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
            // Container(
            //   padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
            //   child: Column(t
            //     // ignore: prefer_const_literals_to_create_immutables
            //     children: <Widget>[
            //       TextField(
            //         controller: _totalPriceController,
            //         decoration: InputDecoration(
            //           labelText: 'Total Price',
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
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      if (_productNameController.text.toString() == null ||
                          _productNameController.text.toString().isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Product Name Missing..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        if (_prospectController.text.toString() == null ||
                            _prospectController.text.toString().isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Enquiry Stem Type Missing..",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          addProduct();
                        }
                      }
                    },
                    child: Container(
                      height: 30.0,
                      width: 100.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightBlueAccent,
                        color: Colors.blue[800],
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            "Add more items",
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      if (_productNameController.text.toString() == null ||
                          _productNameController.text.toString().isEmpty) {
                        print('count:' + count.toString());
                        Navigator.of(context).pop(detailsTable);
                      } else {
                        if (_prospectController.text.toString() == null ||
                            _prospectController.text.toString().isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Enquiry Stem Type Missing..",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          addProduct();
                        }
                        print('count:' + count.toString());
                        Navigator.of(context).pop(detailsTable);
                      }
                    },
                    child: Container(
                      height: 30.0,
                      width: 100.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightBlueAccent,
                        color: Colors.blue[800],
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            "Done",
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sl No',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      'Product Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      "Product Model",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      'Quantity',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),

                  // Expanded(
                  //   child: Text(
                  //     'Stock',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(fontWeight: FontWeight.bold),
                  //   ),
                  //   flex: 1,
                  // ),
                  Expanded(
                    child: Text(
                      'Unit Price',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      'Prospect Type',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),
                  // Expanded(
                  //   child: Text(
                  //     'Total Price',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(fontWeight: FontWeight.bold),
                  //   ),
                  //   flex: 1,
                  // )
                ],
              ),
            ),
            ListView.builder(
                itemCount: detailsTable.length,
                //scrollDirection: ScrollController:,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var model = detailsTable[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            (index + 1).toString(),
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            model.productName.toString(),
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            model.productModel.toString(),
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            model.quantity.toString(),
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                        // Expanded(
                        //   child: Text(
                        //     model.stock.toString(),
                        //     textAlign: TextAlign.center,
                        //   ),
                        //   flex: 1,
                        // ),
                        Expanded(
                          child: Text(
                            model.unitPrice.toString(),
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Text(
                            model.prospectType.toString(),
                            textAlign: TextAlign.center,
                          ),
                          flex: 1,
                        ),
                        // Expanded(
                        //   child: Text(
                        //     model.totalPrice.toString(),
                        //     textAlign: TextAlign.center,
                        //   ),
                        //   flex: 1,
                        // )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class ShowDialog extends StatefulWidget {
  final Function callBackFunction;

  const ShowDialog({Key? key, required this.callBackFunction})
      : super(key: key);

  @override
  State<ShowDialog> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _productValidator = false;

  preGetPorduct() async {
    setState(() {});
    if (_productNameSearchController.text.length > 1) {
      productLoaded = false;
      setState(() {});
      getProduct();
      productNameList = [];
      productPriceList = [];
      productModelList = [];
    }
  }

  getProduct() async {
    setState(() {
      productLoaded = false;
      productNameList = [];
      productPriceList = [];
      productModelList = [];
      productSKUList = [];
    });

    print("inside getProduct");

    String localURL = Constants.globalURL;
    var response = await http.post(Uri.parse(localURL + '/getProductList'),
        //Uri.parse('http://10.100.17.125:8090/rbd/leadInfoApi/getProductList'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'productName': _productNameSearchController.text,
        }));

    productListJSON = json.decode(response.body);

    productListNumber = productListJSON.length;
    print('getProduct value=' + productListJSON.toString());

    // // print(salesPersonJSON[4]['empCode'].toString() +
    // //     ' ' +
    // //     salesPersonJSON[4]['empName']);
    // // print("leaving getData");
    // for (int i = 0; i < productListNumber; i++) {
    //   int productLenght = productListJSON[i]['name'].length;
    //   double productLengthHalf = productLenght.toDouble() / 2;
    //   int productHalfLenght = productLengthHalf.toInt();
    //   if (productLenght > 30) {
    //     if (productLenght.isEven) {
    //       productListJSON[i]['name'] =
    //           productListJSON[i]['name'].substring(0, productHalfLenght) +
    //               productListJSON[i]['name'].substring(productHalfLenght);
    //     } else {
    //       productListJSON[i]['name'] =
    //           productListJSON[i]['name'].substring(0, productHalfLenght + 1) +
    //               productListJSON[i]['name'].substring(productHalfLenght + 1);
    //     }
    //   }
    //   String productListMiddle = productListJSON[i]['name'] +
    //       ' & Code: ' +
    //       productListJSON[i]['code'].toString();
    //   product_list.insert(0, productListMiddle);
    // }
    for (int i = 0; i < productListNumber; i++) {
      productNameList.add(productListJSON[i]['productName'].toString());
      productModelList.add(productListJSON[i]['productDescription'].toString());
      productPriceList.add(productListJSON[i]['productPrice'].toString());
      productSKUList.add(productListJSON[i]['productCode'].toString());
    }

    setState(() {
      productLoaded = true;
    });
    print("Leaing Lead Loop");
  }

  getProductStock(String code) async {
    print("inside getProductStock");

    String localURL = Constants.globalURL;
    String companyCode = Constants.companyCode;
    print('product Code ====' + companyCode.toString());
    var response = await http.post(Uri.parse(localURL + '/getProductListStock'),
        // Uri.parse(
        //     'http://10.100.17.125:8090/rbd/leadInfoApi/getProductListStock'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'productCode': code,
          'companyCode': companyCode,
        }));

    var productStockJSON = json.decode(response.body);

    print('getProduct value=' + productStockJSON.toString());

    _stockController.text = productStockJSON[0]['productStock'].toString();
    print(_stockController.text);
    widget.callBackFunction();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: 150,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            height: 50,
            child: TextField(
              controller: _productNameSearchController,
              onSubmitted: (value) {
                setState(() {});
                if (_productNameSearchController.text.length > 1) {
                  productLoaded = false;
                  setState(() {});
                  getProduct();
                  productNameList = [];
                  productPriceList = [];
                  productModelList = [];
                }
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: preGetPorduct,
                ),
                labelText: 'Search',
                labelStyle: TextStyle(
                    //         fontWeight:FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          (_productNameSearchController.text.length > 1)
              ? (productLoaded)
                  ? (productListNumber > 0)
                      ? Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: productListNumber,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (Constants.companyCode == '2000') {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Searching For Stock!!\nPlease wait for couple of seconds. ",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      SKU = productSKUList[index];
                                      _stockController.text =
                                          getProductStock(SKU).toString();
                                      _productNameController.text =
                                          productNameList[index];
                                      _unitPriceController.text =
                                          productPriceList[index];
                                      _productModelController.text =
                                          productModelList[index];
                                      _quantityController.text = '1';
                                    } else {
                                      _productNameController.text =
                                          productNameList[index];
                                      _unitPriceController.text =
                                          productPriceList[index];
                                      _productModelController.text =
                                          productModelList[index];
                                      _quantityController.text = '1';
                                      widget.callBackFunction();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.0,
                                          )),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Product Name : ' +
                                                      productNameList[index],
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Product productModel : ' +
                                                      productModelList[index],
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Product Price : ' +
                                                      productPriceList[index],
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Center(
                          child: Column(
                          children: [
                            Text(
                              'No Product Found!! \n\n\nPlease Search With A Different Product Name',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            // TextField(
                            //   controller: _productNameController2,
                            //   decoration: InputDecoration(
                            //     errorText: _productValidator
                            //         ? 'Value Can\'t Be Empty'
                            //         : null,
                            //     labelText: 'Type Product Name*',
                            //     labelStyle: TextStyle(
                            //       //fontWeight: FontWeight.normal,
                            //       color: Colors.grey, fontSize: 15,
                            //     ),
                            //     focusedBorder: UnderlineInputBorder(
                            //       borderSide: BorderSide(color: Colors.blue),
                            //     ),
                            //   ),
                            // ),

                            // Container(
                            //   padding: EdgeInsets.only(
                            //       top: 0.0, left: 20.0, right: 20.0),
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       _productNameController.text =
                            //           _productNameSearchController.text;
                            //       _unitPriceController.text = '0';
                            //       widget.callBackFunction();
                            //       _productNameSearchController.text = '';
                            //       Navigator.of(context).pop();
                            //     },
                            //     child: Container(
                            //       height: 30.0,
                            //       width: 300.0,
                            //       child: Material(
                            //         borderRadius: BorderRadius.circular(20.0),
                            //         shadowColor: Colors.grey,
                            //         color: Colors.grey[600],
                            //         elevation: 7.0,
                            //         child: Center(
                            //           child: Text(
                            //             "Add This As New Product Name",
                            //             style: TextStyle(
                            //                 color: Colors.black,
                            //                 fontSize: 10.0),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ))
                  : Center(
                      child: CircularProgressIndicator(),
                    )
              : Center(
                  child: Text(
                    'Type Minimum 2 Characters \nThen Press Search Button',
                    textAlign: TextAlign.center,
                  ),
                )
        ],
      ),
      // (productLoaded)
      //     ?

      //
    );
  }
}
