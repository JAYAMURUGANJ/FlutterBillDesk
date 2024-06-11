class JWTHeader {
  String? alg;
  String? clientid;

  JWTHeader({this.alg, this.clientid});

  JWTHeader.fromJson(Map<String, dynamic> json) {
    alg = json['alg'];
    clientid = json['clientid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alg'] = alg;
    data['clientid'] = clientid;
    return data;
  }
}
