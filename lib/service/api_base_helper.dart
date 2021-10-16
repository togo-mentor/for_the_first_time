import 'package:firebase_auth/firebase_auth.dart';

import './custom_exception.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;

// HTTP通信を共通化する基底クラス
class ApiBaseHelper {
  final String _baseUrl = "http://127.0.0.1:3000/api"; // 接続先URL。環境によって変わる
  
  // getでの接続
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
  
  // post接続
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

  // ステータスに応じたハンドリングを行う処理
  dynamic _returnResponse(http.Response response) async {
    switch (response.statusCode) {
      // 200の場合レスポンスをdecodeして返す
      case 200:
        Map<String, dynamic> responseJson = json.decode(response.body);
        return responseJson;
      // 400, 500の場合例外を発生させる
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw ForbiddenException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}