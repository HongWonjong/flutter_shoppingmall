import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';
import '../models/cart_item.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

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

  int get totalQuantity => state.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => state.fold(
    0,
        (sum, cartItem) => sum + (cartItem.item.price * cartItem.quantity),
  );
}