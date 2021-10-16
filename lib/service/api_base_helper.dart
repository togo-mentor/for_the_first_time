import 'package:firebase_auth/firebase_auth.dart';

import './custom_exception.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

class ApiBaseHelper {
final String _baseUrl = "http://127.0.0.1:3000";
  
  Future<dynamic> get(String url) async {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      Map<String, dynamic> responseJson;
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
  
  Future<dynamic> post(String url, String params) async {
      final token = await FirebaseAuth.instance.currentUser!.getIdToken();
      Map<String, dynamic> responseJson;
      try {
        final response = await http.post(
          Uri.parse(_baseUrl + url),
          body: params,
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
        Map<String, dynamic> responseJson = json.decode(response.body);
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