import 'dart:async';

import 'package:get/get.dart';
import 'package:getx_start_project/app/common/constants.dart';
import 'package:getx_start_project/app/common/storage/storage.dart';

import 'api_helper.dart';
import 'interceptor.dart';

class ApiHelperImpl extends GetConnect with ApiHelper {
  @override
  void onInit() {
    httpClient.baseUrl = Constants.baseUrl;
    httpClient.timeout = Constants.timeout;

    addRequestModifier();

    httpClient.addResponseModifier(
      (request, response) => interceptor(
        httpClient,
        request,
        response,
      ),
    );
  }

  void addRequestModifier() {
    httpClient.addRequestModifier<dynamic>((request) {
      if (Storage.hasData(Constants.token)) {
        request.headers['Authorization'] = Storage.getValue(Constants.token);
      }

      printInfo(
        info: 'REQUEST ║ ${request.method.toUpperCase()}\n'
            'url: ${request.url}\n'
            'Headers: ${request.headers}\n'
            'Body: ${request.files?.toString() ?? ''}\n',
      );

      return request;
    });
  }

  @override
  Future<Response<dynamic>> getPosts() {
    return get('posts');
  }
}
