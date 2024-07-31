class BDOrderResponse {
  String? objectid;
  String? orderid;
  String? bdorderid;
  String? mercid;
  String? orderDate;
  String? amount;
  String? currency;
  String? ru;
  AdditionalInfo? additionalInfo;
  String? itemcode;
  String? createdon;
  String? nextStep;
  List<Links>? links;
  String? status;

  BDOrderResponse(
      {this.objectid,
      this.orderid,
      this.bdorderid,
      this.mercid,
      this.orderDate,
      this.amount,
      this.currency,
      this.ru,
      this.additionalInfo,
      this.itemcode,
      this.createdon,
      this.nextStep,
      this.links,
      this.status});

  BDOrderResponse.fromJson(Map<String, dynamic> json) {
    objectid = json['objectid'];
    orderid = json['orderid'];
    bdorderid = json['bdorderid'];
    mercid = json['mercid'];
    orderDate = json['order_date'];
    amount = json['amount'];
    currency = json['currency'];
    ru = json['ru'];
    additionalInfo = json['additional_info'] != null
        ? AdditionalInfo.fromJson(json['additional_info'])
        : null;
    itemcode = json['itemcode'];
    createdon = json['createdon'];
    nextStep = json['next_step'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectid'] = objectid;
    data['orderid'] = orderid;
    data['bdorderid'] = bdorderid;
    data['mercid'] = mercid;
    data['order_date'] = orderDate;
    data['amount'] = amount;
    data['currency'] = currency;
    data['ru'] = ru;
    if (additionalInfo != null) {
      data['additional_info'] = additionalInfo!.toJson();
    }
    data['itemcode'] = itemcode;
    data['createdon'] = createdon;
    data['next_step'] = nextStep;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class AdditionalInfo {
  String? additionalInfo1;
  String? additionalInfo2;
  String? additionalInfo3;
  String? additionalInfo4;
  String? additionalInfo5;
  String? additionalInfo6;
  String? additionalInfo7;

  AdditionalInfo(
      {this.additionalInfo1,
      this.additionalInfo2,
      this.additionalInfo3,
      this.additionalInfo4,
      this.additionalInfo5,
      this.additionalInfo6,
      this.additionalInfo7});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    additionalInfo1 = json['additional_info1'];
    additionalInfo2 = json['additional_info2'];
    additionalInfo3 = json['additional_info3'];
    additionalInfo4 = json['additional_info4'];
    additionalInfo5 = json['additional_info5'];
    additionalInfo6 = json['additional_info6'];
    additionalInfo7 = json['additional_info7'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (additionalInfo1 != null) {
      data['additional_info1'] = additionalInfo1;
    }
    if (additionalInfo2 != null) {
      data['additional_info2'] = additionalInfo2;
    }
    if (additionalInfo3 != null) {
      data['additional_info3'] = additionalInfo3;
    }
    if (additionalInfo4 != null) {
      data['additional_info4'] = additionalInfo4;
    }
    if (additionalInfo5 != null) {
      data['additional_info5'] = additionalInfo5;
    }
    if (additionalInfo6 != null) {
      data['additional_info6'] = additionalInfo6;
    }
    if (additionalInfo7 != null) {
      data['additional_info7'] = additionalInfo7;
    }

    return data;
  }
}

class Links {
  String? href;
  String? rel;
  String? method;
  Parameters? parameters;
  String? validDate;
  Headers? headers;

  Links(
      {this.href,
      this.rel,
      this.method,
      this.parameters,
      this.validDate,
      this.headers});

  Links.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    rel = json['rel'];
    method = json['method'];
    parameters = json['parameters'] != null
        ? Parameters.fromJson(json['parameters'])
        : null;
    validDate = json['valid_date'];
    headers =
        json['headers'] != null ? Headers.fromJson(json['headers']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    data['rel'] = rel;
    data['method'] = method;
    if (parameters != null) {
      data['parameters'] = parameters!.toJson();
    }
    data['valid_date'] = validDate;
    if (headers != null) {
      data['headers'] = headers!.toJson();
    }
    return data;
  }
}

class Parameters {
  String? mercid;
  String? bdorderid;
  String? rdata;

  Parameters({this.mercid, this.bdorderid, this.rdata});

  Parameters.fromJson(Map<String, dynamic> json) {
    mercid = json['mercid'];
    bdorderid = json['bdorderid'];
    rdata = json['rdata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mercid'] = mercid;
    data['bdorderid'] = bdorderid;
    data['rdata'] = rdata;
    return data;
  }
}

class Headers {
  String? authorization;

  Headers({this.authorization});

  Headers.fromJson(Map<String, dynamic> json) {
    authorization = json['authorization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['authorization'] = authorization;
    return data;
  }
}
