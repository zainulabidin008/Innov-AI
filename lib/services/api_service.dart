import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_keys.dart';

class APIService {
  //Post API Request
  static postRequest({
    required String url,
    required Map<String, String> headers,
    var body,
  }) async {
    Uri uri = Uri.parse(url);

    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    return response;
  }

  //For Upload Image
  static uploadImage(String url, http.MultipartFile multipartFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    var headers = {
      'accept': 'application/json',
      'authorization': 'Basic ${AppKeys.did_key}',
      'content-type': 'multipart/form-data',
    };

    request.headers.addAll(headers);
    request.files.add(multipartFile);

    var response = await request.send();

    return await http.Response.fromStream(response);
  }

  //Get API Request
  static getRequest({
    required String url,
    required Map<String, String> headers,
    Map<String, String>? body,
  }) async {
    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(headers);

    if (body != null) {
      request.bodyFields = body;
    }

    http.StreamedResponse response = await request.send();

    return await response.stream.bytesToString();
  }
}
