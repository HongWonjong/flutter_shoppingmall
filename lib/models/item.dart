import 'dart:io';

class Item {
  final String id;
  final String name;
  final double price;
  final String description;
  final File? imageFile; // 업로드된 이미지 파일

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageFile,
  });
}