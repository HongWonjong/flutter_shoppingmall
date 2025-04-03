import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';
import '../models/cart_item.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([
    CartItem(
      item: Item(
        id: '1',
        name: '바게트',
        price: 3.5,
        description: '신선한 프랑스식 바게트',
      ),
      quantity: 1,
    ),
    CartItem(
      item: Item(
        id: '2',
        name: '스팸',
        price: 2.0,
        description: '클래식 스팸 통조림',
      ),
      quantity: 1,
    ),
  ]);

  void addToCart(Item item, int quantity) {
    final existingIndex = state.indexWhere((cartItem) => cartItem.item.id == item.id);
    if (existingIndex >= 0) {
      state[existingIndex].quantity += quantity;
      state = [...state];
    } else {
      state = [...state, CartItem(item: item, quantity: quantity)];
    }
  }

  void removeFromCart(String itemId) {
    state = state.where((cartItem) => cartItem.item.id != itemId).toList();
  }

  void updateQuantity(String itemId, int newQuantity) {
    final index = state.indexWhere((cartItem) => cartItem.item.id == itemId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        removeFromCart(itemId);
      } else {
        state[index].quantity = newQuantity;
        state = [...state];
      }
    }
  }

  double get totalPrice => state.fold(
    0,
        (sum, cartItem) => sum + (cartItem.item.price * cartItem.quantity),
  );
}