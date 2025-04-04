import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      orElse: () => Item(
        id: '',
        name: '아이템 없음',
        company_name: "이름 없음",
        price: 0.0,
        description: '해당 아이템을 찾을 수 없습니다.',
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(title: item.name),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
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
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '이름: ${item.name}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('가격: \$${item.price}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    '설명: ${item.description}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            BottomAppBar(
              color: const Color(0xFFEFEFEF),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showQuantityDialog(context, item, ref);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D81F0),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('장바구니에 추가'),
                    ),
                  ],
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
                _showNavigateToCartDialog(context); // 장바구니 이동 확인 다이얼로그 띄우기
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // 장바구니로 이동할 것인지 묻는 다이얼로그
  void _showNavigateToCartDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('장바구니로 이동하시겠습니까?'),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CartItemPage()), // 장바구니로 이동
                );
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}