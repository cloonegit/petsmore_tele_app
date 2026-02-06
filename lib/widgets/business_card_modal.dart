import 'package:petsmore_tele_app/config/global.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/global_function/show_custom_dialog.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:petsmore_tele_app/services/get_it.dart';
import 'package:petsmore_tele_app/widgets/custom_container.dart';
import 'package:petsmore_tele_app/widgets/global_utils.dart';
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
    // Use watch instead of read to ensure reactivity
    final callSummaryDetail = ref.watch(callSummaryDetailProvider);
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
    AppDebug().printDebug(msg: 'Starting _shareBusinessCard, url: $businessCard');
    if (businessCard.isNotEmpty) {
      if (mounted) {
        GlobalUtils.showFloatingMessage(context, 'Preparing business card...');
      }
      try {
        if (mounted) {
          GlobalUtils.showFloatingMessage(context, 'Downloading business card...');
        }
        AppDebug().printDebug(msg: 'Downloading business card from: $businessCard');
        final response = await http.get(Uri.parse(businessCard)).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          if (mounted) {
            GlobalUtils.showFloatingMessage(context, 'Image downloaded, preparing to share...');
          }
          AppDebug().printDebug(msg: 'Download successful, saving to file...');
          // Use application documents directory for better iOS share extension access
          final directory = await getApplicationDocumentsDirectory();
          // Use unique filename with timestamp to avoid caching issues
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final imagePath = '${directory.path}/business_card_$timestamp.jpg';

          final imageFile = File(imagePath);
          // Write bytes and flush to ensure file is fully written
          await imageFile.writeAsBytes(response.bodyBytes, flush: true);

          AppDebug().printDebug(msg: 'File saved at: $imagePath. Waiting 500ms...');
          // Longer delay to ensure iOS file system has fully registered the file
          await Future.delayed(const Duration(milliseconds: 500));

          // Check if still mounted after async operations
          if (!mounted) {
            AppDebug().printDebug(msg: 'Widget unmounted after delay, aborting.');
            return;
          }

          final box = context.findRenderObject() as RenderBox?;
          
          // Platform-specific sharing behavior
          const caption = 'Petsmore Business Card';
          if (Platform.isIOS) {
            AppDebug().printDebug(msg: 'Sharing on iOS...');
            // iOS WhatsApp workaround: Copy caption to clipboard
            // WhatsApp on iOS has a known bug where image+text causes blank preview
            await Clipboard.setData(const ClipboardData(text: caption));
            if (mounted) {
              GlobalUtils.showFloatingMessage(
                  context, 'Caption copied to clipboard. Paste in WhatsApp.');
            }
            // Share image WITHOUT text parameter to fix iOS WhatsApp blank preview
            await Share.shareXFiles(
              [XFile(imageFile.path, mimeType: 'image/jpeg')],
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
            );
          } else {
            AppDebug().printDebug(msg: 'Sharing on Android to contact: ${widget.contact}');
            // Android: Use share_whatsapp to directly open WhatsApp with contact
            final shareWhatsapp = ShareWhatsapp();
            AppDebug().printDebug(msg: 'Calling shareWhatsapp.share with phone: ${widget.contact}');
            await shareWhatsapp.share(
              file: XFile(imageFile.path),
              phone: widget.contact.toString(),
              text: caption,
            );
            AppDebug().printDebug(msg: 'Share call completed successfully.');
            if (mounted) {
              GlobalUtils.showFloatingMessage(context, 'Opening WhatsApp...');
            }
          }
        } else {
          AppDebug().printDebug(
              msg: 'Failed to download image: ${response.statusCode}');
        }
      } catch (e) {
        AppDebug()
            .printDebug(msg: 'Error downloading or sharing the image: $e');

        if (mounted) {
          GlobalUtils.showFloatingMessage(context, e.toString());
        }
      }
    } else {
      AppDebug().printDebug(msg: 'No business card to share');
    }
  }
}
