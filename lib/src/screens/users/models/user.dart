class User {
  final String name;
  final int id;
  final String phone;
  final String email;
  final String thumbnail;
  // final bool isAdmin;
  // final String plainPassword;
  // final String hashPassword;
  final String createdAt;
  final String birth;
  final int status;
  final int gender;
  // final String activateCode;
  // final String forgotPasswordCode;
  // final String codeLifespan;

  User({
    required this.id, 
    required this.phone, 
    //required this.isAdmin, 
    //required this.plainPassword, 
    //required this.hashPassword, 
    required this.createdAt, 
    required this.status, 
    //required this.activateCode, 
    //required this.forgotPasswordCode, 
    //required this.codeLifespan, 
    required this.name, 
    required this.email,
    required this.thumbnail,
    required this.gender,
    required this.birth
    }
  );
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      //hashPassword: json['hash_password'],
      id: json['id'],
      phone: json['phone'],
      email: json['email'],
      //isAdmin: json['is_admin'],
      //plainPassword: json['plain_password'],
      createdAt: json['created_at'],
      status: json['status'],
      name: json['first_name']+json['last_name'],
      thumbnail: json['thumbnail'],
      gender: json['gender'],
      birth: json['birth']
      //activateCode: json['activate_code'],
      //forgotPasswordCode: json['forgot_password_code'],
      //codeLifespan: json['code_lifespan']
    );
  }

  @override
  String toString() => 'User { name: $name, email: $email}';
}
