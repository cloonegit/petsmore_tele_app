import 'package:nrs_tele_apps/config/global.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/services/get_it.dart';
import 'package:nrs_tele_apps/widgets/custom_container.dart';
import 'package:nrs_tele_apps/widgets/global_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BusinessCardModal extends ConsumerStatefulWidget {
  String? contact;
  BusinessCardModal({super.key, this.contact});

  @override
  ConsumerState<BusinessCardModal> createState() => _BusinessCardModalState();
}

class _BusinessCardModalState extends ConsumerState<BusinessCardModal> {
  String businessCard = '';
  final errorMessageService = GetIt.instance<ErrorMessageService>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final callSummaryDetail = ref.read(callSummaryDetailProvider);
    businessCard = callSummaryDetail.getBusinessCard;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: Adaptive.h(55),
        // width: Adaptive.w(80),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                    )),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Adaptive.w(0), vertical: Adaptive.h(3)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (businessCard != '' && businessCard.isNotEmpty)
                    IntrinsicWidth(
                      child: Center(
                        child: Image.network(
                          businessCard,
                          width: Adaptive.w(80),
                          height: Adaptive.h(22),
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  else
                    Container(
                        width: Adaptive.w(70),
                        height: Adaptive.h(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: Center(
                            child: const Text(
                          'No business card available',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ))),
                ],
              ),
            ),
            if (businessCard != '' && businessCard.isNotEmpty)
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Adaptive.w(5), vertical: Adaptive.h(0)),
                  child: CustomContainer(
                    onPressed: () {
                      showCustomDialog(
                        context,
                        '',
                        'Confirm to send this visual?',
                        'OK',
                        () {
                          Navigator.pop(context);
                          _shareBusinessCard();
                        },
                        cancel: 'Cancel',
                      );
                    },
                    title: 'SHARE TO CUSTOMER',
                    color: Colors.white,
                    backgroundColor: AppColors.primary,
                    width: Adaptive.w(70),
                    borderRadius: BorderRadius.circular(5),
                  )),
          ],
        ),
      ),
    );
  }

  Future<void> _shareBusinessCard() async {
    if (businessCard.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(businessCard));

        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/business_card.jpg';

          final imageFile = File(imagePath);
          await imageFile.writeAsBytes(response.bodyBytes);

          await shareWhatsapp.shareFile(
            XFile(imageFile.path),
            phone: widget.contact.toString(),
          );
        } else {
          AppDebug().printDebug(
              msg: 'Failed to download image: ${response.statusCode}');
        }
      } catch (e) {
        AppDebug()
            .printDebug(msg: 'Error downloading or sharing the image: $e');

        GlobalUtils.showFloatingMessage(context, e.toString());
      }
    } else {
      AppDebug().printDebug(msg: 'No business card to share');
    }
  }
}
