import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shippingmall/function/get_item_type_text.dart';
import 'package:flutter_shippingmall/pages/cart_item_page.dart';
import '../providers/item_provider.dart';
import 'item_detail_page.dart';
import 'package:intl/intl.dart';

// 검색어 상태 관리 (검색어를 저장할 StateProvider 추가)
final searchQueryProvider = StateProvider<String>((ref) => "");

// 검색어를 반영한 필터링된 아이템 리스트 Provider 생성
final filteredItemListProvider = Provider((ref) {
  final query =
      ref.watch(searchQueryProvider).toLowerCase(); // 검색어를 가져오고 소문자로 변환
  final items = ref.watch(itemListProvider); // 전체 아이템 목록을 가져옴
  if (query.isEmpty) return items; // 검색어가 없으면 전체 아이템 반환

  return items
      .where((item) => item.name.toLowerCase().contains(query))
      .toList();
  // 아이템 이름에 검색어가 포함된 것만 반환
});

class ShoppingPage extends ConsumerWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(
      filteredItemListProvider,
    ); // 필터링된 아이템 목록을 감시하여 가져오기

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 300,
          height: 38,
          child: TextField(
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state =
                  value; // 검색어 변경 시 상태 업데이트
            },
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              hintText: '찾고 싶은 상품을 검색해보세요!',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF4D81F0), width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF4D81F0), width: 3),
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFFEFEFEF),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartItemPage()),
              );
            },
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: 40,
              color: Colors.black,
            ),
            splashRadius: 24,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailPage(itemId: item.id),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.imageFile != null)
                    SizedBox(
                      width: 190,
                      height: 190,
                      child: Image.file(item.imageFile!, fit: BoxFit.cover),
                    )
                  else
                    const Icon(Icons.image, size: 200),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 185,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: TextStyle(fontSize: 20)),
                          Text(
                            item.price == 0
                                ? '무료'
                                : '${NumberFormat("#,###", "ko_KR").format(item.price)}원',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item.company_name,
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 10),
                          Text(
                            item.description,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              getItemTypeText(item),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
