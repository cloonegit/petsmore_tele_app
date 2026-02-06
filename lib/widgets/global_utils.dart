import 'package:petsmore_tele_app/config/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petsmore_tele_app/global_function/show_custom_dialog.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GlobalUtils {
  static Future<String?> TickListDialogSmall(
    BuildContext context,
    List items,
    String? title,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String tempSelectedValue = '';
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  // borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(15),
                  //     topRight: Radius.circular(15))
                ),
                // height: Adaptive.h(90),
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  top: Adaptive.h(1),
                  right: 0,
                  left: 0,
                  bottom: 0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title ?? '',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                    Flexible(
                      child: SingleChildScrollView(
                          child: Column(children: [
                        for (var i = 0; i < items.length; i++)
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: i == 0
                                    ? BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      )
                                    : BorderSide.none,
                                bottom: i == items.length - 1
                                    ? BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      )
                                    : BorderSide.none,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: Adaptive.w(4), right: Adaptive.w(4)),
                              title: Text(
                                items[i],
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: tempSelectedValue == i.toString()
                                        ? AppColors.primary
                                        : Colors.black),
                              ),
                              trailing: tempSelectedValue == i.toString()
                                  ? Icon(Icons.check, color: AppColors.primary)
                                  : null,
                              onTap: () {
                                setState(() {
                                  tempSelectedValue = i.toString();
                                });
                              },
                            ),
                          ),
                      ])),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                surfaceTintColor: Colors.transparent,
                                overlayColor: Colors.transparent,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(null);
                              },
                              child: const Text('DISMISS'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                            ),
                            onPressed: () {
                              if (tempSelectedValue == "" ||
                                  tempSelectedValue.isEmpty) {
                                showFloatingMessage(
                                    context, "Please select an option.");
                              } else {
                                Navigator.of(context).pop(tempSelectedValue);
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  static void showFloatingMessage(BuildContext context, String message) {
    OverlayState overlayState = Overlay.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    double topPosition =
        viewInsetsBottom > 0 ? screenHeight * 0.35 : screenHeight * 0.4;
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: topPosition,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle(
                  fontFamily: 'Poppins', color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  getToastMsg() {
    return Fluttertoast.showToast(
      msg: "Press back again to exit!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  static void showLoadingIndicator(BuildContext context, String message) {
    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator.adaptive(
                strokeWidth: 5,
                strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  static void hideLoadingIndicator(BuildContext context) {
    Navigator.of(context).pop();
  }
}
