import 'dart:convert';
import 'api_base_helper.dart';

// Api::UsersControllerと通信する
class UserService {
  final ApiBaseHelper _helper = ApiBaseHelper(); 

  // #create
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> params) async {
    final paramsJson = json.encode(params);
    return await _helper.post("/users", paramsJson);
  }
}