import 'package:petsmore_tele_app/config/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:petsmore_tele_app/widgets/custom_container.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CampaignFilterModal extends ConsumerStatefulWidget {
  CampaignFilterModal({super.key});

  @override
  ConsumerState<CampaignFilterModal> createState() =>
      _CampaignFilterModalState();
}

class _CampaignFilterModalState extends ConsumerState<CampaignFilterModal> {
  int? _selectedIndex;
  String? campaign_filter;
  List campaignList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Future.microtask(() async {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      // await ref.read(callSummaryProvider).fetchCallSummary();
      campaignList = await ref.read(callSummaryProvider).campaignList;
      AppDebug().printDebug(
          msg: 'campaignList in campaign filter page:$campaignList');

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: Adaptive.h(65),
        width: Adaptive.w(80),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Campaign Filter',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: Adaptive.h(2)),
            Builder(builder: (BuildContext context) {
              // final campaign = ref.watch(callSummaryProvider);

              if (isLoading == true) {
                return Center(
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 5,
                    strokeAlign: CircularProgressIndicator.strokeAlignCenter,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                );
              } else
                return Expanded(
                  child: ListView.builder(
                    itemCount: campaignList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              _selectedIndex = index;
                              campaign_filter = campaignList[index]['NAME'];
                            });
                          }
                          AppDebug().printDebug(
                              msg: 'campaign_filter:$campaign_filter');
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                          child: Container(
                            margin:
                                EdgeInsets.symmetric(vertical: Adaptive.h(0.5)),
                            // height: Adaptive.h(),
                            width: Adaptive.w(50),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: _selectedIndex == index
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: Adaptive.w(4),
                                  right: Adaptive.w(2),
                                  top: Adaptive.h(1.5),
                                  bottom: Adaptive.h(1.5)),
                              child: Text(
                                campaignList[index]['NAME'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _selectedIndex == index
                                      ? AppColors.primary
                                      : Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
            }),
            SizedBox(height: Adaptive.h(3)),
            CustomContainer(
                onPressed: () {
                  Navigator.pop(context);
                },
                width: Adaptive.w(70),
                // height: Adaptive.h(5),
                color: AppColors.primary,
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(5),
                title: 'CANCEL'),
            SizedBox(height: Adaptive.h(1)),
            CustomContainer(
                onPressed: () {
                  Navigator.of(context).pop(campaign_filter);
                  ref
                      .read(callSummaryProvider.notifier)
                      .setCampaignFilter(campaign_filter ?? '');
                },
                width: Adaptive.w(70),
                // height: Adaptive.h(5),
                color: Colors.white,
                backgroundColor: AppColors.primary,
                borderRadius: BorderRadius.circular(5),
                title: 'FILTER'),
            SizedBox(height: Adaptive.h(2)),
          ],
        ),
      ),
    );
  }
}
