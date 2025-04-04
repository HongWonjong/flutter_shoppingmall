import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shippingmall/pages/payment_page.dart';
import 'package:intl/intl.dart';
import '../components/custom_app_bar.dart';
import '../providers/cart_provider.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

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
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: Padding(
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
                physics: NeverScrollableScrollPhysics(), 
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return ListTile(
                    leading:
                        cartItem.item.imageFile != null
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
            SizedBox(height: 16),
            Text(
              "최종 결제 금액",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildPriceRow(
              "총 상품 가격",
              NumberFormat(
                "#,###원",
                "ko_KR",
              ).format(ref.watch(cartProvider.notifier).totalPrice),
            ),
            _buildPriceRow("배송비", "0원"),
            _buildPriceRow("쿠팡캐시", "- 0원"),
            Divider(),
            _buildPriceRow(
              "총 결제 금액",
              NumberFormat(
                "#,###원",
                "ko_KR",
              ).format(ref.watch(cartProvider.notifier).totalPrice),
              isBold: true,
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Spacer(),
            Text(
              "개인정보 제3자 제공 동의\n* 개별 판매자가 등록한 마켓플레이스(오픈마켓) 상품에 대한 광고, 주문, 배송 및 환불의 책임은 각 판매자가 부담합니다.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentSuccessDialog(context); // 결제 완료 팝업 띄우기
                },
                child: Text(
                  "결제하기",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
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
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ); 
              },
              child: Text("홈으로 가기", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
