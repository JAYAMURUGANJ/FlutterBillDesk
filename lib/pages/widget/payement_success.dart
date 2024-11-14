import 'package:billDeskSDK/sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/utils/extension.dart';

import '../../sdk-helper/model/retrieve_txn_response.dart';
import '../start_txn.dart';

class PaymentSuccessWidget extends StatelessWidget {
  final TxnInfo txnInfo;
  final RetrieveTxnResponse txnResponse;

  const PaymentSuccessWidget(
      {super.key, required this.txnInfo, required this.txnResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transaction Details"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.done_rounded,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 50),
            Text(
              txnResponse.amount!.toRupee(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 10),
            Text(
              "Paid to BillDesk",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text('Merchant ID: ${txnInfo.txnInfoMap["merchantId"]}'),
            const SizedBox(height: 100),
            Text(
              txnResponse.transactionDate!.toFormattedDate(),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text("Transaction Id: ${txnResponse.transactionid}"),
            Text('Order ID: ${txnInfo.txnInfoMap["orderId"]}'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Get.to(const StartTxn()),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
