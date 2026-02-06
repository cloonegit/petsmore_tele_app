import 'package:petsmore_tele_app/config/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:petsmore_tele_app/main.dart';
import 'package:petsmore_tele_app/widgets/campaign_filter_modal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomCampaignFilter extends ConsumerStatefulWidget {
  CustomCampaignFilter(BuildContext context, {super.key});

  @override
  ConsumerState<CustomCampaignFilter> createState() =>
      _CustomCampaignFilterState();
}

class _CustomCampaignFilterState extends ConsumerState<CustomCampaignFilter> {
  String? resultCampaignFilter = '';
  List campaignList = [];
  List allList = [];

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  Future<void> fetchData() async {
    await ref.read(callSummaryProvider).fetchCallSummary();
    resultCampaignFilter = ref.read(callSummaryProvider).campaignFilter;
    // AppDebug().printDebug(msg: 'tabList in call summary page:$campaignList');
    // AppDebug().printDebug(msg: 'resultCampaignFilter:$resultCampaignFilter');
  }

  void _showCampaignFilterDialog(BuildContext context) async {
    final result = await showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CampaignFilterModal();
      },
    );

    AppDebug().printDebug(msg: 'result:$result');

    // if (resultCampaignFilter != "") {
    //   if (mounted) {
    //     setState(() {
    //       resultCampaignFilter = resultCampaignFilter;
    //     });
    //     AppDebug()
    //         .printDebug(msg: 'resultCampaignFilter:$resultCampaignFilter');

    //     // if (resultCampaignFilter == 'All' || resultCampaignFilter == '') {
    //     //   // Show all campaigns
    //     //   campaignList = allList;
    //     // } else {
    //     //   // Filter campaigns based on the selected filter
    //     //   campaignList = allList.where((item) {
    //     //     return item['campaignName'] == resultCampaignFilter;
    //     //   }).toList();
    //     // }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final campaign = ref.watch(callSummaryProvider);
      final resultCampaignFilter = campaign.campaignFilter;
      if (campaign.isFetching == true) {
        return Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 5,
            strokeAlign: CircularProgressIndicator.strokeAlignCenter,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            _showCampaignFilterDialog(context);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: Adaptive.w(7)),
                      child: Container(
                        child: const Text(
                          'Campaign Filter',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                      )),
                ),
                Container(
                  width: Adaptive.w(28),
                  child: Text(
                    resultCampaignFilter == ''
                        ? 'All'
                        : '$resultCampaignFilter',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    _showCampaignFilterDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
