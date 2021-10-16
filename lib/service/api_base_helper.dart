import './custom_exception.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

class ApiBaseHelper {
final String _baseUrl = "http://127.0.0.1:3000";
  
  Future<dynamic> get(String url, String? token) async {
      var responseJson;
      try {
        final response = await http.get(
          Uri.parse(_baseUrl + url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": 'Bearer $token' // firebaseのトークン認証
          }
        );
        responseJson = _returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
      return responseJson;
  }

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body);
      print(responseJson);
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
}