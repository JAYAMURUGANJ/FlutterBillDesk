// ignore_for_file: must_be_immutable

import 'package:billDeskSDK/sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sdk-helper/model/error_response.dart';
import '../sqlite-helper/db_helper.dart';
import '../sqlite-helper/model/order.dart';
import '/sdk-helper/billdesk.dart';
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
    _insertOrder(txnInfoMap);
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

  Future<void> _insertOrder(TxnInfo txnInfo) async {
    final order = Order(
      isCancelledByUser: txnInfo.txnInfoMap["isCancelledByUser"] ? 1 : 0,
      orderId: txnInfo.txnInfoMap["orderId"],
      customerRefId: txnInfo.txnInfoMap["customerRefId"],
      merchantId: txnInfo.txnInfoMap["merchantId"],
    );
    await DatabaseHelper.instance.insertOrder(order.toMap());
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
  // bool isSuccess = false;
  bool isLoading = false;
  late String traceId;
  late String timeStamp;
  late RetrieveTxnResponse txnResponse;

  Future<void> retrieveTransactionStatus() async {
    try {
      setState(() {
        isLoading = true;
      });

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
        // setState(() {
        //   isSuccess = txnResponse.authStatus == "0300" ? true : false;
        // });

        if (txnResponse.authStatus == "0300") {
          Get.to(
            PaymentSuccessWidget(
              txnInfo: widget.txnInfo,
              txnResponse: txnResponse,
            ),
          );
        } else if (txnResponse.authStatus == "0399" ||
            txnResponse.authStatus == "0002") {
          Get.to(
            PaymentFailedWidget(
              txnInfo: widget.txnInfo,
              txnResponse: txnResponse,
            ),
          );
        }
      } else {
        ErrorResponse error =
            ErrorResponse().getErrorResponse(response.statusCode!);
        Get.defaultDialog(
          title: error.message!,
          middleText: error.description!,
          confirm: ElevatedButton(
            onPressed: () => Get.to(const GoPay()),
            child: const Text('Dismiss'),
          ),
        );
      }
    } catch (e) {
      debugPrint("Exception occurred: $e");
      //if order creation is not possible
      ErrorResponse error = ErrorResponse().getErrorResponse(e.hashCode);
      Get.defaultDialog(
        title: error.status.toString(),
        middleText: error.message!,
        confirm: ElevatedButton(
          onPressed: () => Get.to(const GoPay()),
          child: const Text('Dismiss'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Fetch Transaction"),
        ),
        body: Center(
          child: isLoading
              ? const CustomProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Check \nTransaction Details",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        'Merchant ID: ${widget.txnInfo.txnInfoMap["merchantId"]}'),
                    const SizedBox(height: 10),
                    Text('Order ID: ${widget.txnInfo.txnInfoMap["orderId"]}'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        height: 40,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          elevation: 0,
                          color: Theme.of(context).colorScheme.primary,
                          // textColor: Colors.white,
                          disabledColor: Colors.grey,
                          //  disabledTextColor: Colors.blueGrey,
                          onPressed:
                              !isLoading ? retrieveTransactionStatus : null,
                          child: const Text(
                            "Check",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }
}

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
              onPressed: () => Get.to(const GoPay()),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transaction Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.red,
              child: Icon(
                txnResponse.authStatus == "0399"
                    ? Icons.close_sharp
                    : txnResponse.authStatus == "0002"
                        ? Icons.pending_actions
                        : Icons.pending_actions,
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
        ),
      ),
    );
  }
}
