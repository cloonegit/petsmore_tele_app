import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:petsmore_tele_app/api/custom_exception.dart';
import 'package:petsmore_tele_app/api/global_api.dart';
import 'package:petsmore_tele_app/global_function/app_debug_print.dart';
import 'package:http/http.dart' as http;
import 'package:petsmore_tele_app/services/get_it.dart';

class APIManager {
  Future<dynamic> postAPICall(String url, Map param) async {
    AppDebug().printDebug(msg: "Calling API: $url");
    AppDebug().printDebug(msg: "Calling parameters: $param");

    var responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), body: param)
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");
        throw throw TimeoutException("");
      });

      responseJson = _response(response, url: url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException(
          'The connection has timed out, please try again');
    } on FormatException {
      throw FetchDataException('Bad response format (URL: $url)');
    } catch (e) {
      // Catch any other errors
      AppDebug().printDebug(msg: 'Unknown error occurred: $e');
      throw FetchDataException('An unexpected error occurred');
    }
    return responseJson;
  }

  Future<dynamic> postAPICallWithHeader(
      String url, Map param, Map<String, String>? headers) async {
    AppDebug().printDebug(msg: "Calling POST API: $url");
    AppDebug().printDebug(msg: "Calling parameters: $param");

    var responseJson;
    try {
      final stopwatch2 = Stopwatch()..start();
      final response = await http
          .post(Uri.parse(url), body: param, headers: headers)
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");

        throw throw TimeoutException("");
      });
      AppDebug()
          .printDebug(msg: 'call $url api executed in ${stopwatch2.elapsed}');
      responseJson = _response(response, url: url, header: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postAPICallWithHeaderBodyJsonEncode(
      String url, String param, Map<String, String>? headers) async {
    AppDebug().printDebug(msg: "Calling POST API: $url");
    AppDebug().printDebug(msg: "Calling parameters: $param");

    var responseJson;
    try {
      final stopwatch2 = Stopwatch()..start();
      final response = await http
          .post(Uri.parse(url), body: param, headers: headers)
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");
        throw throw TimeoutException("");
      });
      AppDebug()
          .printDebug(msg: 'call $url api executed in ${stopwatch2.elapsed}');
      responseJson = _responseDecode(response, url: url, header: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postAPICallWithHeader2(
      String url, Map param, Map<String, String>? headers) async {
    AppDebug().printDebug(msg: "Calling POST API: $url");
    AppDebug().printDebug(msg: "Calling parameters: $param");

    var responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), body: jsonEncode(param), headers: headers)
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");
        throw throw TimeoutException("");
      });
      responseJson = _response(response, url: url, header: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getAPICallWithHeader(
      String url, Map<String, String>? header) async {
    AppDebug().printDebug(msg: "Calling GET API: $url");

    var responseJson;
    try {
      final response = await http
          .get(Uri.parse(url), headers: header)
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");

        throw throw TimeoutException("");
      });
      responseJson = _response(response, url: url, header: header);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

//using this currently
  Future<dynamic> getAPICall(String url) async {
    AppDebug().printDebug(msg: "Calling GET API: $url");

    var responseJson;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");
        throw throw TimeoutException("");
      });
      responseJson = _response(response, url: url);
      // responseJson = _responseDecode(response, url: url);

      AppDebug().printDebug(msg: 'in api manager :$responseJson');
    } on SocketException {
      String errorMessage =
          'Unable to reach server.\n Please check your internet connection';
      getIt<ErrorMessageService>().setErrorMessage(errorMessage);
      throw FetchDataException(errorMessage);
    } on TimeoutException {
      String errorMessage = 'The connection has timed out, please try again';
      getIt<ErrorMessageService>().setErrorMessage(errorMessage);
      throw FetchDataException(errorMessage);
    } on FormatException {
      String errorMessage = 'Bad response format (URL: $url)';
      getIt<ErrorMessageService>().setErrorMessage(errorMessage);
      throw FetchDataException(errorMessage);
    } catch (e) {
      String errorMessage = 'Unknown error occurred: $e (URL: $url)';
      getIt<ErrorMessageService>().setErrorMessage(errorMessage);
      AppDebug().printDebug(msg: errorMessage);
      throw FetchDataException(errorMessage);
    }
    return responseJson;
  }

  Future<dynamic> patchAPICallWithHeader(
      String url, Map param, Map<String, String>? headers) async {
    AppDebug().printDebug(msg: "Calling PATCH API: $url");
    AppDebug().printDebug(msg: "Calling parameters: $param");

    var responseJson;
    try {
      final stopwatch2 = Stopwatch()..start();
      final response = await http
          .patch(Uri.parse(url), body: param, headers: headers)
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");

        throw throw TimeoutException("");
      });
      AppDebug()
          .printDebug(msg: 'call $url api executed in ${stopwatch2.elapsed}');
      responseJson = _response(response, url: url, header: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> deleteAPICallWithHeader(
      String url, Map<String, String>? header) async {
    AppDebug().printDebug(msg: "Calling DELETE API: $url");

    var responseJson;
    try {
      final response = await http
          .delete(Uri.parse(url), headers: header)
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");
        throw throw TimeoutException("");
      });
      responseJson = _response(response, url: url, header: header);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putAPICallWithHeader(
      String url, Map param, Map<String, String>? headers) async {
    AppDebug().printDebug(msg: "Calling POST API: $url");
    AppDebug().printDebug(msg: "Calling parameters: $param");

    var responseJson;
    try {
      final stopwatch2 = Stopwatch()..start();
      final response = await http
          .put(Uri.parse(url), body: param, headers: headers)
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");

        throw throw TimeoutException("");
      });
      AppDebug()
          .printDebug(msg: 'call $url api executed in ${stopwatch2.elapsed}');
      responseJson = _response(response, url: url, header: headers);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response, {url, header}) {
    var responseJson;
    switch (response.statusCode) {
      case 200:
        try {
          if (response.body.isEmpty) {
            AppDebug().printDebug(msg: 'Empty response body for $url');
            return {};
          }
          responseJson = json.decode(response.body.toString());
          return responseJson;
        } catch (e) {
          AppDebug().printDebug(
              msg:
                  'JSON Decode Error for $url: $e\nResponse Body: ${response.body}');
          rethrow;
        }
      case 400:
        responseJson = json.decode(response.body.toString());
        getIt<ErrorMessageService>().setErrorMessage("Bad request: $url");
        return responseJson;
      case 404:
        responseJson = json.decode(response.body.toString());
        getIt<ErrorMessageService>().setErrorMessage("Not found: $url");
        return responseJson;
      case 401:
        getIt<ErrorMessageService>().setErrorMessage("Unauthorized: $url");
        throw UnauthorisedException(response.body.toString());
      case 403:
        getIt<ErrorMessageService>().setErrorMessage("Forbidden: $url");
        throw UnauthorisedException(response.body.toString());
      case 500:
        getIt<ErrorMessageService>().setErrorMessage("Server error: $url");
        throw ServerErrorException(response.body.toString());
      default:
        String errorMessage =
            'Error occurred while communicating with server with StatusCode: ${response.statusCode}';
        getIt<ErrorMessageService>().setErrorMessage(errorMessage);
        throw FetchDataException(errorMessage);
    }
  }

  dynamic _responseDecode(http.Response response, {url, header}) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        if (responseJson.toString().contains('code') ||
            responseJson.toString().contains('CODE')) {
          if (responseJson['code'] == 400 ||
              responseJson['code'] == 401 ||
              responseJson['code'] == 402 ||
              responseJson['code'] == 404 ||
              responseJson['code'] == 500 ||
              responseJson['code'] == 503 ||
              responseJson['CODE'] == 400 ||
              responseJson['CODE'] == 401 ||
              responseJson['CODE'] == 402 ||
              responseJson['CODE'] == 404 ||
              responseJson['CODE'] == 500 ||
              responseJson['CODE'] == 503) {
            AppDebug().printDebug(
                msg:
                    'error api : decode $url ${responseJson['code']} $responseJson');
          }
        }
        return responseJson;
      case 400:
        throw json.decode(response.body.toString());
      case 401:
        throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body);
      case 404:
        throw json.decode(response.body.toString());
      case 500:
        throw ServerErrorException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }

  String extractPathFromUrl(String url, {from}) {
    Uri uri = Uri.parse(url);
    return uri.path;
  }

  Future<dynamic> postAPICallWithoutBody(
      String url, Map<String, String>? headers) async {
    AppDebug().printDebug(msg: "Calling API: $url");

    var responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: GlobalAPI().timeout), onTimeout: () {
        AppDebug().printDebug(msg: "Calling API Timeout: $url");
        throw throw TimeoutException("");
      });

      responseJson = _responseDecode(response, url: url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
}
