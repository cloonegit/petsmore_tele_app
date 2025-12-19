import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nrs_tele_apps/global_function/app_debug_print.dart';
import 'package:nrs_tele_apps/main.dart';
import 'package:nrs_tele_apps/provider/search_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomSearchBar extends ConsumerStatefulWidget {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List data = [];
  List item = [];

  // final bool Function(dynamic) filterFunction;

  CustomSearchBar(
    BuildContext context, {
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.data,
    required this.item,
  });

  @override
  ConsumerState<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends ConsumerState<CustomSearchBar> {
  List filteredData = [];

  @override
  void initState() {
    super.initState();
    // widget.searchController.addListener(() {
    //   widget.filterData(widget.searchQuery);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Adaptive.w(4),
          right: Adaptive.w(4),
          top: Adaptive.h(2),
          bottom: Adaptive.h(2)),
      child: TextField(
        enableInteractiveSelection: false,
        cursorColor: Color(0xFFED1C24),
        controller: widget.searchController,
        onChanged: (value) {
          AppDebug().printDebug(msg: 'valueee:$value');
          filterData(value, widget.item);
        },
        decoration: InputDecoration(
          hintText: 'Search',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          suffixIcon: widget.searchController.text.trim().isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    widget.searchController.clear();
                    filterData('', []);
                  },
                )
              : null,
        ),
      ),
    );
  }

  void filterData(String query, List keys) {
    setState(() {
      widget.searchQuery = query.toLowerCase();
      filteredData = widget.data.where((item) {
        if (item is Map) {
          return keys.any((key) =>
              item[key]?.toLowerCase().contains(widget.searchQuery) ?? false);
        }
        return false;
      }).toList();
    });

    ref.read(searchProvider).setFilteredData(filteredData);
    AppDebug().printDebug(msg: ' filteredData :${filteredData}');
  }
}
