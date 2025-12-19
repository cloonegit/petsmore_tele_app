import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextStyleGlobal {
  TextStyle btnText = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white);
  TextStyle btnText2 = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13);
  TextStyle btnTextRed = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: Color(0xFFE12D2E),
  );
  TextStyle btnTextWeb = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white);
  TextStyle btnText2Web = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);
  TextStyle btnTextRedWeb = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: Color(0xFFE12D2E),
  );
  TextStyle cResponsive(context, fontSize, color, fontWeight, fontStyle) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          fontSize: Adaptive.sp(fontSize + 3));
  TextStyle cResponsive3(context, fontSize, color, fontWeight, fontStyle) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          fontSize: Adaptive.sp(fontSize + 3.5));
  TextStyle cResponsive4(context, fontSize, color, fontWeight, fontStyle) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          fontSize: Adaptive.h((fontSize * 0.1) + 0.3));
  TextStyle cResponsive5(context, fontSize, color, fontWeight, fontStyle) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          fontSize: Adaptive.px((fontSize * 0.1) + 0.3));
  TextStyle cResponsive6(context, fontSize, color, fontWeight, fontStyle) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          fontSize: 11.dp);

  TextStyle dialogMainText = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17);
  TextStyle dialogMainText1 = const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15);
  TextStyle dialogMainText2 = const TextStyle(color: Colors.blue, fontSize: 17);
  TextStyle dialogMainText3 =
      const TextStyle(color: Colors.black, fontSize: 17);
  TextStyle dialogSubsText = const TextStyle(color: Colors.black, fontSize: 15);

  TextStyle searchFontSize12Grey =
      const TextStyle(fontSize: 12.0, color: Colors.grey);
  TextStyle searchFontSize12 =
      const TextStyle(fontSize: 12.0, color: Colors.black);
  TextStyle searchFontSize14Grey =
      const TextStyle(fontSize: 14.0, color: Colors.grey);

  TextStyle form1FontSize = const TextStyle(fontSize: 12.0);
  TextStyle form1FontSize1 =
      const TextStyle(fontSize: 12.0, color: Colors.black);
  TextStyle form1FontSize2 = const TextStyle(
      fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle f12FWBold =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
  TextStyle f15CGrey = const TextStyle(fontSize: 15, color: Colors.grey);
  TextStyle form13FontSize =
      const TextStyle(fontSize: 13.0, color: Colors.black);
}
