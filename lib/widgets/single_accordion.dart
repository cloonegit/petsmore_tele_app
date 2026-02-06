import 'package:petsmore_tele_app/config/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:petsmore_tele_app/services/debouncer.dart';
import 'package:petsmore_tele_app/widgets/download_modal.dart';
import 'package:petsmore_tele_app/widgets/share_images_modal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SingleAccordion extends ConsumerStatefulWidget {
  List callInfo2 = [];
  String cid;

  SingleAccordion({
    super.key,
    required this.callInfo2,
    required this.cid,
  });

  @override
  _SingleAccordionState createState() => _SingleAccordionState();
}

class _SingleAccordionState extends ConsumerState<SingleAccordion> {
  final Debouncer _debouncer = Debouncer(milliseconds: 300);
  List<bool> isExpandedList = [];
  List imagesList = [];
  List<String> allImages = [];
  List videoList = [
    // {
    //   'id': 1,
    //   'video_name': 'youtube',
    //   'campaign_id': ['229', '747'],
    //   'video_path':
    //       'https://sys.senheng.com.my/shmanagement/uploads/telemarketing/audios/e007c5a3af8a9f5e25b845d1ab1f3d75.mp3',
    //   'created_at': '2022-02-24 16:27:30',
    //   'updated_at': '2022-09-09 17:25:42',
    //   'active': 1,
    // },
  ];
  List audioList = [
    // {
    //   'id': 1,
    //   'audio_name': 'DO NOT SHARE TO CUSTOMER',
    //   'campaign_id': ['229', '52'],
    //   'audio_path':
    //       'https://sys.senheng.com.my/shmanagement/uploads/telemarketing/audios/e007c5a3af8a9f5e25b845d1ab1f3d75.mp3',
    //   'created_at': '2022-02-24 16:27:30',
    //   'updated_at': '2022-09-09 17:25:42',
    //   'active': 1,
    // },
    // {
    //   'id': 2,
    //   'audio_name': 'Customer Information',
    //   'campaign_id': ['300', '52'],
    //   'audio_path':
    //       "https:\/\/sys.senheng.com.my\/shmanagement\/uploads\/telemarketing\/videos\/9a09f36c1f210cbb0fbd6bd352821605.mp4",
    //   'created_at': '2022-03-01 14:20:00',
    //   'updated_at': '2022-09-10 15:00:00',
    //   'active': 1,
    // },
    // {
    //   'id': 3,
    //   'audio_name': 'Wrong audio path',
    //   'campaign_id': ['400', '52'],
    //   'audio_path':
    //       'https://sys.senheng.com.my/shmanagement/uploads/telemarketing/audios/e007c5a3af8a9f5e25b845d1ab1f3d74.mp3',
    //   'created_at': '2022-04-10 18:00:00',
    //   'updated_at': '2022-09-12 12:00:00',
    //   'active': 1,
    // },
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
    isExpandedList = List.generate(widget.callInfo2.length, (_) => false);
  }

  fetchData() {
    Future.microtask(() async {
      await ref.read(campaignProvider).fetchCampaignImages(widget.cid);
      // await ref.read(campaignProvider).campaignAudio;
      // await ref.read(campaignProvider).campaignVideo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Adaptive.w(4), vertical: Adaptive.h(1)),
      child: Column(
        children: [
          for (int i = 0; i < widget.callInfo2.length; i++)
            Card(
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              color: Colors.white,
              elevation: 0.5,
              child: Column(
                children: [
                  ExpansionTile(
                    tilePadding: EdgeInsetsDirectional.only(start: 4, end: 4),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    title: Padding(
                      padding: EdgeInsets.only(left: Adaptive.w(1)),
                      child: Text(
                        widget.callInfo2[i]['campaign_name'],
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: Padding(
                      padding: EdgeInsets.only(right: Adaptive.w(1)),
                      child: Icon(
                        isExpandedList[i]
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Checking if description contains <br /> and replacing with \n
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: Adaptive.w(3),
                                right: Adaptive.w(0),
                                top: Adaptive.h(2),
                                bottom: Adaptive.h(2),
                              ),
                              child: Text(
                                widget.callInfo2[i]['description']
                                        .contains('<br />')
                                    ? widget.callInfo2[i]['description']
                                        .replaceAll('<br />', '\n')
                                    : widget.callInfo2[i]['description'],
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.image_outlined,
                                    color: Colors.black),
                                onPressed: () {
                                  _debouncer.run(() {
                                    openImage(
                                        widget.callInfo2[i]['campaign_name']);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.audio_file_outlined,
                                    color: Colors.black),
                                onPressed: () {
                                  _debouncer.run(() {
                                    openAudio(
                                        widget.callInfo2[i]['campaign_name']);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.videocam_outlined,
                                    color: Colors.black),
                                onPressed: () {
                                  _debouncer.run(() {
                                    openVideo(
                                        widget.callInfo2[i]['campaign_name']);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        isExpandedList[i] = expanded;
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  openAudio(String campaignName) async {
    final callsummary = ref.read(callSummaryDetailProvider);
    await callsummary.compareCampaignName(campaignName);
    final campaignId = callsummary.getCampaignId;
    final campaign = ref.read(campaignProvider);
    await campaign.fetchCampaignAudio(campaignId);
    audioList = campaign.campaignAudio;
    AppDebug().printDebug(msg: 'audioList:$audioList...$campaignId');
    if (audioList.isEmpty) {
      AppDebug().printDebug(msg: 'audioList is empty');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DownloadModal(
            audioList: audioList,
            videoList: null,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DownloadModal(
            audioList: audioList,
            videoList: null,
          );
        },
      );
    }
  }

  openImage(String campaignName) async {
    final callsummary = ref.read(callSummaryDetailProvider);
    await callsummary.compareCampaignName(campaignName);
    final campaignId = callsummary.getCampaignId;
    final imageList = await ref.read(campaignProvider).getCampaignImages;
    String description = '';

    for (var campaign in widget.callInfo2) {
      if (campaign['campaign_name'] == campaignName) {
        description = campaign['description'] ?? '';
        if (description.contains('<br />')) {
          description = description.replaceAll('<br />', '\n');
        }
        break;
      }
    }

    AppDebug().printDebug(msg: 'imageList:$imageList...$campaignId');
    if (imageList.isEmpty || imageList[0]['images'] == null) {
      AppDebug().printDebug(msg: 'imagesList is empty');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShareImagesModal(
            imagesList: imagesList,
            text: description,
          );
        },
      );
    } else {
      for (var item in imageList) {
        if (campaignId.toString() == item['campaign_id'].toString()) {
          imagesList = List<String>.from(item['images']);
          AppDebug().printDebug(msg: 'imagesList:$imagesList');
          break;
        }
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShareImagesModal(
            imagesList: imagesList,
            text: description,
          );
        },
      );
    }
  }

  openVideo(String campaignName) async {
    final callsummary = ref.read(callSummaryDetailProvider);
    await callsummary.compareCampaignName(campaignName);
    final campaignId = callsummary.getCampaignId;
    await ref.read(campaignProvider).fetchCampaignVideo(campaignId);
    videoList = await ref.read(campaignProvider).getCampaignVideo;

    AppDebug().printDebug(msg: 'videoList:$videoList...$campaignId');
    if (videoList.isEmpty) {
      AppDebug().printDebug(msg: 'videoList is empty');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DownloadModal(
            audioList: null,
            videoList: videoList,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DownloadModal(
            audioList: null,
            videoList: videoList,
          );
        },
      );
    }
  }
}
