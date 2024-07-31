import 'package:billDeskSDK/sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sqlite-helper/db_helper.dart';
import '../sqlite-helper/model/order.dart';
import 'payment_status.dart';

class TxnHistory extends StatefulWidget {
  const TxnHistory({super.key});

  @override
  _TxnHistoryState createState() => _TxnHistoryState();
}

class _TxnHistoryState extends State<TxnHistory> {
  late Future<List<Order>> ordersFuture;

  @override
  void initState() {
    super.initState();
    ordersFuture = _fetchOrders();
  }

  Future<List<Order>> _fetchOrders() async {
    final orderMaps = await DatabaseHelper.instance.fetchOrders();
    return orderMaps.map((map) => Order.fromMap(map)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction history')),
      body: FutureBuilder<List<Order>>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Transaction found.'));
          } else {
            final orders = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  style: ListTileStyle.drawer,
                  onTap: () => Get.to(PaymentResultPage(
                    txnInfo: TxnInfo(txnInfoMap: order.toMap()),
                  )),
                  dense: true,
                  isThreeLine: true,
                  title: Text("Order-Id: ${order.orderId}"),
                  subtitle: Text("Merchant-Id: ${order.merchantId}"),
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  trailing: Card(
                    color: order.isCancelledByUser == 0
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(order.isCancelledByUser == 1
                          ? 'Cancelled'
                          : 'Active'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
