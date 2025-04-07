// 검색어 및 상품 타입을 반영한 필터링된 아이템 리스트 Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shippingmall/providers/search_query_provider.dart';

import '../function/get_item_type_text.dart';
import '../pages/shopping_page.dart';
import 'item_provider.dart';
import 'item_type_provider.dart';

final filteredItemListProvider = Provider((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase(); // 검색어 가져오기
  final selectedType = ref.watch(itemTypeProvider); // 선택된 상품 타입 가져오기
  final items = ref.watch(itemListProvider); // 전체 아이템 목록 가져오기

  // 검색어 필터링
  var filteredItems =
  query.isEmpty
      ? items
      : items
      .where((item) => item.name.toLowerCase().contains(query))
      .toList();

  // 상품 타입 필터링 (전체 선택 시 모든 상품 포함)
  if (selectedType != "전체") {
    filteredItems =
        filteredItems.where((item) {
          final itemType = getItemTypeText(item); // 상품 타입 가져오기
          return itemType == selectedType; // 필터링 조건 적용
        }).toList();
  }
  return filteredItems;
});