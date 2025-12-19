import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget widthSeperator(double h) {
    return SizedBox(
      width: h,
    );
  }

  Widget heightSeperator(double h) {
    return SizedBox(
      height: h,
    );
  }

  Widget widthSeperator2(BuildContext context, double h) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * h,
    );
  }
}
