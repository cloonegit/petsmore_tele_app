import 'package:nrs_tele_apps/config/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/widgets/global_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CallStatusDropdown extends ConsumerStatefulWidget {
  String callStatus = '';
  CallStatusDropdown({super.key, required this.callStatus});

  @override
  ConsumerState<CallStatusDropdown> createState() => _CallStatusDropdownState();
}

class _CallStatusDropdownState extends ConsumerState<CallStatusDropdown> {
  String selectedNoAnswerValue = '';
  String selectedMakePurchaseType = '';
  String selectedMakePurchaseProduct = '';
  String productName = '';
  String productBrand = '';
  String productSKU = '';
  String productPrice = '';
  String productDesc = '';
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List<String> NoAnswer = ['Invalid Number', 'Wrong Number', 'No Pickup'];
  List<String> MakePurchase = ['Payment via Tele Apps Link', 'Escalate to TQM'];
  List teleproductData = [];
  Map selection = {};
  bool ableCallStatus = false;
  bool ableNoAnswer = false;

  void initState() {
    super.initState();
    AppDebug().printDebug(
        msg: 'Widget.callStatus in call status tab:${widget.callStatus}');
    fetchData();
  }

  @override
  void dispose() {
    // changeCallStatus();
    super.dispose();
  }

  // void changeCallStatus() {
  //   Future.microtask(() {
  //     final callsummarydetail = ref.read(callSummaryDetailProvider);
  //     callsummarydetail.setReason('');
  //     callsummarydetail.setReasonProduct('');
  //     callsummarydetail.setReasonType('');
  //   });
  // }

  fetchData() {
    Future.microtask(() async {
      await ref.read(callSummaryDetailProvider).fetchCallSummaryDetail;
    });
  }

  // Future<void> getCallStatusData(callSummaryDetail) async {
  //   ableCallStatus = callSummaryDetail.getableCallStatus;
  //   ableNoAnswer = callSummaryDetail.getableNoAnswer;
  //   selection = callSummaryDetail.getSelection;
  // }

  @override
  Widget build(BuildContext context) {
    final callSummary = ref.watch(callSummaryDetailProvider);
    teleproductData = callSummary.getTeleproductData;
    AppDebug().printDebug(msg: 'Teleproduct:${teleproductData}');

    if (callSummary.isFetching)
      return Center(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 5,
          strokeAlign: CircularProgressIndicator.strokeAlignCenter,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    if (teleproductData.isEmpty)
      return Center(child: Text('No Data Available'));

    return Container(
      // width: Adaptive.w(50),
      // height: Adaptive.h(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.callStatus == "NOANS") noAnswer(callSummary),
          if (widget.callStatus == "PURCHASE") makePurchaseType(),
          if (widget.callStatus == "PURCHASE" &&
              selectedMakePurchaseType == "Payment via Tele Apps Link")
            makePurchaseProduct(),
          if (widget.callStatus == "PURCHASE" &&
              selectedMakePurchaseType == "Payment via Tele Apps Link" &&
              selectedMakePurchaseProduct != '')
            showProductDetails(),
        ],
      ),
    );
  }

  Widget noAnswer(callSummary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: Adaptive.h(1),
                left: Adaptive.w(2),
                right: Adaptive.w(2)),
            child: GestureDetector(
              onTap: () {
                tickListDialogSmall(NoAnswer, selectedNoAnswerValue,
                    (newValue) {
                  callSummary.setReason(newValue);
                  setState(() {
                    selectedNoAnswerValue = newValue;
                  });
                });
              },
              child: Container(
                padding: const EdgeInsets.only(left: 15, top: 5.0, bottom: 5.0),
                width: Adaptive.w(90),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedNoAnswerValue.isEmpty
                          ? 'Select an option'
                          : selectedNoAnswerValue,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w100,
                          color: Colors.grey[600]),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> radioListDialog() async {
    String? selectedProductParam;
    String? selectedProductName;
    String? selectedProductDesc;
    await showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('CANCEL'),
                        ),
                      ],
                    ),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        enableInteractiveSelection: false,
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                searchQuery = '';
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    // List of Radio Options
                    Expanded(
                      child: ListView(
                        children: teleproductData
                            .where((product) => product['name']!
                                .toLowerCase()
                                .contains(searchQuery))
                            .map((product) {
                          return RadioListTile<String>(
                            title: Text(product['name'] ?? ''),
                            value: product['param'] ?? '',
                            groupValue: selectedMakePurchaseProduct,
                            activeColor: AppColors.primary,
                            onChanged: (String? value) {
                              ref
                                  .read(callSummaryDetailProvider)
                                  .setReasonProduct(product['name']);
                              setState(() {
                                selectedProductParam = product['param']!;
                                selectedProductName = product['name']!;
                                selectedProductDesc = product['desc'] ?? '';

                                if (selectedProductName != "" &&
                                    selectedProductParam != "" &&
                                    selectedProductDesc != "") {
                                  Navigator.of(context).pop();
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedProductParam != null) {
      setState(() {
        selectedMakePurchaseProduct = selectedProductParam!;
        productName = selectedProductName ?? '';
        productDesc = selectedProductDesc ?? '';

        List<String> lines = productDesc.split('<br />');
        for (String line in lines) {
          if (line.startsWith('Brand:')) {
            productBrand = line.split(': ')[1].trim();
          } else if (line.startsWith('SKU:')) {
            productSKU = line.split(': ')[1].trim();
          } else if (line.startsWith('Price:')) {
            productPrice = line.split(': ')[1].trim();
          }
        }
      });
    }
  }

  //ios like dialog for both ios and android
  void tickListDialogSmall(
      List<String> items, String selectedValue, Function(String) onSelected) {
    showDialog(
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
                padding: EdgeInsets.only(
                    top: Adaptive.h(4), right: 0, left: 0, bottom: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                color: selectedValue == items[i]
                                    ? AppColors.primary
                                    : Colors.black),
                          ),
                          trailing: selectedValue == items[i]
                              ? Icon(Icons.check, color: AppColors.primary)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedValue = items[i];
                            });
                          },
                        ),
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
                                Navigator.of(context).pop();
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
                              if (selectedValue.isNotEmpty) {
                                onSelected(selectedValue);
                                Navigator.of(context).pop();
                              } else {
                                GlobalUtils.showFloatingMessage(
                                    context, 'Please select an option.');
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

  Widget makePurchaseProduct() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: Adaptive.w(4)),
                child: Text(
                  'Product:',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Adaptive.w(2),
                right: Adaptive.w(2),
                top: Adaptive.h(1),
                bottom: Adaptive.h(2)),
            child: GestureDetector(
              onTap: () {
                radioListDialog();
              },
              child: Container(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                width: Adaptive.w(90),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        productName.isEmpty ? 'Select an options' : productName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w100,
                            color: Colors.grey[600]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: Adaptive.w(2)),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget makePurchaseType() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: Adaptive.w(4), top: Adaptive.h(0)),
                child: Text(
                  'Type: ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Adaptive.w(2),
                right: Adaptive.w(2),
                top: Adaptive.h(1),
                bottom: Adaptive.h(1)),
            child: GestureDetector(
              onTap: () {
                tickListDialogSmall(MakePurchase, selectedMakePurchaseType,
                    (newValue) {
                  ref.read(callSummaryDetailProvider).setReasonType(newValue);

                  setState(() {
                    selectedMakePurchaseType = newValue;
                  });
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                width: Adaptive.w(90),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedMakePurchaseType.isEmpty
                          ? 'Select an option'
                          : selectedMakePurchaseType,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w100,
                          color: Colors.grey[600]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: Adaptive.w(2)),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showProductDetails() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: Adaptive.w(2),
                right: Adaptive.w(2),
                top: Adaptive.h(1),
                bottom: Adaptive.h(2)),
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
              width: Adaptive.w(90),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Brand: $productBrand',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'SKU: $productSKU',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Price: $productPrice',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
