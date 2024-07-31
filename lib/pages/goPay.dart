// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '/sdk-helper/billdesk.dart';
import '/sdk-helper/model/error_response.dart';
import '/sdk-helper/model/order_response.dart';
import '/utils/extension.dart';
import '/utils/jwt/jwt_helper.dart';
import 'txn_history.dart';
import 'widget/progress_indicator.dart';

class GoPay extends StatefulWidget {
  const GoPay({super.key});

  @override
  State<GoPay> createState() => _GoPayState();
}

class _GoPayState extends State<GoPay> {
  late String traceId;
  late String orderId;
  late String timeStamp;
  late String orderDate;
  late bool isPayEnabled;
  final TextEditingController _amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    isPayEnabled = false;
  }

  void _formatAmount(String value) {
    // Remove commas and decimals from the value
    String newValue = value.replaceAll(',', '').replaceAll('.', '');
    if (newValue.isEmpty) {
      _amountController.value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }

    final int? parsedValue = int.tryParse(newValue);
    if (parsedValue != null) {
      final formatter =
          NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 0);
      final formattedValue = formatter.format(parsedValue);
      _amountController.value = TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      DateTime now = getCurrentTimestamp();
      traceId = ''.getOrderId(13);
      orderId = ''.getOrderId(13);
      timeStamp = now.toFormattedString();
      orderDate = now.formatISOTime();
    });
    return PopScope(
      canPop: isPayEnabled,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/img/billdesk_logo.png"),
          ),
          title: const Text("BillDesk Payment"),
          actions: [
            IconButton(
                onPressed: () => Get.to(const TxnHistory()),
                icon: const Icon(
                  Icons.history,
                  size: 30,
                ))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.storefront,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Paying to BillDesk",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    autofocus: true,
                    controller: _amountController,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      // Optional: customize hint text style
                      border: InputBorder.none,
                      alignLabelWithHint:
                          false, // This ensures the hint is centered
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 0), // Remove additional space
                    ),
                    onChanged: (value) {
                      setState(() {
                        _amountController.text != '0'
                            ? isPayEnabled = value.isNotEmpty
                            : null;
                        _formatAmount(value);
                      });
                    },
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              (!isPayEnabled &&
                      _amountController.text.isNotEmpty &&
                      _amountController.text != '0')
                  ? const CustomProgressIndicator()
                  : const SizedBox.shrink(),
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
                    onPressed: isPayEnabled ? processPayment : null,
                    child: Text(
                      "PAY \u20B9 ${_amountController.text}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  processPayment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      isPayEnabled = false;
    });
    //order creation
    var response = await BillDesk(
      traceId: traceId,
      timeStamp: timeStamp,
      orderDate: orderDate,
      orderId: orderId,
      amount: _amountController.text,
    ).orderCreation();
    debugPrint("Encoded Response for order creation :$response");
    _amountController.clear();
    //sdk launcher
    if (response.statusCode == 200) {
      //if order creation was successful
      var decodedResponse = await JwtHelper().decode(response.data);
      debugPrint("Decoded Response for order creation :$decodedResponse");
      BDOrderResponse createOrderRes =
          BDOrderResponse.fromJson(decodedResponse);
      BillDesk().launcherSDK(createOrderRes);
      setState(() {
        isPayEnabled = false;
      });
    } else {
      //if order creation is not possible
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
  }
}
