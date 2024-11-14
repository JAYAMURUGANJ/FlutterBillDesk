import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/utils/extension.dart';

import '/sdk-helper/model/order_response.dart';
import '/sdk-helper/model/retrieve_txn_request.dart';
import '/utils/jwt/jwt_helper.dart';
import '../utils/constant.dart';
import 'model/order_request.dart';

class ApiRequestHandler {
  String? traceId;
  String? timeStamp;
  String? orderDate;
  String? orderId;
  String? amount;
  ApiRequestHandler({
    this.traceId,
    this.timeStamp,
    this.orderDate,
    this.orderId,
    this.amount,
  });
  JwtHelper jwtHelper = JwtHelper();
  Dio dio = Dio();
  //Order Creation
  Future<Response> orderCreation() async {
    try {
      String total = amount!.formatAsCurrency();
      AdditionalInfo additionalInfo = AdditionalInfo(
        additionalInfo1: "reference1",
        additionalInfo2: "reference2",
        additionalInfo3: "reference3",
      );
      Customer customerInfo = Customer(
        firsName: "Jayamurugan",
        lastName: "Jayakumar",
        email: "jamu0303@gmail.com",
        mobile: "958686862",
      );
      Device deviceInfo = Device(
        initChannel: "internet",
        ip: "10.163.2.67",
        userAgent:
            "Mozilla/5.0(WindowsNT10.0;WOW64;rv:51.0)Gecko/20100101Firefox/51.0",
        acceptHeader: "text/html",
      );
      OrderRequest payload = OrderRequest(
        mercid: mercid,
        orderid: orderId,
        orderDate: orderDate,
        amount: total,
        currency: "356",
        ru: returnUrl,
        itemcode: "DIRECT",
        additionalInfo: additionalInfo,
        customer: customerInfo,
        device: deviceInfo,
      );
      debugPrint("OrderRequestPayload: ${payload.toJson()}");
      String body =
          await JwtHelper().encode(jwtHeader.toString(), json.encode(payload));
      debugPrint("Encoded-OrderRequestPayload: $body");
      Map<String, String?> headers = {
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
    } catch (e) {
      // Handle and log errors
      debugPrint("Error during order creation: $e");
      rethrow;
    }
  }

  Future<Response> retrieveTransaction(String orderId) async {
    try {
      RetrieveTxnRequest payload =
          RetrieveTxnRequest(mercid: mercid, orderid: orderId);
      debugPrint("TxnDetailsPayload: ${payload.toJson()}");
      String body =
          await jwtHelper.encode(jwtHeader.toString(), json.encode(payload));
      debugPrint("Encoded-TxnDetailsPayload: $body");
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
      debugPrint("Transaction response: $response");
      return response;
    } catch (e) {
      // Handle and log errors
      debugPrint("Error during getting Transaction response: $e");
      rethrow;
    }
  }
}
