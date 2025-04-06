import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../components/custom_app_bar.dart';
import '../models/item.dart';
import '../providers/cart_provider.dart';
import '../providers/item_provider.dart';
import '../pages/cart_item_page.dart';

class ItemDetailPage extends ConsumerStatefulWidget {
  final String itemId;

  const ItemDetailPage({super.key, required this.itemId});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends ConsumerState<ItemDetailPage> {
  int count = 1;
  
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemListProvider);
    final item = items.firstWhere(
      (item) => item.id == widget.itemId,
      orElse: () => Item(
        id: '',
        name: '아이템 없음',
        company_name: "이름 없음",
        price: 0.0,
        description: '해당 아이템을 찾을 수 없습니다.',
        item_type: ItemType.None,
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(title: item.name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.imageFile != null
                ? Image.file(
                    item.imageFile!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text('이미지 없음')),
                  ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${NumberFormat("#,###", "ko_KR").format(item.price)}원',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '$count',
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade600),
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      count++;
                                    });
                                  },
                                  child: Icon(Icons.keyboard_arrow_up, size: 22),
                                ),
                                Container(
                                  color: Colors.grey[500],
                                  width: 30,
                                  height: 1,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (count > 1) {
                                      setState(() {
                                        count--;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 22,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(item.description, style: const TextStyle(fontSize: 18)),

            // 👇 여기부터 추천 상품 리스트 추가
            SizedBox(height: 20),
            Text(
              '이런 상품은 어때요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: items
                    .where((i) =>
                        i.item_type == item.item_type && i.id != item.id)
                    .map((relatedItem) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItemDetailPage(itemId: relatedItem.id),
                        ),
                      );
                    },
                    child: Container(
                      width: 120,
                      margin: EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          relatedItem.imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    relatedItem.imageFile!,
                                    width: 120,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  width: 120,
                                  height: 90,
                                  color: Colors.grey[300],
                                  child: Center(child: Text('이미지 없음')),
                                ),
                          SizedBox(height: 8),
                          Text(
                            relatedItem.name,
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${NumberFormat("#,###", "ko_KR").format(relatedItem.price)}원',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // 👆 추천 상품 리스트 끝
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            ref.watch(cartProvider.notifier).addToCart(item, count);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 60),
                      SizedBox(height: 10),
                      Text(
                        "상품이 장바구니에 담겼습니다.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    "주문 상세 내역은 장바구니에서 확인할 수 있습니다.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("확인", style: TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartItemPage(),
                          ),
                        );
                      },
                      child: Text(
                        "장바구니로 가기",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            "장바구니 담기",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
