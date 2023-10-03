// ignore_for_file: non_constant_identifier_names

import 'package:Skywalk/models/status.dart';

class STATUS_CODES {
//types:
// -1 error
// 0 warning
// 1 success

// Add the new Status Definitions
  static Status USER_CONFIRMATION_REQUIRED = Status(
      code: 110, codeString: "User Confirmation Required", type: 0, value: 0);
  static Status SIGNUP_ERROR =
      Status(code: 111, codeString: "Signup Error", type: -1, value: 0);
  static Status SQL_ERROR =
      Status(code: -100, codeString: "SQL error", type: -1, value: 0);
  static Status USER_ALREADY_EXIST =
      Status(code: 100, codeString: "User already exists", type: 0, value: 0);
  static Status USER_ADDED_SUCCESSFULL = Status(
      code: 101, codeString: "User added successfully", type: 1, value: 0);
  static Status LOGIN_SUCCESSFULL =
      Status(code: 102, codeString: "Login successful", type: 1, value: 0);
  static Status LOGIN_FAILED =
      Status(code: 103, codeString: "Login failed", type: -1, value: 0);

  static Status USER_CASE_ADDED_SUCCESSFULL = Status(
      code: 104, codeString: "Case added successfully", type: 1, value: 0);
  static Status DATA_LENGTH_ZERO = Status(
      code: 105, codeString: "There is no data to shown", type: 0, value: 0);
  static Status QUERY_SUCCESSFULL =
      Status(code: 106, codeString: "Query successfull", type: 1, value: 0);
  static Status USER_CASE_NAME_EXISTS = Status(
      code: 107, codeString: "Case name already exists", type: 0, value: 0);
  static Status NO_USER_CASE_FOUND =
      Status(code: 108, codeString: "No user case found", type: 0, value: 0);
  static Status USER_CASE_DELETED_SUCCESSFULL = Status(
      code: 109,
      codeString: "User case deleted successfully",
      type: 1,
      value: 0);

  /*
 USER_ALREADY_EXIST= 100
SQL_ERROR= -100
USER_ADDED_SUCCESSFULL= 101 
LOGIN_SUCCESSFULL= 102
LOGIN_FAILED= 103
USER_CASE_ADDED_SUCCESSFULL= 104
DATA_LENGTH_ZERO= 105
QUERY_SUCCESSFULL=106
 */
  static Status HTTP_POST_ERROR_FROM_SERVER = Status(
      code: 200, codeString: "HTTP POST error from server", type: -1, value: 0);
  static Status HTTP_POST_ERROR_FROM_APP = Status(
      code: 201, codeString: "HTTP POST error from app", type: -1, value: 0);
  static Status UNKNOWN_ERROR =
      Status(code: 202, codeString: "Unknown Error", type: -1, value: 0);

  static Status getStatusByCode(int code) {
    switch (code) {
      case -100:
        return SQL_ERROR;
      case 100:
        return USER_ALREADY_EXIST;
      case 101:
        return USER_ADDED_SUCCESSFULL;
      case 102:
        return LOGIN_SUCCESSFULL;
      case 103:
        return LOGIN_FAILED;
      case 104:
        return USER_CASE_ADDED_SUCCESSFULL;
      case 105:
        return DATA_LENGTH_ZERO;
      case 106:
        return QUERY_SUCCESSFULL;
      case 107:
        return USER_CASE_NAME_EXISTS;
      case 108:
        return NO_USER_CASE_FOUND;
      case 109:
        return USER_CASE_DELETED_SUCCESSFULL;
      default:
        return UNKNOWN_ERROR;
    }
  }
}
