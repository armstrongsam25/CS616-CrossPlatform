// ignore_for_file: non_constant_identifier_names

class User {
  User({
    required this.email,
    required this.name,
    required this.last_name, 
    required this.password, 
     this.id
  });

  String? email;
  String? name;
  String? last_name; 
  String? password; 
  String? id;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name']; 
    password = json['password']; 
    last_name = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['email'] = email;
    _data['name'] = name;
    _data['password'] = password;
    _data['last_name'] = last_name; 
    return _data;
  }
}