import 'dart:convert';

import 'package:billDeskSDK/sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '/pages/payment_status.dart';
import '/sdk-helper/model/order_response.dart';
import '/sdk-helper/model/retrieve_txn_request.dart';
import '/utils/jwt/jwt_helper.dart';
import 'model/order_request.dart';

class BillDesk {
  String? traceId;
  String? timeStamp;
  String? orderDate;
  String? orderId;
  String? amount;
  BillDesk({
    this.traceId,
    this.timeStamp,
    this.orderDate,
    this.orderId,
    this.amount,
  });
  JwtHelper jwtHelper = JwtHelper();
  Dio dio = Dio();

  Future<Response> orderCreation() async {
    OrderRequest payload = OrderRequest(
      mercid: mercid,
      orderid: orderId,
      orderDate: orderDate,
      amount: amount!.replaceAll(RegExp(r'[^\w\s]+'), ''),
      currency: "356",
      ru: "https://www.billdesk.com/web/",
      itemcode: "DIRECT",
      additionalInfo: AdditionalInfo(
        additionalInfo1: "reference_no_1",
        additionalInfo2: "reference_no_2",
        additionalInfo3: "reference_no_3",
      ),
      customer: Customer(
        firsName: "Jayamurugan",
        lastName: "Jayakumar",
        email: "jamu0303@gmail.com",
        mobile: "958686862",
      ),
      device: Device(
        initChannel: "internet",
        ip: "10.163.2.67",
        userAgent:
            "Mozilla/5.0(WindowsNT10.0;WOW64;rv:51.0)Gecko/20100101Firefox/51.0",
        acceptHeader: "text/html",
      ),
    );
    debugPrint("Payload: ${payload.toJson()}");
    var body =
        await JwtHelper().encode(jwtHeader.toString(), json.encode(payload));
    debugPrint("Encoded-payload: $body");
    var headers = {
      'Content-Type': 'application/jose',
      'Accept': 'application/jose',
      'BD-Traceid': traceId,
      'BD-Timestamp': timeStamp
    };
    //Create order request
    Response response = await dio.request(
      orderCreationtUrl,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: body,
    );
    return response;
  }

  launcherSDK(BDOrderResponse createOrderRes) {
    final flowConfig = {
      "merchantId": createOrderRes.mercid,
      "bdOrderId": createOrderRes.bdorderid,
      "authToken": createOrderRes.links![1].headers!.authorization.toString(),
      "childWindow": true,
      "retryCount": 2,
    };
    debugPrint("Flow-Config: $flowConfig");

    ResponseHandler responseHandler = const PaymentStatus();

    final Map<String, dynamic> sdkConfigMap = {
      "flowConfig": flowConfig,
      "flowType": "payments",
      "merchantLogo": imageCode,
    };

    final sdkConfig = SdkConfig(
      sdkConfigJson: SdkConfiguration.fromJson(sdkConfigMap),
      responseHandler: responseHandler,
      isUATEnv: true,
      isDevModeAllowed: true,
      isJailBreakAllowed: true,
    );
    SDKWebView.openSDKWebView(sdkConfig);
  }

  Future<Response> retrieveTransaction(String orderId) async {
    RetrieveTxnRequest payload =
        RetrieveTxnRequest(mercid: mercid, orderid: orderId);
    debugPrint("Payload: ${payload.toJson()}");
    String body =
        await jwtHelper.encode(jwtHeader.toString(), json.encode(payload));
    debugPrint("Encoded-payload: $body");
    var headers = {
      'Content-Type': 'application/jose',
      'Accept': 'application/jose',
      'BD-Traceid': traceId,
      'BD-Timestamp': timeStamp
    };
    //Create order request
    Response response = await dio.request(
      retrieveTransactionUrl,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: body,
    );
    debugPrint(response.toString());
    return response;
  }
}
//SdkError(msg: An unexpected exception occurred., description: LateInitializationError: Field 'customerRefId' has not been initialized., SDK_ERROR: 1, code: null)