import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:login_prac/todo.dart';

import 'new_lead_json.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({Key? key}) : super(key: key);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  initState() {
    super.initState();
    //getProduct();
  }

  getProduct() async {
    print("inside getData");
    final response = await http
        .get(Uri.parse('http://202.84.44.234:9085/rbd/leadInfoApi/getData'));

    produtcListJSON = json.decode(response.body)['productList'];

    productListNumber = produtcListJSON.length;

    // print(salesPersonJSON[4]['empCode'].toString() +
    //     ' ' +
    //     salesPersonJSON[4]['empName']);
    // print("leaving getData");
    for (var i = 0; i < productListNumber; i++) {
      int productLenght = produtcListJSON[i]['name'].length;
      double productLengthHalf = productLenght.toDouble() / 2;
      int productHalfLenght = productLengthHalf.toInt();
      if (productLenght > 30) {
        if (productLenght.isEven) {
          produtcListJSON[i]['name'] =
              produtcListJSON[i]['name'].substring(0, productHalfLenght) +
                  produtcListJSON[i]['name'].substring(productHalfLenght);
        } else {
          produtcListJSON[i]['name'] =
              produtcListJSON[i]['name'].substring(0, productHalfLenght + 1) +
                  produtcListJSON[i]['name'].substring(productHalfLenght + 1);
        }
      }
      String productListMiddle = produtcListJSON[i]['name'] +
          ' & Code: ' +
          produtcListJSON[i]['code'].toString();
      product_list.insert(0, productListMiddle);
    }

    print("Leaing Lead Loop");
  }

  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _stockController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _productListController = '';
  var count = 0;
  late var produtcListJSON;
  late var productListNumber;

  String productName = '';
  String description = '';
  String quantity = '';
  String stock = '';
  String unitPrice = '';
  String totalPrice = '';
  List<Todo> detailsTable = [];
  var icnSize = 18.0;
  var dropColor = Colors.blue;
  List<String> product_list = [''];

  late Todo detailsModel;

  bool _quantityValidate = false;
  bool _productNameValidate = false;

  void clearController() {
    _productNameController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _stockController.clear();
    _unitPriceController.clear();
    _totalPriceController.clear();
  }

  formValidator() {
    String productNameValidation = _productNameController.text;
    String quantityValidation = _quantityController.text;
    setState(() {
      if (productNameValidation == null || productNameValidation.isEmpty) {
        _productNameValidate = true;
      } else {
        _productNameValidate = false;
      }
      if (quantityValidation == null || quantityValidation.isEmpty) {
        _quantityValidate = true;
      } else {
        _quantityValidate = false;
      }
    });
    if (!_productNameValidate && !_quantityValidate) {
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
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _productNameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
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
            // SizedBox(
            //   height: 15.0,
            // ),
            Container(
              padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
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
                      labelText: 'Quantity',
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
                      bool isValid = formValidator();
                      if (isValid) {
                        count += 1;
                        productName = _productNameController.text.toString();
                        description = _descriptionController.text.toString();
                        quantity = _quantityController.text.toString();
                        unitPrice = _unitPriceController.text.toString();
                        //stock = _stockController.text.toString();
                        //totalPrice = _totalPriceController.text.toString();
                        detailsModel = Todo(
                            productName: productName,
                            description: description,
                            quantity: quantity,
                            //stock: "stock",
                            unitPrice: unitPrice);
                        //totalPrice: "totalPrice");
                        detailsTable.add(detailsModel);
                        clearController();
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 30.0,
                      width: 80.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.lightBlueAccent,
                        color: Colors.blue[800],
                        elevation: 7.0,
                        child: Center(
                          child: Text(
                            "Add items",
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
                      print('count:' + count.toString());
                      Navigator.of(context).pop(detailsTable);
                    },
                    child: Container(
                      height: 30.0,
                      width: 80.0,
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
                      'Product',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      "Description",
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
                            model.description.toString(),
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
