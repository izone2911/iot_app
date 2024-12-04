// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constant/_index.dart' show Paths;

enum RequestCode { success, notConnect, timeout, unknown }

class NetworkHandler {
  static final dio = Dio();
  static final requestOptions = RequestOptions(
      method: "GET",
      baseUrl: Paths.serverUrl,
      connectTimeout: const Duration(seconds: 2));

  var requestCode = RequestCode.success;

  Future<void> networkRequest({
    required RequestOptions requestOptions,
    required void Function(Response response) handleResponse,
    void Function(DioException dioException)? handleBadResponse,
    void Function()? afterHandleResponse,
  }) async {
    handleBadResponse ??= (dioException) =>
        print(dioException.response.toString()); // ignore: avoid_print

    try /**/
    {
      final Response response = await NetworkHandler.dio.fetch(requestOptions);
      handleResponse(response);
      requestCode = RequestCode.success;
      // print(response.data['body']);
    } on DioException catch (dioException) /**/
    {
      switch (dioException.type) /**/
      {
        case DioExceptionType.connectionError:
          requestCode = RequestCode.notConnect;
          break;

        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionTimeout:
          requestCode = RequestCode.timeout;
          break;

        case DioExceptionType.badResponse:
          handleBadResponse(dioException);
          requestCode = RequestCode.unknown;
          break;

        default:
          print(dioException.toString()); // ignore: avoid_print
          requestCode = RequestCode.unknown;
          break;
      }
    } finally /**/
    {
      afterHandleResponse?.call();
    }
  }
}
