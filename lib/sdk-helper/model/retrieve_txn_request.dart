class RetrieveTxnRequest {
  String? mercid;
  String? orderid;

  RetrieveTxnRequest({this.mercid, this.orderid});

  RetrieveTxnRequest.fromJson(Map<String, dynamic> json) {
    mercid = json['mercid'];
    orderid = json['orderid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mercid'] = mercid;
    data['orderid'] = orderid;
    return data;
  }
}
