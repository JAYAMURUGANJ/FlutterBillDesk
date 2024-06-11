class RetrieveTxnResponse {
  String? objectid;
  String? transactionid;
  String? orderid;
  String? mercid;
  String? transactionDate;
  String? amount;
  String? surcharge;
  String? discount;
  String? chargeAmount;
  String? currency;
  AdditionalInfo? additionalInfo;
  String? ru;
  String? txnProcessType;
  String? bankid;
  String? itemcode;
  String? bankRefNo;
  String? authStatus;
  String? transactionErrorCode;
  String? transactionErrorDesc;
  String? transactionErrorType;
  String? paymentMethodType;
  String? paymentCategory;

  RetrieveTxnResponse(
      {this.objectid,
      this.transactionid,
      this.orderid,
      this.mercid,
      this.transactionDate,
      this.amount,
      this.surcharge,
      this.discount,
      this.chargeAmount,
      this.currency,
      this.additionalInfo,
      this.ru,
      this.txnProcessType,
      this.bankid,
      this.itemcode,
      this.bankRefNo,
      this.authStatus,
      this.transactionErrorCode,
      this.transactionErrorDesc,
      this.transactionErrorType,
      this.paymentMethodType,
      this.paymentCategory});

  RetrieveTxnResponse.fromJson(Map<String, dynamic> json) {
    objectid = json['objectid'];
    transactionid = json['transactionid'];
    orderid = json['orderid'];
    mercid = json['mercid'];
    transactionDate = json['transaction_date'];
    amount = json['amount'];
    surcharge = json['surcharge'];
    discount = json['discount'];
    chargeAmount = json['charge_amount'];
    currency = json['currency'];
    additionalInfo = json['additional_info'] != null
        ? AdditionalInfo.fromJson(json['additional_info'])
        : null;
    ru = json['ru'];
    txnProcessType = json['txn_process_type'];
    bankid = json['bankid'];
    itemcode = json['itemcode'];
    bankRefNo = json['bank_ref_no'];
    authStatus = json['auth_status'];
    transactionErrorCode = json['transaction_error_code'];
    transactionErrorDesc = json['transaction_error_desc'];
    transactionErrorType = json['transaction_error_type'];
    paymentMethodType = json['payment_method_type'];
    paymentCategory = json['payment_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectid'] = objectid;
    data['transactionid'] = transactionid;
    data['orderid'] = orderid;
    data['mercid'] = mercid;
    data['transaction_date'] = transactionDate;
    data['amount'] = amount;
    data['surcharge'] = surcharge;
    data['discount'] = discount;
    data['charge_amount'] = chargeAmount;
    data['currency'] = currency;
    if (additionalInfo != null) {
      data['additional_info'] = additionalInfo!.toJson();
    }
    data['ru'] = ru;
    data['txn_process_type'] = txnProcessType;
    data['bankid'] = bankid;
    data['itemcode'] = itemcode;
    data['bank_ref_no'] = bankRefNo;
    data['auth_status'] = authStatus;
    data['transaction_error_code'] = transactionErrorCode;
    data['transaction_error_desc'] = transactionErrorDesc;
    data['transaction_error_type'] = transactionErrorType;
    data['payment_method_type'] = paymentMethodType;
    data['payment_category'] = paymentCategory;
    return data;
  }
}

class AdditionalInfo {
  String? additionalInfo1;
  String? additionalInfo2;

  AdditionalInfo({this.additionalInfo1, this.additionalInfo2});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    additionalInfo1 = json['additional_info1'];
    additionalInfo2 = json['additional_info2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['additional_info1'] = additionalInfo1;
    data['additional_info2'] = additionalInfo2;
    return data;
  }
}
