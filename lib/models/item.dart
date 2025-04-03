class Item {
  final String id;
  final String name;
  final double price;
  final String description;
  final String? imageUrl;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
  });
}