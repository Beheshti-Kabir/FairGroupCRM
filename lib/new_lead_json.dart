/// new_lead : {"profession":"","customerName":"","customerContact":"","customerAddress":"","customerEmail":"","customerDOB":"","companyName":"","longitude":"","lattitude":"","userID":"","leadSource":"","remark":"","leadDate":"","_salesPerson":"","_paymentMethod":"","itemDetails":[{"productName":"","description":"","quantity":"","stock":"","unitPrice":"","totalPrice":""}]}

// class NewLeadJson {
//   NewLeadJson({
//       New_lead? newLead,}){
//     _newLead = newLead;
// }
//
//   NewLeadJson.fromJson(dynamic json) {
//     _newLead = json['new_lead'] != null ? New_lead.fromJson(json['newLead']) : null;
//   }
//   New_lead? _newLead;
//
//   New_lead? get newLead => _newLead;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_newLead != null) {
//       map['new_lead'] = _newLead?.toJson();
//     }
//     return map;
//   }
//
// }

/// profession : ""
/// customerName : ""
/// customerContact : ""
/// customerAddress : ""
/// customerEmail : ""
/// customerDOB : ""
/// companyName : ""
/// longitude : ""
/// lattitude : ""
/// userID : ""
/// leadSource : ""
/// remark : ""
/// leadDate : ""
/// _salesPerson : ""
/// _paymentMethod : ""
/// itemDetails : [{"productName":"","description":"","quantity":"","stock":"","unitPrice":"","totalPrice":""}]

class New_lead_json {
  New_lead_json(
      {String? profession,
      String? customerName,
      String? customerContact,
      String? customerAddress,
      String? customerEmail,
      String? customerDOB,
      String? companyName,
      String? longitude,
      String? lattitude,
      String? userID,
      String? leadSource,
      String? remark,
      String? leadDate,
      String? salesPerson,
      String? paymentMethod,
      List<Todo>? itemDetails}) {
    _profession = profession;
    _customerName = customerName;
    _customerContact = customerContact;
    _customerAddress = customerAddress;
    _customerEmail = customerEmail;
    _customerDOB = customerDOB;
    _companyName = companyName;
    _longitude = longitude;
    _lattitude = lattitude;
    _userID = userID;
    _leadSource = leadSource;
    _remark = remark;
    _leadDate = leadDate;
    _salesPerson = salesPerson;
    _paymentMethod = paymentMethod;
    _itemDetails = itemDetails;
  }

  New_lead_json.fromJson(dynamic json) {
    _profession = json['profession'];
    _customerName = json['customerName'];
    _customerContact = json['customerContact'];
    _customerAddress = json['customerAddress'];
    _customerEmail = json['customerEmail'];
    _customerDOB = json['customerDOB'];
    _companyName = json['companyName'];
    _longitude = json['longitude'];
    _lattitude = json['lattitude'];
    _userID = json['userID'];
    _leadSource = json['leadSource'];
    _remark = json['remark'];
    _leadDate = json['leadDate'];
    _salesPerson = json['salesPerson'];
    _paymentMethod = json['paymentMethod'];
    if (json['itemDetails'] != null) {
      _itemDetails = [];
      json['itemDetails'].forEach((v) {
        _itemDetails?.add(Todo.fromJson(v));
      });
    }
  }
  String? _profession;
  String? _customerName;
  String? _customerContact;
  String? _customerAddress;
  String? _customerEmail;
  String? _customerDOB;
  String? _companyName;
  String? _longitude;
  String? _lattitude;
  String? _userID;
  String? _leadSource;
  String? _remark;
  String? _leadDate;
  String? _salesPerson;
  String? _paymentMethod;
  List<Todo>? _itemDetails;

  String? get profession => _profession;
  String? get customerName => _customerName;
  String? get customerContact => _customerContact;
  String? get customerAddress => _customerAddress;
  String? get customerEmail => _customerEmail;
  String? get customerDOB => _customerDOB;
  String? get companyName => _companyName;
  String? get longitude => _longitude;
  String? get lattitude => _lattitude;
  String? get userID => _userID;
  String? get leadSource => _leadSource;
  String? get remark => _remark;
  String? get leadDate => _leadDate;
  String? get salesPerson => _salesPerson;
  String? get paymentMethod => _paymentMethod;
  List<Todo>? get itemDetails => _itemDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profession'] = _profession;
    map['customerName'] = _customerName;
    map['customerContact'] = _customerContact;
    map['customerAddress'] = _customerAddress;
    map['customerEmail'] = _customerEmail;
    map['customerDOB'] = _customerDOB;
    map['companyName'] = _companyName;
    map['longitude'] = _longitude;
    map['lattitude'] = _lattitude;
    map['userID'] = _userID;
    map['leadSource'] = _leadSource;
    map['remark'] = _remark;
    map['leadDate'] = _leadDate;
    map['_salesPerson'] = _salesPerson;
    map['_paymentMethod'] = _paymentMethod;
    if (_itemDetails != null) {
      map['itemDetails'] = _itemDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// productName : ""
/// description : ""
/// quantity : ""
/// stock : ""
/// unitPrice : ""
/// totalPrice : ""

class Todo {
  Todo({
    String? productName,
    String? description,
    String? quantity,
    //String? stock,
    String? unitPrice,
    //String? totalPrice,
  }) {
    _productName = productName;
    _description = description;
    _quantity = quantity;
    //_stock = stock;
    _unitPrice = unitPrice;
    //_totalPrice = totalPrice;
  }

  Todo.fromJson(dynamic json) {
    _productName = json['productName'];
    _description = json['description'];
    _quantity = json['quantity'];
    //_stock = json['stock'];
    _unitPrice = json['unitPrice'];
    //_totalPrice = json['totalPrice'];
  }
  String? _productName;
  String? _description;
  String? _quantity;
  //String? _stock;
  String? _unitPrice;
  //String? _totalPrice;

  String? get productName => _productName;
  String? get description => _description;
  String? get quantity => _quantity;
  //String? get stock => _stock;
  String? get unitPrice => _unitPrice;
  //String? get totalPrice => _totalPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productName'] = _productName;
    map['description'] = _description;
    map['quantity'] = _quantity;
    //map['stock'] = _stock;
    map['unitPrice'] = _unitPrice;
    //map['totalPrice'] = _totalPrice;
    return map;
  }
}
