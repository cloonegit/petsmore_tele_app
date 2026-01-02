import 'package:nrs_tele_apps/config/global.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

showLoadingDialog(BuildContext context,
    {String? text, double? width, double? height}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: width ?? Adaptive.w(5),
          height: height ?? Adaptive.h(15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              if (text != null && text.isNotEmpty) ...[
                SizedBox(height: 16),
                Text(
                  text,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
