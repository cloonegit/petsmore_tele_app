import 'package:flutter/material.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';

class SearchProvider extends ChangeNotifier {
  bool isError = false;
  bool get getIsError => isError;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  String? _failure;
  String? get failure => _failure;

  Map responseData = {};
  Map get getResponseData => responseData;

  List filteredData = [];
  List get getFilteredData => filteredData;

  void setFilteredData(getFilteredData) {
    filteredData = getFilteredData;
    AppDebug()
        .printDebug(msg: 'search provider : $getFilteredData////$filteredData');
    notifyListeners();
  }
}
