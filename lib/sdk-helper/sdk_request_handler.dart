import 'package:billDeskSDK/sdk.dart';
import 'package:flutter/foundation.dart';

import '../utils/constant.dart';
import 'model/order_response.dart';
import 'sdk_response_handler.dart';

class SDKRequestHandler {
  launcherSDK(BDOrderResponse createOrderRes) {
    final Map<String, Object?> flowConfig = {
      "merchantId": createOrderRes.mercid,
      "bdOrderId": createOrderRes.bdorderid,
      "authToken": createOrderRes.links![1].headers!.authorization.toString(),
      "childWindow": false,
    };
    debugPrint("Flow-Config: $flowConfig");

    ResponseHandler responseHandler = SDKResponseHandler();

    final Map<String, dynamic> sdkConfigMap = {
      "flowConfig": flowConfig,
      "flowType": "payments",
      "merchantLogo": imageCode,
    };

    final SdkConfig sdkConfig = SdkConfig(
      sdkConfigJson: SdkConfiguration.fromJson(sdkConfigMap),
      responseHandler: responseHandler,
      isUATEnv: true,
      isDevModeAllowed: true,
      isJailBreakAllowed: true,
    );
    SDKWebView.openSDKWebView(sdkConfig);
  }
}
