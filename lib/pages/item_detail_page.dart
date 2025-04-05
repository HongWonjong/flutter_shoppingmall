import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../components/custom_app_bar.dart';
import '../models/item.dart';
import '../providers/cart_provider.dart';
import '../providers/item_provider.dart';
import '../pages/cart_item_page.dart'; // 장바구니 페이지 임포트

class ItemDetailPage extends ConsumerWidget {
  final String itemId;

  const ItemDetailPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemListProvider);
    final item = items.firstWhere(
      (item) => item.id == itemId,
      orElse:
          () => Item(
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            item.imageFile != null
                ? Image.file(
                  item.imageFile!,
                  height: 250,
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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: TextStyle(fontSize: 30)),
                    Text(
                      '${NumberFormat("#,###", "ko_KR").format(item.price)}원',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[800],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text('0',
                          style: TextStyle(
                            fontSize: 25
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Icon(Icons.keyboard_arrow_up,
                            size: 30,
                          ),
                          Icon(Icons.keyboard_arrow_down,
                            size: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showQuantityDialog(context, item, ref);
                  //_showQuantityDialog 거치지 않고 바로 장바구니에 추가
                },
                child: Text(
                  '장바니에 추가',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 수량을 입력받는 다이얼로그
  void _showQuantityDialog(BuildContext context, Item item, WidgetRef ref) {
    final TextEditingController quantityController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('장바구니에 추가할 수량을 입력하세요'),
          content: CupertinoTextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            placeholder: '수량 입력',
            padding: EdgeInsets.all(12),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                int quantity = int.tryParse(quantityController.text) ?? 1;
                ref.read(cartProvider.notifier).addToCart(item, quantity);
                Navigator.of(context).pop(); // 다이얼로그 닫기
                _addCartDialog(context); // 장바구니 이동 확인 다이얼로그 띄우기
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // 장바구니로 이동할 것인지 묻는 다이얼로그
  void _addCartDialog(BuildContext context) {
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
              Icon(Icons.shopping_cart, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text(
                "장바구니 담기 완료",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            "장바구니에 해당 품목이 담겼습니다.",
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
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CartItemPage(),
                  ), // 장바구니로 이동
                );
              },
              child: Text("장바구니 이동", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
