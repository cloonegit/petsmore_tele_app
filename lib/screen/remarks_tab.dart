import 'package:nrs_tele_apps/config/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/provider/call_summary_detail_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RemarksTab extends ConsumerStatefulWidget {
  RemarksTab({
    super.key,
  });

  @override
  ConsumerState<RemarksTab> createState() => _RemarksTabState();
}

class _RemarksTabState extends ConsumerState<RemarksTab> {
  List remarksList = [];
  bool isSubmitRemark = false;

  void initState() {
    super.initState();
    remarksList = ref.read(callSummaryDetailProvider).getRemarks;
  }

  @override
  Widget build(BuildContext context) {
    // isSubmitRemark = ref.read(callSummaryDetailProvider).getSubmitRemark;
    // AppDebug().printDebug(msg: 'issubmitremarks:$isSubmitRemark');
    // if (isSubmitRemark) {
    remarksList = ref.watch(callSummaryDetailProvider).getRemarks;
    AppDebug().printDebug(msg: 'remarksList build remark tab:$remarksList');
    // ref.read(callSummaryDetailProvider).setSubmitRemarks(false);
    // }

    // if (remarksList.isEmpty) {
    //   return Center(child: Text('No data available'));
    // }

    return ListView.builder(
      itemCount: remarksList.length,
      itemBuilder: (context, index) {
        final remark = remarksList[index];
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Adaptive.w(2), vertical: Adaptive.h(1)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.primaryBackground),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: Adaptive.w(2), top: Adaptive.h(2)),
                      child: Text(
                        remark['STATUS'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: Adaptive.w(6),
                            right: Adaptive.w(3),
                            top: Adaptive.h(2)),
                        child: Text(
                          // textAlign: TextAlign.end,
                          remark['INFO'],
                          // maxLines: null,
                          // overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: Adaptive.w(2),
                          top: Adaptive.h(2),
                          bottom: Adaptive.h(2)),
                      child: Text(
                        remark['STATUS_BY'],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: Adaptive.w(2),
                          top: Adaptive.h(2),
                          bottom: Adaptive.h(2)),
                      child: Text(
                        // _formatDateTime(remark['DATETIME']),
                        remark['DATETIME'],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // String _formatDateTime(DateTime dateTime) {
  //   return DateFormat('yyyy MMMM dd  hh:mm a').format(dateTime);
  // }
}
