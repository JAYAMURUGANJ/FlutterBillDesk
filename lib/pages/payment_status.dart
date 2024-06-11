// ignore_for_file: must_be_immutable

import 'package:billDeskSDK/sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/sdk-helper/billdesk.dart';
import '/sdk-helper/model/error_response.dart';
import '/sdk-helper/model/retrieve_txn_response.dart';
import '/utils/extension.dart';
import '/utils/jwt/jwt_helper.dart';
import 'goPay.dart';
import 'widget/progress_indicator.dart';

class PaymentStatus extends StatefulWidget implements ResponseHandler {
  const PaymentStatus({super.key});

  @override
  State<PaymentStatus> createState() => _PaymentStatusState();

  @override
  void onError(SdkError sdkError) {
    debugPrint(sdkError.toString());
    Get.defaultDialog(
      title: 'SDK Internal Error',
      middleText: '$sdkError',
      confirm: ElevatedButton(
        onPressed: () => Get.to(const GoPay()),
        child: const Text('Dismiss'),
      ),
    );
  }

  @override
  Future<void> onTransactionResponse(TxnInfo txnInfoMap) async {
    debugPrint(txnInfoMap.toString());
    if (txnInfoMap.txnInfoMap["isCancelledByUser"] == false) {
      Get.to(() => PaymentResultPage(txnInfo: txnInfoMap));
    } else {
      Get.defaultDialog(
        title: 'Transaction Aborted',
        middleText: 'Transaction was cancelled by user',
        confirm: ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
      );
    }
  }
}

class _PaymentStatusState extends State<PaymentStatus> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.pink,
          value: 25,
        ),
      ),
    );
  }
}

class PaymentResultPage extends StatefulWidget {
  final TxnInfo txnInfo;

  const PaymentResultPage({super.key, required this.txnInfo});

  @override
  State<PaymentResultPage> createState() => _PaymentResultPageState();
}

class _PaymentResultPageState extends State<PaymentResultPage> {
  bool isSuccess = false;
  bool isLoading = true;
  late String traceId;
  late String timeStamp;
  late RetrieveTxnResponse txnResponse;

  @override
  void initState() {
    super.initState();

    _retrieveTransactionStatus();
  }

  Future<void> _retrieveTransactionStatus() async {
    setState(() {
      DateTime now = getCurrentTimestamp();
      traceId = ''.getOrderId(13);
      timeStamp = now.toFormattedString();
    });

    var response = await BillDesk(traceId: traceId, timeStamp: timeStamp)
        .retrieveTransaction(widget.txnInfo.txnInfoMap["orderId"]);

    debugPrint("Encoded Response for Fetch Transaction :$response");

    if (response.statusCode == 200) {
      var decodedResponse = await JwtHelper().decode(response.data);
      debugPrint("Decoded Response for Fetch Transaction :$decodedResponse");
      txnResponse = RetrieveTxnResponse.fromJson(decodedResponse);
      debugPrint(txnResponse.transactionErrorType);
      setState(() {
        isSuccess = txnResponse.authStatus == "0300" ? true : false;
      });
    } else {
      var decodedResponse = await JwtHelper().decode(response.data);
      debugPrint("Decoded Response for Fetch Transaction :$decodedResponse");
      ErrorResponse().getErrorResponse(response.statusCode!);
      setState(() {
        isSuccess = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transaction status"),
      ),
      body: Center(
        child: isLoading
            ? const CustomProgressIndicator()
            : isSuccess
                ? PaymentSuccessWidget(
                    txnInfo: widget.txnInfo,
                    txnResponse: txnResponse,
                  )
                : PaymentFailedWidget(
                    txnInfo: widget.txnInfo,
                    txnResponse: txnResponse,
                  ),
      ),
    );
  }
}

class PaymentSuccessWidget extends StatelessWidget {
  final TxnInfo txnInfo;
  final RetrieveTxnResponse txnResponse;

  const PaymentSuccessWidget(
      {super.key, required this.txnInfo, required this.txnResponse});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
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
          onPressed: () => Get.to(const GoPay()),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class PaymentFailedWidget extends StatelessWidget {
  final TxnInfo txnInfo;
  final RetrieveTxnResponse txnResponse;

  const PaymentFailedWidget(
      {super.key, required this.txnInfo, required this.txnResponse});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.red,
          child: Icon(
            Icons.sentiment_very_dissatisfied_outlined,
            color: Colors.white,
            size: 60,
          ),
        ),
        const SizedBox(height: 50),
        Text(
          txnResponse.authStatus == "0399"
              ? "Transaction Failed"
              : txnResponse.authStatus == "0002"
                  ? "Transaction Pending"
                  : "Somthing went wrong!",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text('Merchant ID: ${txnInfo.txnInfoMap["merchantId"]}'),
        Text('Order ID: ${txnInfo.txnInfoMap["orderId"]}'),
        ElevatedButton(
          onPressed: () => Get.to(const GoPay()),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
