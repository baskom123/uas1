import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  String name;
  String img;
  double harga;
  double rate;
  String desk;

  Menu({
    required this.name,
    required this.img,
    required this.harga,
    required this.rate,
    required this.desk,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'img': img,
      'harga': harga,
      'rating': rate,
      'deskripsi': desk,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      name: map['name'] as String,
      img: map['img'] as String,
      harga: map['harga'] as double,
      rate: map['rating'] as double,
      desk: map['deskripsi'] as String,
    );
  }

  static fromDocSnapShot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
}
