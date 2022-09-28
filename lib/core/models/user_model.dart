class UserModel{

  final int id;
  final String username;
  final String email;
  final String phonenumber;
  final String password;
  final String image;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phonenumber,
    required this.password,
    required this.image
  });

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'username' : username,
      'email' : email,
      'phonenumber' : phonenumber,
      'password' : password,
      'image' : image
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] ?? 0,
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        phonenumber: map['phonenumber'] ?? '',
        password: map['password'] ?? '',
        image: map['image'] ?? ''
    );
  }

}