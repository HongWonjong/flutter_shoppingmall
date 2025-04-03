import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/custom_app_bar.dart';
import '../components/promote_slider.dart'; // PromoSlider 임포트
import 'create_item_page.dart';
import 'shopping_page.dart';
import 'cart_item_page.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: '메인 페이지'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PromoSlider(), // PromoSlider 컴포넌트 사용
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateItemPage()),
                );
              },
              child: const Text('아이템 등록 페이지로 이동'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShoppingPage()),
                );
              },
              child: const Text('쇼핑 페이지로 이동'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartItemPage()),
                );
              },
              child: const Text('장바구니 페이지로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}