/// new_lead : {"profession":"","customerName":"","customerContact":"","customerAddress":"","customerEmail":"","customerDOB":"","companyName":"","longitude":"","lattitude":"","userID":"","leadSource":"","remark":"","nextFollowUpDate":"","_salesPerson":"","_paymentMethod":"","itemDetails":[{"productName":"","productModel":"","quantity":"","productRemarks":"","unitPrice":"","totalPrice":""}]}

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
/// nextFollowUpDate : ""
/// _salesPerson : ""
/// _paymentMethod : ""
/// itemDetails : [{"productName":"","productModel":"","quantity":"","productRemarks":"","unitPrice":"","totalPrice":""}]

class New_lead_json {
  New_lead_json(
      {String? profession,
      String? leadCategory,
      String? bsoType,
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
      String? leadProspectType,
      String? nextFollowUpDate,
      String? salesPerson,
      String? paymentMethod,
      String? isAutoFinance,
      List<Todo>? itemDetails}) {
    _profession = profession;
    _leadCategory = leadCategory;
    _bsoType = bsoType;
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
    _leadProspectType = leadProspectType;
    _nextFollowUpDate = nextFollowUpDate;
    _salesPerson = salesPerson;
    _paymentMethod = paymentMethod;
    _isAutoFinance = isAutoFinance;
    _itemDetails = itemDetails;
  }

  New_lead_json.fromJson(dynamic json) {
    _profession = json['profession'];
    _leadCategory = json['leadCategory'];
    _bsoType = json['bsoType'];
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
    _leadProspectType = json['leadProspectType'];
    _nextFollowUpDate = json['nextFollowUpDate'];
    _salesPerson = json['salesPerson'];
    _paymentMethod = json['paymentMethod'];
    _isAutoFinance = json['isAutoFinance'];
    if (json['itemDetails'] != null) {
      _itemDetails = [];
      json['itemDetails'].forEach((v) {
        _itemDetails?.add(Todo.fromJson(v));
      });
    }
  }
  String? _profession;
  String? _leadCategory;
  String? _bsoType;
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
  String? _leadProspectType;
  String? _nextFollowUpDate;
  String? _salesPerson;
  String? _paymentMethod;
  String? _isAutoFinance;
  List<Todo>? _itemDetails;

  String? get profession => _profession;
  String? get leadCategory => _leadCategory;
  String? get bsoType => _bsoType;
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
  String? get leadProspectType => _leadProspectType;
  String? get nextFollowUpDate => _nextFollowUpDate;
  String? get salesPerson => _salesPerson;
  String? get paymentMethod => _paymentMethod;
  String? get isAutoFinance => _isAutoFinance;
  List<Todo>? get itemDetails => _itemDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profession'] = _profession;
    map['leadCategory'] = _leadCategory;
    map['bsoType'] = _bsoType;
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
    map['leadProspectType'] = _leadProspectType;
    map['followUpDate'] = _nextFollowUpDate;
    map['salesPerson'] = _salesPerson;
    map['paymentMethod'] = _paymentMethod;
    map['isAutoFinance'] = _isAutoFinance;
    if (_itemDetails != null) {
      map['itemDetails'] = _itemDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// productName : ""
/// productModel : ""
/// quantity : ""
/// productRemarks : ""
/// unitPrice : ""
/// totalPrice : ""

class Todo {
  Todo(
      {String? productName,
      String? productModel,
      String? quantity,
      String? productRemarks,
      String? unitPrice,
      //String? totalPrice,
      String? prospectType}) {
    _productName = productName;
    _productModel = productModel;
    _quantity = quantity;
    _productRemarks = productRemarks;
    _unitPrice = unitPrice;
    _prospectType = prospectType;
    //_totalPrice = totalPrice;
  }

  Todo.fromJson(dynamic json) {
    _productName = json['productName'];
    _productModel = json['productModel'];
    _quantity = json['quantity'];
    _productRemarks = json['productRemarks'];
    _unitPrice = json['unitPrice'];
    _prospectType = json['prospectType'];
    //_totalPrice = json['totalPrice'];
  }
  String? _productName;
  String? _productModel;
  String? _quantity;
  String? _productRemarks;
  String? _unitPrice;
  String? _prospectType;
  //String? _totalPrice;

  String? get productName => _productName;
  String? get productModel => _productModel;
  String? get quantity => _quantity;
  String? get productRemarks => _productRemarks;
  String? get unitPrice => _unitPrice;
  String? get prospectType => _prospectType;
  //String? get totalPrice => _totalPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productName'] = _productName;
    map['productModel'] = _productModel;
    map['quantity'] = _quantity;
    map['productRemarks'] = _productRemarks;
    map['unitPrice'] = _unitPrice;
    map['prospectType'] = _prospectType;
    //map['totalPrice'] = _totalPrice;
    return map;
  }
}
