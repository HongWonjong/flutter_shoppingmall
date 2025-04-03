import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/item.dart';

final itemListProvider = StateNotifierProvider<ItemListNotifier, List<Item>>((ref) {
  return ItemListNotifier();
});

class ItemListNotifier extends StateNotifier<List<Item>> {
  ItemListNotifier() : super([
    Item(
      id: '1',
      name: '개발자(무료)',
      price: 0.0,
      description: '열정으로 가득한 무료 개발자',
      imageFile: null, // 초기에는 이미지 없음
    ),
    Item(
      id: '2',
      name: '이베리코 삼겹살',
      price: 25.0,
      description: '스페인산 고급 이베리코 돼지의 삼겹살',
      imageFile: null, // 초기에는 이미지 없음
    ),
  ]);

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