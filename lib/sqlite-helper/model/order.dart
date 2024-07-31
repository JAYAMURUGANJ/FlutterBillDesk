class Order {
  final int isCancelledByUser;
  final String orderId;
  final String? customerRefId;
  final String merchantId;

  Order({
    required this.isCancelledByUser,
    required this.orderId,
    this.customerRefId,
    required this.merchantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'isCancelledByUser': isCancelledByUser == 1 ? true : false,
      'orderId': orderId,
      'customerRefId': customerRefId,
      'merchantId': merchantId,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      isCancelledByUser: map['isCancelledByUser'],
      orderId: map['orderId'],
      customerRefId: map['customerRefId'],
      merchantId: map['merchantId'],
    );
  }
}
