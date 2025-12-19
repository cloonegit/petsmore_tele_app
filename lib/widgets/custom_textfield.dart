import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTextfield extends StatefulWidget {
  TextEditingController controller;
  final String? hintText;
  final String? labelText;
  bool? obscureText;
  final TextInputType? keyboardType;
  final Icon? suffixIcon;
  EdgeInsets? padding;
  EdgeInsets? contentPadding;
  final String? errorMessage;
  bool? enabled;
  FloatingLabelBehavior? floatingLabelBehavior;
  FocusNode? focusNode;
  final double? height;
  final double? width;
  final String? Function(String?)? validator;

  CustomTextfield(
      {super.key,
      required this.controller,
      this.hintText,
      this.labelText,
      this.obscureText = true,
      this.keyboardType,
      this.suffixIcon,
      this.padding,
      this.contentPadding,
      this.errorMessage,
      this.enabled,
      this.floatingLabelBehavior,
      this.focusNode,
      this.height,
      this.width,
      this.validator});

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield>
    with SingleTickerProviderStateMixin {
  bool _obscureImg = true;
  String? errorMessage;
  // late AnimationController _controller;
  // late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for shaking effect
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 300),
    // );
    // _shakeAnimation = Tween<double>(begin: 0, end: 10)
    //     .chain(CurveTween(curve: Curves.elasticIn))
    //     .animate(_controller)
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       _controller.reset();
    //     }
    //   });
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  // void _triggerShake() {
  //   if (mounted) {
  //     _controller.forward().whenComplete(() {
  //       if (mounted) {
  //         _controller.reset();
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 45.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AnimatedBuilder(
          //   animation: _shakeAnimation,
          //   builder: (context, child) {
          //     return Transform.translate(
          //       offset: Offset(_shakeAnimation.value - 5, 0),
          //       child: child,
          //     );
          //   },
          // child:
          SizedBox(
            height: errorMessage != null
                ? widget.height ?? Adaptive.h(10)
                : widget.height ?? Adaptive.h(8),
            width: widget.width ?? Adaptive.w(90),
            child: TextFormField(
              enableInteractiveSelection: false,
              cursorColor: Color(0xFFED1C24),
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText ?? false,
              style: const TextStyle(
                  letterSpacing: 0.8,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1),
              decoration: InputDecoration(
                // errorText:ErrorHint(widget.errorMessage),
                floatingLabelBehavior: widget.floatingLabelBehavior,
                suffixIcon: widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureImg = !_obscureImg;
                            widget.obscureText = _obscureImg;
                          });
                        },
                        child: Icon(
                          _obscureImg
                              ? Icons.visibility_off
                              : Icons
                                  .visibility, // Show visibility_off when obscured, visibility when not
                          size: 24.0, // Set icon size
                        ),
                      )
                    : null,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                errorMaxLines: 6,
                errorStyle: TextStyle(fontSize: 12.0, color: Color(0xFFED1C24)),
                floatingLabelStyle: errorMessage != null
                    ? const TextStyle(
                        color: Color(0xFFED1C24),
                        fontSize: 16.0,
                      )
                    : TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14.0,
                      ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFED1C24),
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFED1C24),
                    width: 1.0,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey[500],
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                labelText: widget.labelText ?? '',
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey[500],
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: widget.contentPadding ??
                    EdgeInsets.symmetric(
                      vertical: Adaptive.h(0),
                      horizontal: Adaptive.w(4),
                    ),
              ),
              validator: (value) {
                final validationResult = widget.validator!(value);
                if (mounted) {
                  setState(() {
                    errorMessage = validationResult;
                    if (validationResult != null) {
                      // _triggerShake();
                    }
                  });
                }
                return validationResult;
              },
            ),
          ),
          // ),
          if (widget.errorMessage != null)
            Padding(
              padding:
                  EdgeInsets.only(top: Adaptive.h(0), bottom: Adaptive.h(0.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.errorMessage ?? '',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFED1C24),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
