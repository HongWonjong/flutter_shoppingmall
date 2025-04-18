import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';
import '../providers/item_provider.dart';
import '../models/cart_item.dart'; // 필요 시 직접 경로 수정

class PaymentPage extends ConsumerWidget {
  final bool isDirectBuy;
  final CartItem? directBuyItem;

  const PaymentPage({
    super.key,
    this.isDirectBuy = false,
    this.directBuyItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = isDirectBuy && directBuyItem != null
        ? [directBuyItem!]
        : ref.watch(cartProvider);

    final selectedCoupon = ref.watch(couponProvider);
    final totalPrice = isDirectBuy && directBuyItem != null
        ? directBuyItem!.item.price * directBuyItem!.quantity
        : ref.watch(cartProvider.notifier).totalPrice;

    final discount = _getCouponDiscount(selectedCoupon);
    final finalPrice = (totalPrice - discount).clamp(0, double.infinity).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "주문/결제",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "배송 1건",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(12),
                child: ListView.builder(
                  shrinkWrap: true,
                  //physics: NeverScrollableScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return ListTile(
                      leading: cartItem.item.imageFile != null
                          ? Image.file(
                              cartItem.item.imageFile!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 50),
                      title: Text(cartItem.item.name),
                      subtitle: Text(
                        '가격: ${NumberFormat("#,###", "ko_KR").format(cartItem.item.price * cartItem.quantity)}원',
                      ),
                      trailing: Text(
                        '수량: ${cartItem.quantity}',
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 222, 230, 236),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCoupon == '쿠폰 선택' ? null : selectedCoupon,
                    hint: const Text('쿠폰 선택'),
                    items: <String>[
                      '쿠폰선택',
                      '가입 기념 1000원 할인',
                      '가입 기념 2000원 할인',
                      '가입 기념 3000원 할인',
                      '가입 기념 5000원 할인',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      ref.read(couponProvider.notifier).state = newValue!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "최종 결제 금액",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildPriceRow(
                "총 상품 가격",
                NumberFormat("#,###원", "ko_KR").format(totalPrice),
              ),
              _buildPriceRow("배송비", "0원"),
              _buildPriceRow("쿠팡캐시", "- 0원"),
              _buildPriceRow(
                "쿠폰 할인",
                "-${NumberFormat("#,###원", "ko_KR").format(discount)}",
              ),
              Divider(),
              _buildPriceRow(
                "총 결제 금액",
                NumberFormat("#,###원", "ko_KR").format(finalPrice),
                isBold: true,
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              //Spacer(),
              Text(
                "개인정보 제3자 제공 동의\n* 개별 판매자가 등록한 마켓플레이스(오픈마켓) 상품에 대한 광고, 주문, 배송 및 환불의 책임은 각 판매자가 부담합니다.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showPaymentSuccessDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "결제하기",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext context) {
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
                "결제 완료!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            "주문 상세 내역은 마이페이지에서 확인할 수 있습니다.",
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
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text("홈으로 가기", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  int _getCouponDiscount(String coupon) {
    switch (coupon) {
      case '가입 기념 1000원 할인':
        return 1000;
      case '가입 기념 2000원 할인':
        return 2000;
      case '가입 기념 3000원 할인':
        return 3000;
      case '가입 기념 5000원 할인':
        return 5000;
      default:
        return 0;
    }
  }
}
