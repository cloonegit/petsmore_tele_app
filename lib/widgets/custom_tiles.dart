import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTiles extends StatefulWidget {
  final VoidCallback onPressed;
  final String? title;
  final String? subtitle;
  final String? title2;
  final String? subtitle2;
  final double? borderWidth;
  final double? width;
  final double? height;
  Color? backgroundColor;
  Color? color;
  Color? borderColor;
  final Function(String)? onSubmit;
  BorderRadius? borderRadius;

  CustomTiles({
    super.key,
    required this.onPressed,
    this.title,
    this.subtitle,
    this.title2,
    this.subtitle2,
    this.borderWidth,
    this.width,
    this.height,
    this.backgroundColor,
    this.color,
    this.borderColor,
    this.onSubmit,
    this.borderRadius,
  });

  @override
  State<CustomTiles> createState() => _CustomTilesState();
}

class _CustomTilesState extends State<CustomTiles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? Adaptive.w(44),
      height: widget.height ?? Adaptive.h(20),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.transparent,
          overlayColor: Colors.transparent,
          backgroundColor:
              widget.backgroundColor ?? Color.fromARGB(255, 251, 228, 232),
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
            side: BorderSide(
              color: widget.borderColor ?? Color(0xFFEA1C24),
              width: widget.borderWidth ?? 1.0,
            ),
          ),
        ),
        child: widget.title != null && widget.subtitle != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title ?? "",
                    style: TextStyle(
                      color: widget.color ?? Colors.black,
                      fontSize: 50,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow
                        .visible, // or TextOverflow.fade or TextOverflow.visible
                  ),
                  Text(
                    widget.subtitle ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.color ?? Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    // color: Colors.amber,
                    width: Adaptive.w(16),
                    alignment: Alignment.center,
                    child: Text(
                      widget.title2 ?? "100",
                      style: TextStyle(
                        color: widget.color ?? Colors.black,
                        fontSize: 28,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow
                          .visible, // or TextOverflow.fade or TextOverflow.visible
                    ),
                  ),
                  SizedBox(width: Adaptive.w(3)),
                  Expanded(
                    child: Text(
                      widget.subtitle2 ?? "",
                      style: TextStyle(
                        color: widget.color ?? Colors.black,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow
                          .ellipsis, // or TextOverflow.fade or TextOverflow.visible
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
