import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';
import '../models/cart_item.dart';

//카트 프로바이더는 카트 아이템 리스트를 관리하는 카트 노티파이어를 전역적으로 사용 가능하게 한다.
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// 카트 노티파이어는 자신이 관리하는 카트 아이템 리스트들에 접근하려는 사용자들의 읽기-쓰기 요청을 다양한 메서드를 통해 수행한다.
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);
  // 매개변수로 받은 아이템의 Item 객체와 수량을 이용해 카트 아이템 객체를 생성하고, 이를 카트 아이템 리스트에 추가한다.
  //...state의 의미는 현재 state의 모든 요소를 새로운 리스트에 복사한다는 의미이다.
  // 즉 카트 아이템 리스트에 새로운 카트 아이템을 추가하기 위해 기존의 카트 아이템 리스트를 복사하고, 여기에 새로운 카트 아이템을 추가한다.
  void addToCart(Item item, int quantity) {
    final existingIndex = state.indexWhere((cartItem) => cartItem.item.id == item.id);
    if (existingIndex >= 0) {
      state[existingIndex].quantity += quantity;
      state = [...state];
    } else {
      state = [...state, CartItem(item: item, quantity: quantity)];
    }
  }
// 매개변수로 받은 아이템의 아이디를 이용해 카트 아이템 리스트에서 해당 아이템을 제거한다.
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

  // 장바구니에서 총액 수량을 계산할 때 사용하는 게터다.
  //state.fold는 리스트의 각 요소를 순회하면서 누적 값을 계산한다. 초기값은 0이고, 각 요소에 대해 누적 값을 계산한다.
  // 여기서 sum은 누적 값이고, cartItem은 현재 처리 중인 카트 아이템이다.
  int get totalQuantity => state.fold(0, (sum, item) => sum + item.quantity);  

  double get totalPrice => state.fold(
    0,
        (sum, cartItem) => sum + (cartItem.item.price * cartItem.quantity),
  );
}