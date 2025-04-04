import 'package:flutter/cupertino.dart';
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

    return Scaffold(
      appBar: const CustomAppBar(title: '장바구니'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return Column(
                  children: [
                    ListTile(//'${NumberFormat("#,###", "ko_KR").format(cartItem.item.price * cartItem.quantity)}원'
                      leading: cartItem.item.imageFile != null
                          ? Image.file(cartItem.item.imageFile!, width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image, size: 50),
                      title: Text(cartItem.item.name),
                      subtitle: Text('가격: ${NumberFormat("#,###", "ko_KR").format(cartItem.item.price * cartItem.quantity)}원'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              ref.read(cartProvider.notifier).updateQuantity(
                                cartItem.item.id,
                                cartItem.quantity + 1,
                              );
                            },
                          ),
                          Text('${cartItem.quantity}',style: TextStyle(fontSize: 18),),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              ref.read(cartProvider.notifier).updateQuantity(
                                cartItem.item.id,
                                cartItem.quantity - 1,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                  ],
                );
              },
            ),
          ),
          BottomAppBar(
            color: const Color(0xFFEFEFEF),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '개수:${ref.watch(cartProvider.notifier).totalQuantity}개   총액: ${NumberFormat("#,###", "ko_KR").format(ref.watch(cartProvider.notifier).totalPrice)}원',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(onPressed: () {
                    showCupertinoDialog(context: context, builder: (context){
                      return CupertinoAlertDialog(
                        title: Text('구매하시겠습니까?'),
                        content: Text('${ref.watch(cartProvider.notifier).totalQuantity}개 총합 ${NumberFormat("#,###", "ko_KR").format(ref.watch(cartProvider.notifier).totalPrice)}원'),
                        actions: [CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: (){Navigator.of(context).pop();
                          },
                          child: Text('취소'),
                        ),
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: (){
                            Navigator.of(context).pop();
                            _showCartSuccessDialog(context); // 결제 완료 팝업 띄우기
                
                child: Text(
                  "결제하기",);
                            
                          },
                          child: Text('구매'),
                        )],
                      );});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D81F0),
                    foregroundColor: Colors.white
                  ),child: const Text('구매하기'),),
                ],
              ),
            ),
          ),
        ],
      ),
    );  
  }
  void _showCartSuccessDialog(BuildContext context) {
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