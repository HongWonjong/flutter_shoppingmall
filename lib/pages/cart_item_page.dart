import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shippingmall/pages/payment_page.dart';
import 'package:intl/intl.dart';
import '../components/custom_app_bar.dart';
import '../providers/cart_provider.dart';

class CartItemPage extends ConsumerWidget {
  const CartItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    DateTime tomorrow = DateTime.now().add(Duration(days: 1)); // 내일 날짜
    List<String> weekDays = ["월", "화", "수", "목", "금", "토", "일"];

    String tomorrowWeekday = weekDays[tomorrow.weekday - 1];

    return Scaffold(
      appBar: const CustomAppBar(title: '장바구니'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      cartItem.item.imageFile != null
                          ? Image.file(
                            cartItem.item.imageFile!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                          : const Icon(Icons.image, size: 100),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.item.name,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            width: 150,
                            child: Text(
                              cartItem.item.description,
                              style: TextStyle(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '내일($tomorrowWeekday) 도착 보장',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green[800],
                            ),
                          ),
                          Text(
                            '${NumberFormat("#,###", "ko_KR").format(cartItem.item.price * cartItem.quantity)}원',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref
                                  .watch(cartProvider.notifier)
                                  .removeFromCart(cartItem.item.id);
                            },
                            child: Icon(Icons.close),
                          ),
                          SizedBox(height: 40),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .watch(cartProvider.notifier)
                                        .updateQuantity(
                                          cartItem.item.id,
                                          cartItem.quantity - 1,
                                        );
                                  },
                                  child: Icon(Icons.remove, size: 30),
                                ),
                                Text('${cartItem.quantity}'),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .watch(cartProvider.notifier)
                                        .updateQuantity(
                                          cartItem.item.id,
                                          cartItem.quantity + 1,
                                        );
                                  },
                                  child: Icon(Icons.add, size: 30),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _goToPayment(context); // 결제 완료 팝업 띄우기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "총 ${ref.watch(cartProvider.notifier).totalQuantity}개 상품 구매하기",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToPayment(BuildContext context) {
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
              Icon(Icons.card_membership, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text(
                "결제 진행",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            "결제 페이지에서 결제를 진행합니다.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("취소", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PaymentPage(),
                  ), // 장바구니로 이동
                );
              },
              child: Text("확인", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
