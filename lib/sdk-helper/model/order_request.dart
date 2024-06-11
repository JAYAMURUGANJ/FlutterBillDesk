import 'package:my_flutter_app/sdk-helper/model/order_response.dart';

class OrderRequest {
  String? mercid;
  String? orderid;
  String? amount;
  String? orderDate;
  String? currency;
  String? ru;
  String? itemcode;
  AdditionalInfo? additionalInfo;
  Customer? customer;
  Device? device;

  OrderRequest(
      {this.mercid,
      this.orderid,
      this.amount,
      this.orderDate,
      this.currency,
      this.ru,
      this.itemcode,
      this.additionalInfo,
      this.customer,
      this.device});

  OrderRequest.fromJson(Map<String, dynamic> json) {
    mercid = json['mercid'];
    orderid = json['orderid'];
    amount = json['amount'];
    orderDate = json['order_date'];
    currency = json['currency'];
    ru = json['ru'];
    itemcode = json['itemcode'];
    additionalInfo = json['additional_info'] != null
        ? AdditionalInfo.fromJson(json['additional_info'])
        : null;
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    device = json['device'] != null ? Device.fromJson(json['device']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mercid'] = mercid;
    data['orderid'] = orderid;
    data['amount'] = amount;
    data['order_date'] = orderDate;
    data['currency'] = currency;
    data['ru'] = ru;
    data['itemcode'] = itemcode;
    if (additionalInfo != null) {
      data['additional_info'] = additionalInfo!.toJson();
    }
    if (device != null) {
      data['device'] = device!.toJson();
    }
    return data;
  }
}

class Customer {
  String? firsName;
  String? lastName;
  String? email;
  String? mobile;
  Customer({
    this.firsName,
    this.lastName,
    this.email,
    this.mobile,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    firsName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firsName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['mobile'] = mobile;
    return data;
  }
}

class Device {
  String? initChannel;
  String? ip;
  String? userAgent;
  String? acceptHeader;

  Device({this.initChannel, this.ip, this.userAgent, this.acceptHeader});

  Device.fromJson(Map<String, dynamic> json) {
    initChannel = json['init_channel'];
    ip = json['ip'];
    userAgent = json['user_agent'];
    acceptHeader = json['accept_header'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['init_channel'] = initChannel;
    data['ip'] = ip;
    data['user_agent'] = userAgent;
    data['accept_header'] = acceptHeader;
    return data;
  }
}

// class AdditionalInfo {
//   String? additionalInfo1;
//   String? additionalInfo2;
//   String? additionalInfo3;

//   AdditionalInfo({this.additionalInfo1, this.additionalInfo2});

//   AdditionalInfo.fromJson(Map<String, dynamic> json) {
//     additionalInfo1 = json['additional_info1'];
//     additionalInfo2 = json['additional_info2'];
//     additionalInfo3 = json['additional_info3'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['additional_info1'] = additionalInfo1;
//     data['additional_info2'] = additionalInfo2;
//     data['additional_info3'] = additionalInfo3;
//     return data;
//   }
// }
