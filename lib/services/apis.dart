// ignore_for_file: non_constant_identifier_names

import 'dart:convert'; 

import 'package:Skywalk/models/status.dart';
import 'package:Skywalk/models/user.dart';
import 'package:Skywalk/models/user_case.dart';
import 'package:Skywalk/utils/status_codes.dart';
import 'package:get/get.dart';

import 'dart:developer' as developer;
import 'package:http/http.dart' as http; 
class ApiServices extends GetxController{
 
  final String api_url = "https://imzai.net/api/";

  static ApiServices get to => Get.find();

 Future<int> checkConnection() async {
    try { 
      http.Response response = await http.get(Uri.tryParse(
          api_url + 'checkConnection')!);
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        developer.log(result.toString(), name: 'ApiServices');
        return result;
      } else {
        return 0;
      }
    } catch (e) {
     return -1;
    }  
  }
  Future<Status> signup(User u) async {
    try { 
      http.Response response = await http.post(Uri.tryParse(
          api_url + 'signup')!, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(<String, dynamic>{
      'User':  json.encode(u)
    }));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        int userid= result['userid'];
        int status= result['status'];

          developer.log(result.toString(), name: 'ApiServices');
        if( status==STATUS_CODES.USER_ADDED_SUCCESSFULL.code){

          developer.log(result.toString(), name: 'ApiServices');
          STATUS_CODES.USER_ADDED_SUCCESSFULL.value=userid;
          return STATUS_CODES.USER_ADDED_SUCCESSFULL;
        }

        else if ( status==STATUS_CODES.USER_ALREADY_EXIST.code){  
          return STATUS_CODES.USER_ALREADY_EXIST;
        }

        else if ( status==STATUS_CODES.SQL_ERROR.code){  
          return STATUS_CODES.SQL_ERROR;
        }
        
        else { 
          return STATUS_CODES.UNKNOWN_ERROR;
        }
      } else {
 
        return STATUS_CODES.HTTP_POST_ERROR_FROM_SERVER;
      }
    } catch (e) {
     return STATUS_CODES.HTTP_POST_ERROR_FROM_APP;
    }  
  }

    Future<Status> login(String email,String password) async {
    try { 
      http.Response response = await http.post(Uri.tryParse(
          api_url + 'login')!, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(<String, dynamic>{
      'email':email, 'password':password
    }));
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        int userid= result['userid'];
        int status= result['status'];
        if( status==STATUS_CODES.LOGIN_SUCCESSFULL.code){

          developer.log(result.toString(), name: 'ApiServices');
          STATUS_CODES.LOGIN_SUCCESSFULL.value=userid;
          return STATUS_CODES.LOGIN_SUCCESSFULL;
        }
        else{ 
          developer.log(result.toString(), name: 'ApiServices');
          return STATUS_CODES.LOGIN_FAILED;
        }
        
      } else {
 
        return STATUS_CODES.HTTP_POST_ERROR_FROM_SERVER;
      }
    } catch (e) {
     return STATUS_CODES.HTTP_POST_ERROR_FROM_APP;
    }  
  }


  Future<Status> addUserCase(UserCase uc) async {
    try { 
      http.Response response = await http.post(Uri.tryParse(
          api_url + 'addusercase')!, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(<String, dynamic>{
      'user_case':  json.encode(uc)

    }));


          developer.log(uc.user_id.toString(), name: 'ApiServices');
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        int status= result['status'];

          developer.log(result.toString(), name: 'ApiServices');
        if( status==STATUS_CODES.USER_CASE_ADDED_SUCCESSFULL.code){

          UserCase user_case= UserCase.fromJson(result['data']);
          developer.log(result.toString(), name: 'ApiServices');
          STATUS_CODES.USER_CASE_ADDED_SUCCESSFULL.data=user_case;
          return STATUS_CODES.USER_CASE_ADDED_SUCCESSFULL;
        }
 
        else if ( status==STATUS_CODES.USER_CASE_NAME_EXISTS.code){  
          return STATUS_CODES.USER_CASE_NAME_EXISTS;
        }

        else if ( status==STATUS_CODES.SQL_ERROR.code){  
          return STATUS_CODES.SQL_ERROR;
        }
        
        else { 
          return STATUS_CODES.UNKNOWN_ERROR;
        }
      } else {
 
        return STATUS_CODES.HTTP_POST_ERROR_FROM_SERVER;
      }
    } catch (e) {
     return STATUS_CODES.HTTP_POST_ERROR_FROM_APP;
    }  
  }


  Future<Status> getUserCaseList(int user_id) async {
    try { 
      http.Response response = await http.get(Uri.tryParse(
          api_url + 'getusercases/'+user_id.toString())! );

  
 
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

   
        //List data= result['data'];
        int status= result['status'];  
        if( status==STATUS_CODES.QUERY_SUCCESSFULL.code){

       List<UserCase> caseList = List<UserCase>.from(result['data'].map((model)=> UserCase.fromJson(model)));
          STATUS_CODES.QUERY_SUCCESSFULL.data=caseList;
          return STATUS_CODES.QUERY_SUCCESSFULL;
        }

 
        else if ( status==STATUS_CODES.DATA_LENGTH_ZERO.code){  
          return STATUS_CODES.DATA_LENGTH_ZERO;
        }

        else if ( status==STATUS_CODES.SQL_ERROR.code){  
          return STATUS_CODES.SQL_ERROR;
        }
        
        
        else { 
          return STATUS_CODES.UNKNOWN_ERROR;
        }

  
 
      } else {
 
        return STATUS_CODES.HTTP_POST_ERROR_FROM_SERVER;
      }
    } catch (e) {
     return STATUS_CODES.HTTP_POST_ERROR_FROM_APP;
    }  
  } 


  Future<Status> deleteUserCase(int user_id) async {
    try { 
      http.Response response = await http.get(Uri.tryParse(
          api_url + 'deleteusercase/'+user_id.toString())! );

  
 
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

   
        //List data= result['data'];
        int status= result['status'];  
        if( status==STATUS_CODES.USER_CASE_DELETED_SUCCESSFULL.code){
  
          return STATUS_CODES.USER_CASE_DELETED_SUCCESSFULL;
        }

 
        else if ( status==STATUS_CODES.NO_USER_CASE_FOUND.code){  
          return STATUS_CODES.NO_USER_CASE_FOUND;
        }

        else if ( status==STATUS_CODES.SQL_ERROR.code){  
          return STATUS_CODES.SQL_ERROR;
        }
        
        
        else { 
          return STATUS_CODES.UNKNOWN_ERROR;
        }

  
 
      } else {
 
        return STATUS_CODES.HTTP_POST_ERROR_FROM_SERVER;
      }
    } catch (e) {
     return STATUS_CODES.HTTP_POST_ERROR_FROM_APP;
    }  
  } 


}




