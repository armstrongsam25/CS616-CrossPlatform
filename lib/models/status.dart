// ignore_for_file: public_member_api_docs, sort_constructors_first
class Status {

  int code;
  String codeString;
  int type;
  int value;
  var data;
  Status({
    required this.code,
    required this.codeString,
    required this.type,
    required this.value,
     this.data,
  });
  
}
