import 'dart:io';

class Item {
  final String id;
  final String name;
  final String company_name;
  final double price;
  final String description;
  final File? imageFile;

  Item({
    required this.id,
    required this.name,
    required this.company_name,
    required this.price,
    required this.description,
    this.imageFile,
  });
}