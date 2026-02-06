import 'package:petsmore_tele_app/config/global.dart';
import 'package:flutter/material.dart';
import 'package:petsmore_tele_app/services/get_it.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showCustomDialog(
  BuildContext context,
  String title,
  String content,
  String OK,
  VoidCallback onOK, {
  double? width,
  double? height,
  String? cancel,
  VoidCallback? onCancel,
}) {
  final openDialogService = getIt<OpenDialogService>();

  if (!openDialogService.isOpen) {
    // Set the dialog flag to open
    openDialogService.setIsOpen(true);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 16, right: 0, left: 0, bottom: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Adaptive.h(1), horizontal: Adaptive.w(3)),
                        child: Text(
                          content,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    if (cancel != null && cancel.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
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
                                    Navigator.of(context).pop();
                                    openDialogService
                                        .setIsOpen(false); // Close dialog
                                    if (onCancel != null) {
                                      onCancel();
                                    }
                                  },
                                  child: Text(cancel),
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
                                  Navigator.of(context).pop();
                                  openDialogService
                                      .setIsOpen(false); // Close dialog
                                  onOK();
                                },
                                child: Text(OK),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (cancel == null || cancel.isEmpty)
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  surfaceTintColor: Colors.transparent,
                                  overlayColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  openDialogService
                                      .setIsOpen(false); // Close dialog
                                  onOK();
                                },
                                child: Text(OK),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).then((_) {
      openDialogService.setIsOpen(false);
    });
  }
}








// void showCustomDialog(
//   BuildContext context,
//   String title,
//   String content,
//   String OK,
//   VoidCallback onOK, {
//   double? width,
//   double? height,
//   String? cancel,
//   VoidCallback? onCancel,
// }) {

  
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         child: StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(15)),
//               width: double.maxFinite,
//               padding: EdgeInsets.only(top: 16, right: 0, left: 0, bottom: 0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Flexible(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: Adaptive.h(1), horizontal: Adaptive.w(3)),
//                       child: Text(
//                         content,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   if (cancel != null && cancel.isNotEmpty)
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border(
//                           top: BorderSide(
//                             color: Colors.grey.shade300,
//                             width: 1,
//                           ),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border(
//                                   right: BorderSide(
//                                     color: Colors.grey.shade300,
//                                     width: 1,
//                                   ),
//                                 ),
//                               ),
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   padding: EdgeInsets.symmetric(vertical: 16),
//                                   backgroundColor: Colors.white,
//                                   foregroundColor: AppColors.primary,
//                                   elevation: 0,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();

//                                   if (onCancel != null) {
//                                     onCancel();
//                                   }
//                                 },
//                                 child: Text(cancel),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(vertical: 16),
//                                 backgroundColor: Colors.white,
//                                 foregroundColor: AppColors.primary,
//                                 elevation: 0,
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();

//                                 onOK();
//                               },
//                               child: Text(OK),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   if (cancel == null || cancel.isEmpty)
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border(
//                           top: BorderSide(
//                             color: Colors.grey.shade300,
//                             width: 1,
//                           ),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(vertical: 0),
//                                 backgroundColor: Colors.white,
//                                 foregroundColor: AppColors.primary,
//                                 elevation: 0,
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();

//                                 onOK();
//                               },
//                               child: Text(OK),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//       );
//     },
//   );
// }
