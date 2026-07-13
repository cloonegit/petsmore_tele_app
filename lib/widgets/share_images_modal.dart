import 'package:petsmore_tele_app/config/global.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/global_function/show_custom_dialog.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:petsmore_tele_app/widgets/custom_container.dart';
import 'package:petsmore_tele_app/widgets/global_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareImagesModal extends ConsumerStatefulWidget {
  final List imagesList;
  final String? text;

  ShareImagesModal({super.key, required this.imagesList, this.text});

  @override
  ConsumerState<ShareImagesModal> createState() => _ShareImagesModalState();
}

class _ShareImagesModalState extends ConsumerState<ShareImagesModal> {
  late PageController _pageController;
  int _currentPage = 0;
  String? contact;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getData();
  }

  getData() {
    final data = ref.read(callSummaryDetailProvider).infoData;
    if (data['CONTACT'].isNotEmpty) {
      contact = data['CONTACT'];
      AppDebug().printDebug(msg: 'contact:$contact');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
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
                  ),
                ),
              ],
            ),
            widget.imagesList.isNotEmpty
                ? Flexible(
                    child: Column(
                      children: [
                        SizedBox(
                          height: Adaptive.h(40),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.imagesList.length,
                            onPageChanged: _onPageChanged,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Image.network(
                                  widget.imagesList[index],
                                  width: Adaptive.w(100),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        // SizedBox(height: Adaptive.h(0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.imagesList.length,
                            (index) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Adaptive.h(2)),
                      ],
                    ),
                  )
                : _noImagesAvailable(),
            _buildShareToCustomerButton(),
            SizedBox(
                height: widget.imagesList.length > 1
                    ? Adaptive.h(2)
                    : Adaptive.h(4)),
            _buildShareAllButton(),
          ],
        ),
      ),
    );
  }

  Widget _noImagesAvailable() {
    return Container(
      margin: EdgeInsets.only(top: Adaptive.h(15)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Center(child: Image.asset('assets/icons/no_image.png')),
          const Center(child: Text('No image available for this campaign')),
        ],
      ),
    );
  }

  Widget _buildShareToCustomerButton() {
    String msg = Platform.isIOS 
        ? 'Confirm to send this visual?\n\nImage will be copied to clipboard. Paste it in WhatsApp.'
        : 'Confirm to send this visual?';
    return widget.imagesList.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
            child: CustomContainer(
              onPressed: () {
                showCustomDialog(
                    context, '', msg, 'OK', () {
                  _shareImage(widget.imagesList[_currentPage]);
                }, cancel: 'Cancel');
              },
              title: 'SHARE TO CUSTOMER',
              color: Colors.white,
              backgroundColor: AppColors.primary,
              width: Adaptive.w(90),
              borderRadius: BorderRadius.circular(5),
            ),
          )
        : Container();
  }

  Widget _buildShareAllButton() {
    String msg = Platform.isIOS 
        ? 'Confirm to send all visuals?\n\nImage will be copied to clipboard. Paste it in WhatsApp.'
        : 'Confirm to send all visuals?';
    return widget.imagesList.length > 1
        ? Padding(
            padding: EdgeInsets.only(bottom: Adaptive.h(20)),
            child: CustomContainer(
              onPressed: () {
                showCustomDialog(
                    context, '', msg, 'OK',
                    () async {
                  await _shareAllImages();
                }, cancel: 'Cancel');
              },
              title: 'SHARE ALL TO CUSTOMER',
              color: Colors.white,
              backgroundColor: AppColors.primary,
              width: Adaptive.w(90),
              borderRadius: BorderRadius.circular(5),
            ),
          )
        : SizedBox(
            height: Adaptive.h(26),
          );
  }

  Future<void> _shareImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Use application documents directory for better iOS share extension access
        final directory = await getApplicationDocumentsDirectory();
        // Use unique filename with timestamp to avoid caching issues
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final imagePath = '${directory.path}/shared_image_$timestamp.jpg';
        final imageFile = File(imagePath);

        // Write bytes and flush to ensure file is fully written
        await imageFile.writeAsBytes(response.bodyBytes, flush: true);

        // Longer delay to ensure iOS file system has fully registered the file
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Platform-specific sharing behavior
        if (Platform.isIOS) {
          // iOS: Copy image to clipboard and open WhatsApp directly via wa.me link
          final imageBytes = await imageFile.readAsBytes();
          await Clipboard.setData(ClipboardData(text: ''));
          // We need to use the platform channel to copy image to clipboard
          // For now, copy image bytes to clipboard using the system pasteboard
          await _copyImageToClipboard(imageBytes);

          // Clean contact number: remove +, -, spaces
          String cleanContact = (contact ?? '').replaceAll(RegExp(r'[+\-\s]'), '');
          
          // Build WhatsApp URL with phone and caption
          String encodedText = Uri.encodeComponent(widget.text ?? '');
          String whatsAppUrl = 'https://wa.me/$cleanContact?text=$encodedText';



          if (await canLaunchUrlString(whatsAppUrl)) {
            await launchUrlString(whatsAppUrl, mode: LaunchMode.externalApplication);
          }
        } else {
          // Android: Use share_whatsapp to directly open WhatsApp with contact
          final shareWhatsapp = ShareWhatsapp();
          
          // Check which WhatsApp is installed
          WhatsApp type = WhatsApp.standard;
          if (await shareWhatsapp.installed(type: WhatsApp.business)) {
            type = WhatsApp.business;
          }
          
          await shareWhatsapp.share(
            file: XFile(imageFile.path),
            phone: contact.toString(),
            text: widget.text,
            type: type,
          );
        }
        // String sendMsg = Uri.encodeComponent(imageFile.path);
        // String whatsAppUrl = 'https://wa.me/${contact}?text=${sendMsg}';
        // if (await canLaunchUrlString(whatsAppUrl)) {
        //   await launchUrlString(whatsAppUrl);
        // } else {
        //   print('WhatsApp not installed or cannot open URL.');
        // }
      } else {
        AppDebug().printDebug(
            msg: 'Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      AppDebug().printDebug(msg: 'Error downloading or sharing image: $e');
      if (mounted) {
        GlobalUtils.showFloatingMessage(
            context, 'Error downloading or sharing image: $e');
      }
    }
  }

  // Future<void> _shareAllImages() async {
  //   try {
  //     List<String> imageUrls = [];

  //     for (int i = 0; i < widget.imagesList.length; i++) {
  //       String imageUrl = widget.imagesList[i];
  //       imageUrls.add(imageUrl);
  //     }

  //     if (imageUrls.isNotEmpty) {
  //       String sendMsg = imageUrls.join('\n');
  //       String whatsAppUrl =
  //           'https://wa.me/$contact?text=${Uri.encodeComponent(sendMsg)}';

  //       if (await canLaunchUrlString(whatsAppUrl)) {
  //         await launchUrlString(whatsAppUrl);
  //       } else {
  //         print('WhatsApp not installed or cannot open URL.');
  //       }
  //     }
  //   } catch (e) {
  //     print('Error sharing images: $e');
  //   }
  // }

  Future<void> _shareAllImages() async {
    try {
      List<XFile> imageFiles = [];
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      for (int i = 0; i < widget.imagesList.length; i++) {
        String imageUrl = widget.imagesList[i];

        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          // Use application documents directory for better iOS share extension access
          final directory = await getApplicationDocumentsDirectory();
          // Use unique filename with timestamp to avoid caching issues
          final imagePath =
              '${directory.path}/shared_image_${timestamp}_$i.jpg';
          final imageFile = File(imagePath);
          // Write bytes and flush to ensure file is fully written
          await imageFile.writeAsBytes(response.bodyBytes, flush: true);

          imageFiles.add(XFile(imageFile.path, mimeType: 'image/jpeg'));
        }
      }

      if (imageFiles.isNotEmpty) {
        // Longer delay to ensure iOS file system has fully registered all files
        await Future.delayed(const Duration(milliseconds: 500));

        // Check if still mounted after async operations
        if (!mounted) return;
        final box = context.findRenderObject() as RenderBox?;
        
        // Platform-specific sharing behavior
        if (Platform.isIOS) {
          // iOS: Copy first/current image to clipboard and open WhatsApp directly
          final firstImageBytes = await File(imageFiles.first.path).readAsBytes();
          await _copyImageToClipboard(firstImageBytes);

          // Clean contact number: remove +, -, spaces
          String cleanContact = (contact ?? '').replaceAll(RegExp(r'[+\-\s]'), '');
          
          // Build WhatsApp URL with phone and caption
          String encodedText = Uri.encodeComponent(widget.text ?? '');
          String whatsAppUrl = 'https://wa.me/$cleanContact?text=$encodedText';



          if (await canLaunchUrlString(whatsAppUrl)) {
            await launchUrlString(whatsAppUrl, mode: LaunchMode.externalApplication);
          }
        } else {
          // Android: Use share_whatsapp to directly open WhatsApp with contact
          // Note: share_whatsapp only supports single file, so share first image
          final shareWhatsapp = ShareWhatsapp();
          
          // Check which WhatsApp is installed
          WhatsApp type = WhatsApp.standard;
          if (await shareWhatsapp.installed(type: WhatsApp.business)) {
            type = WhatsApp.business;
          }
          
          await shareWhatsapp.share(
            file: imageFiles.first,
            phone: contact.toString(),
            text: widget.text,
            type: type,
          );
        }
      }
    } catch (e) {
      AppDebug().printDebug(msg: 'Error downloading or sharing images: $e');
      if (mounted) {
        GlobalUtils.showFloatingMessage(
            context, 'Error downloading or sharing image: $e');
      }
    }
  }

  /// Copies image bytes to the iOS system pasteboard via a native MethodChannel.
  Future<void> _copyImageToClipboard(Uint8List imageBytes) async {
    const channel = MethodChannel('com.petsmore.tele/clipboard');
    try {
      await channel.invokeMethod('copyImageToClipboard', imageBytes);
    } catch (e) {
      AppDebug().printDebug(msg: 'Error copying image to clipboard: $e');
    }
  }
}
