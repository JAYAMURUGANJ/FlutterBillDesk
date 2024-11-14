import 'package:billDeskSDK/sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/utils/extension.dart';

import '../sdk-helper/api_request_handler.dart';
import '../sdk-helper/model/error_response.dart';
import '../sdk-helper/model/retrieve_txn_response.dart';
import '../utils/jwt/jwt_helper.dart';
import 'start_txn.dart';
import 'widget/payement_faile.dart';
import 'widget/payement_success.dart';
import 'widget/progress_indicator.dart';

class CheckTxnDetails extends StatefulWidget {
  final TxnInfo txnInfo;

  const CheckTxnDetails({super.key, required this.txnInfo});

  @override
  State<CheckTxnDetails> createState() => _CheckTxnDetailsState();
}

class _CheckTxnDetailsState extends State<CheckTxnDetails> {
  bool isLoading = false;
  late String traceId;
  late String timeStamp;
  late RetrieveTxnResponse txnResponse;

  @override
  void initState() {
    super.initState();
    // Set initial values
    DateTime now = DateTime.now();
    traceId = ''.getOrderId(13);
    timeStamp = now.toFormattedString();
  }

  /// Retrieves transaction status and navigates to success or failure page based on response.
  Future<void> retrieveTransactionStatus() async {
    setState(() => isLoading = true);
    try {
      if (widget.txnInfo.txnInfoMap["isCancelledByUser"] == true) {
        _showTransactionAbortedDialog();
      } else {
        // Fetch transaction status
        var response =
            await ApiRequestHandler(traceId: traceId, timeStamp: timeStamp)
                .retrieveTransaction(widget.txnInfo.txnInfoMap["orderId"]);

        debugPrint("Encoded Response for Fetch Transaction :$response");

        if (response.statusCode == 200) {
          await _handleSuccessResponse(response.data);
        } else {
          _handleErrorResponse(response);
        }
      }
    } catch (e, stackTrace) {
      _handleException(e, stackTrace);
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Displays a dialog if the transaction was cancelled by the user.
  void _showTransactionAbortedDialog() {
    Get.defaultDialog(
      title: 'Transaction Aborted',
      middleText: 'Transaction was cancelled by the user.',
      confirm: ElevatedButton(
        onPressed: () => Get.offAll(const StartTxn()),
        child: const Text('Close'),
      ),
    );
  }

  /// Handles the success response and navigates to the appropriate screen.
  Future<void> _handleSuccessResponse(String encodedData) async {
    var decodedResponse = await JwtHelper().decode(encodedData);
    debugPrint("Decoded Response for Fetch Transaction :$decodedResponse");

    txnResponse = RetrieveTxnResponse.fromJson(decodedResponse);

    if (txnResponse.authStatus == "0300") {
      Get.to(PaymentSuccessWidget(
          txnInfo: widget.txnInfo, txnResponse: txnResponse));
    } else if (txnResponse.authStatus == "0399" ||
        txnResponse.authStatus == "0002") {
      Get.to(PaymentFailedWidget(
          txnInfo: widget.txnInfo, txnResponse: txnResponse));
    }
  }

  /// Handles API error response by displaying an error dialog.
  void _handleErrorResponse(dynamic response) {
    ErrorResponse error = ErrorResponse(
      status: response.statusCode,
      errorType: "Unknown Error",
      errorCode: response.hashCode.toString(),
      message: "Error Occurred",
      description: "An unexpected error occurred.",
    );

    debugPrint('Parsed Error: ${error.toJson()}');

    Get.defaultDialog(
      title: error.message ?? 'Error',
      middleText: error.description ??
          'An unexpected error occurred. Please try again.',
      barrierDismissible: false,
      confirm: ElevatedButton(
        onPressed: () => Get.to(const StartTxn()),
        child: const Text('Dismiss'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          retrieveTransactionStatus();
          Get.back(); // Close the dialog
        },
        child: const Text('Retry'),
      ),
    );
  }

  /// Handles exceptions and displays an error dialog.
  void _handleException(dynamic e, [StackTrace? stackTrace]) {
    debugPrint('Exception occurred: $e');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
    Get.defaultDialog(
      title: 'Error',
      middleText: 'An unexpected error occurred. \nPlease try again later.',
      confirm: ElevatedButton(
        onPressed: () => Get.to(const StartTxn()),
        child: const Text('Dismiss'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transaction"),
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
                    "Transaction Details",
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
                  widget.txnInfo.txnInfoMap["isCancelledByUser"] == true
                      ? const Text(
                          'Status: Cancelled by user',
                        )
                      : Padding(
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
                              onPressed:
                                  !isLoading ? retrieveTransactionStatus : null,
                              child: const Text(
                                "Check",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
