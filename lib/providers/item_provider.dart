import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';

final itemListProvider = StateNotifierProvider<ItemListNotifier, List<Item>>((ref) {
  return ItemListNotifier();
});

class ItemListNotifier extends StateNotifier<List<Item>> {
  ItemListNotifier() : super([]);

  void addItem(String name, double price, String description, int stock, [String? imageUrl]) {
    final newItem = Item(
      id: DateTime.now().toString(),
      name: name,
      price: price,
      description: description,
      imageUrl: imageUrl,
    );
    state = [...state, newItem];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}