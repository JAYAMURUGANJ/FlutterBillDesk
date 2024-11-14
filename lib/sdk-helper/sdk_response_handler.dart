// ignore_for_file: must_be_immutable

import 'package:billDeskSDK/sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/check_txn.dart';
import '../pages/start_txn.dart';
import '../sqlite-helper/db_helper.dart';
import '../sqlite-helper/model/order.dart';

//After Payment Completed getting the SDK returning object
class SDKResponseHandler implements ResponseHandler {
  @override
  void onError(SdkError sdkError) {
    debugPrint(sdkError.toString());
    Get.defaultDialog(
      title: 'SDK Internal Error',
      middleText: '$sdkError',
      confirm: ElevatedButton(
        onPressed: () => Get.to(const StartTxn()),
        child: const Text('Dismiss'),
      ),
    );
  }

  @override
  Future<void> onTransactionResponse(TxnInfo txnInfoMap) async {
    _insertOrder(txnInfoMap);
    debugPrint(txnInfoMap.toString());
    //if (txnInfoMap.txnInfoMap["isCancelledByUser"] == false) {
    Get.to(() => CheckTxnDetails(txnInfo: txnInfoMap));
    // }
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
