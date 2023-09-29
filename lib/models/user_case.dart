// ignore_for_file: non_constant_identifier_names

class UserCase{

  UserCase({
    this.id,
    required this.user_id,
    this.create_date,
    required this.case_name, 
     this.success_rate,
     this.completed,
      bool? forgered}); 

  int? id;
  int? user_id;
  String? create_date;  
  String? case_name; 
  double? success_rate; 
  bool? completed;
  bool? forgered;

  UserCase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user_id = json['user_id'];  
    create_date = json['create_date'];
    case_name = json['case_name'];
    success_rate = json['success_rate'] ==null ?  0.0 : json['success_rate'] ;
    completed = json['completed']  ==null ?  false : json['completed'] ; 
    forgered = json['forgered']  ==null ?  false : json['forgered'] ; 
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id; 
    _data['user_id'] = user_id; 
    _data['create_date'] = create_date;
    _data['case_name'] = case_name;
    _data['success_rate'] = success_rate;
    _data['completed'] = completed; 
    _data['forgered'] = forgered; 
    return _data;
  }
}
 