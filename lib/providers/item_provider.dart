import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/item.dart';

final itemListProvider = StateNotifierProvider<ItemListNotifier, List<Item>>((ref) {
  return ItemListNotifier();
});

class ItemListNotifier extends StateNotifier<List<Item>> {
  ItemListNotifier() : super([
    //기초적인 아이템 리스트를 super 매개변수로 전달한다.
    Item(
      id: '1',
      name: '개발자(무료)',
      company_name: "스파르타 코딩 클럽",
      price: 0.0,
      description: '열정으로 가득한 무료 개발자',
      imageFile: null, // 초기에는 이미지 없음
    ),
    Item(
      id: '2',
      name: '이베리코 삼겹살',
      company_name: "(주) 믿고 먹는 우리 한돈",
      price: 25.0,
      description: '스페인산 고급 이베리코 돼지의 삼겹살',
      imageFile: null, // 초기에는 이미지 없음
    ),
    Item(
      id: '3',
      name: '요구르트',
      company_name: "(주) 야쿠르트",
      price: 1.0,
      description: '유산균 100억마리 포함',
      imageFile: null, // 초기에는 이미지 없음
    ),
    Item(
      id: '4',
      name: '치즈 햄부기',
      company_name: "(주) 햄부기킹",
      price: 2.5,
      description: '100% 자연산 치즈와 신선한 호주산 쇠고기 패티의 조합',
      imageFile: null, // 초기에는 이미지 없음
    ),
    Item(
      id: '5',
      name: '크림빵',
      company_name: "(주) 3립",
      price: 1.7,
      description: '그 시절 그 맛',
      imageFile: null, // 초기에는 이미지 없음
    ),
  ]);
// 아이템 등록 페이지에서 사용하며, 새로운 아이템을 아이템 리스트에 추가한다.
  void addItem(String name, String company_name, double price, String description, File? imageFile) {
    final newItem = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      company_name: company_name,
      price: price,
      description: description,
      imageFile: imageFile,
    );

    state = [...state, newItem];
    // ...state의 의미는 현재 state의 모든 요소를 새로운 리스트에 복사한다는 의미이다.
    // 그리고 여기에 추가로 새로운 아이템 newItem객체를 추가한다.
  }
// 선택한 id의 아이템을 아이템 리스트에서 제거한다.
  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}