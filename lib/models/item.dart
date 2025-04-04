import 'dart:io';

// ItemType enum 정의
enum ItemType {
  food,
  clothing,
  appliance,
  None,
}

class Item {
  final String id;
  final String name;
  final String company_name;
  final double price;
  final String description;
  final File? imageFile;
  final ItemType item_type; // String? 대신 ItemType? 사용

  Item({
    required this.id,
    required this.name,
    required this.company_name,
    required this.price,
    required this.description,
    this.imageFile,
    required this.item_type, // null 허용하므로 여전히 optional
  });
}