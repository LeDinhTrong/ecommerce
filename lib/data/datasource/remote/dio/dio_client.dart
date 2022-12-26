import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  // final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio dio;
  String token;

  DioClient(
    // this.baseUrl,
    Dio dioC, {
    this.loggingInterceptor,
    this.sharedPreferences,
  }) {
    token = sharedPreferences.getString(AppConstants.TOKEN);
    print("NNNN $token");
    dio = dioC ?? Dio();
    dio
      // ..options.baseUrl = baseUrl
      ..options.connectTimeout = 60 * 1000
      ..options.receiveTimeout = 60 * 1000
      ..httpClientAdapter;
    // ..options.headers = {
    //   'Content-Type': 'application/json; charset=UTF-8',
    //   'Authorization': 'Bearer $token'
    // };
    dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      if (options == null) {
        options = new Options(headers: {});
      }
      if (uri.indexOf(AppConstants.BASE_URL) >= 0) {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Authorization'] = 'Bearer $token';
      } else if (uri.indexOf(AppConstants.BASE_URL_API) >= 0) {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Token'] = 'e557e6c5-03f1-11ec-b5ad-92f02d942f87';
        options.headers['ShopId'] = '82186';
      } else {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Token'] = '018B2dF4A9c343C459436Fc26eD28d1E2d4eD96c';
      }
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      print(e);
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      print(_.toString());
      throw FormatException("Unable to process the data");
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      if (options == null) {
        options = new Options(headers: {});
      }
      if (uri.indexOf(AppConstants.BASE_URL) >= 0) {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Authorization'] = 'Bearer $token';
      } else if (uri.indexOf(AppConstants.BASE_URL_API) >= 0) {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Token'] = 'e557e6c5-03f1-11ec-b5ad-92f02d942f87';
        options.headers['ShopId'] = '82186';
      } else {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Token'] = '018B2dF4A9c343C459436Fc26eD28d1E2d4eD96c';
      }
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      print(_.toString());
      throw FormatException("Unable to process the data");
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      if (options == null) {
        options = new Options(headers: {});
      }
      if (uri.indexOf(AppConstants.BASE_URL) >= 0) {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Authorization'] = 'Bearer $token';
      } else if (uri.indexOf(AppConstants.BASE_URL_API) >= 0) {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Token'] = 'e557e6c5-03f1-11ec-b5ad-92f02d942f87';
        options.headers['ShopId'] = '82186';
      } else {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Token'] = '018B2dF4A9c343C459436Fc26eD28d1E2d4eD96c';
      }
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      print(_.toString());
      throw FormatException("Unable to process the data");
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) async {
    try {
      if (options == null) {
        options = new Options(headers: {});
      }
      if (uri.indexOf(AppConstants.BASE_URL) >= 0) {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Authorization'] = 'Bearer $token';
      } else if (uri.indexOf(AppConstants.BASE_URL_API) >= 0) {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Token'] = 'e557e6c5-03f1-11ec-b5ad-92f02d942f87';
        options.headers['ShopId'] = '82186';
      } else {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        options.headers['Token'] = '018B2dF4A9c343C459436Fc26eD28d1E2d4eD96c';
      }
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      print(_.toString());
      throw FormatException("Unable to process the data");
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
