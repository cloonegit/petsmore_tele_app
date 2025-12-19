import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/global_function/show_custom_dialog.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/widgets/custom_container.dart';
import 'package:nrs_tele_apps/widgets/global_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareImagesModal extends ConsumerStatefulWidget {
  final List imagesList;

  ShareImagesModal({super.key, required this.imagesList});

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
                                    ? Color(0xFFED1C24)
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
    return widget.imagesList.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
            child: CustomContainer(
              onPressed: () {
                showCustomDialog(
                    context, '', 'Confirm to send this visual?', 'OK', () {
                  _shareImage(widget.imagesList[_currentPage]);
                }, cancel: 'Cancel');
              },
              title: 'SHARE TO CUSTOMER',
              color: Colors.white,
              backgroundColor: Color(0xFFED1C24),
              width: Adaptive.w(90),
              borderRadius: BorderRadius.circular(5),
            ),
          )
        : Container();
  }

  Widget _buildShareAllButton() {
    return widget.imagesList.length > 1
        ? Padding(
            padding: EdgeInsets.only(bottom: Adaptive.h(20)),
            child: CustomContainer(
              onPressed: () {
                showCustomDialog(
                    context, '', 'Confirm to send all visuals?', 'OK',
                    () async {
                  await _shareAllImages();
                }, cancel: 'Cancel');
              },
              title: 'SHARE ALL TO CUSTOMER',
              color: Colors.white,
              backgroundColor: Color(0xFFED1C24),
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
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/shared_image.jpg';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(response.bodyBytes);

        await shareWhatsapp.shareFile(XFile(imageFile.path),
            phone: contact.toString());
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
      GlobalUtils.showFloatingMessage(
          context, 'Error downloading or sharing image: $e');
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

      for (int i = 0; i < widget.imagesList.length; i++) {
        String imageUrl = widget.imagesList[i];

        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/shared_image_$i.jpg';
          final imageFile = File(imagePath);
          await imageFile.writeAsBytes(response.bodyBytes);

          imageFiles.add(XFile(imageFile.path));
        }
      }

      if (imageFiles.isNotEmpty) {
        await Share.shareXFiles(imageFiles);
      }
    } catch (e) {
      AppDebug().printDebug(msg: 'Error downloading or sharing images: $e');
      GlobalUtils.showFloatingMessage(
          context, 'Error downloading or sharing image: $e');
    }
  }
}
