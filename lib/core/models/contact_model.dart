import 'dart:convert';
import 'dart:typed_data';

class ContactModel {

  final String id;
  final String displayname;
  final List<String> phones;
  final List<String> emails;

  ContactModel({
    required this.id,
    required this.displayname,
    required this.emails,
    required this.phones
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'displayname' : displayname,
      'emails' : emails,
      'phones' : phones
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
        id: map['id'] ?? '',
        displayname: map['displayname'] ?? '',
        emails: map['emails'] ?? [],
        phones: map['phones'] ?? []
    );
  }
}

ContactDetail contactDetailFromJson(String str) => ContactDetail.fromMap(json.decode(str));

class ContactDetail {

  final String id;
  final String displayname;
  final String phone;
  final String email;
  final Uint8List image;

  ContactDetail({
    required this.displayname,
    required this.id,
    required this.image,
    required this.email,
    required this.phone
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'displayname' : displayname,
      'email' : email,
      'phone' : phone,
      'image' : image
    };
  }

  factory ContactDetail.fromMap(Map<String, dynamic> map) {
    return ContactDetail(
        id: map['id'] ?? '',
        displayname: map['displayname'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        image: map['image'] ?? Uint8List(100),
    );
  }

}