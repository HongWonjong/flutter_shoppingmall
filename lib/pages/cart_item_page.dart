import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                    ListTile(
                      leading: cartItem.item.imageFile != null
                          ? Image.file(cartItem.item.imageFile!, width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image, size: 50),
                      title: Text(cartItem.item.name),
                      subtitle: Text('가격: ${(cartItem.item.price * cartItem.quantity).toInt()}원'),
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
                    '개수:${ref.watch(cartProvider.notifier).totalQuantity}개   총액: ${ref.watch(cartProvider.notifier).totalPrice.toInt()}원',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(onPressed: () {
                    showCupertinoDialog(context: context, builder: (context){
                      return CupertinoAlertDialog(
                        title: Text('구매하시겠습니까?'),
                        content: Text('${ref.watch(cartProvider.notifier).totalQuantity}개 총합 ${ref.watch(cartProvider.notifier).totalPrice.toInt()}원'),
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
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text('결제 진행'),
                                  content: Text('결제 화면으로 이동합니다.'),
                                  actions: [
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.of(
                                          context,
                                        ).pop(); // 성공 메시지 닫기
                                      },
                                      child: Text('이동'),
                                    ),
                                  ],
                                );
                              },
                            );
                            
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
}