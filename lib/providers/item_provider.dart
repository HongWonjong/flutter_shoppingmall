import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/item.dart';

final itemListProvider = StateNotifierProvider<ItemListNotifier, List<Item>>((ref) {
  return ItemListNotifier();
});

class ItemListNotifier extends StateNotifier<List<Item>> {
  ItemListNotifier() : super([]);

  void addItem(String name, double price, String description, File? imageFile) {
    final newItem = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      price: price,
      description: description,
      imageFile: imageFile,
    );
    state = [...state, newItem];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}