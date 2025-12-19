import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomContainer extends StatefulWidget {
  final VoidCallback onPressed;
  final String? title;
  final double? titleSize;
  final double? width;
  final double? height;
  Color? backgroundColor;
  Color? color;
  final Function(String)? onSubmit;
  BorderRadius? borderRadius;
  Color? borderSide;
  FontWeight? fontWeight;
  bool? isSave;

  CustomContainer({
    super.key,
    required this.onPressed,
    required this.title,
    this.titleSize,
    this.width,
    this.height,
    this.backgroundColor,
    this.color,
    this.onSubmit,
    this.borderRadius,
    this.borderSide,
    this.fontWeight,
    this.isSave,
  });

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? Adaptive.w(44),
      height: widget.height ?? Adaptive.h(6),
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            overlayColor: Colors.transparent,
            side: BorderSide(color: widget.borderSide ?? Color(0xFFED1C24)),
            backgroundColor: widget.backgroundColor ?? Color(0xFF019949),
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(3),
            ),
          ),
          child: widget.isSave == true
              ? Center(
                  heightFactor: Adaptive.h(1),
                  child: Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 5,
                      strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFED1C24)),
                    ),
                  ),
                )
              : Text(
                  widget.title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.color ?? Colors.black,
                    fontSize: widget.titleSize ?? 16,
                    fontFamily: 'Poppins',
                    fontWeight: widget.fontWeight ?? FontWeight.w700,
                  ),
                  overflow: TextOverflow
                      .visible, // or TextOverflow.fade or TextOverflow.visible
                )),
    );
  }
}
