import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              child: Icon(
                Icons.currency_rupee,
                size: 35,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
