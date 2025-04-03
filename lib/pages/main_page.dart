import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/custom_app_bar.dart';
import 'create_item_page.dart';
import 'shopping_page.dart';
import 'cart_item_page.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 150),
          Image.network(
            'https://i.imgur.com/baFkWzl.png',
            width: 500, // 원하는 크기로 조절
            height: 250,
          ),
          const SizedBox(height: 100),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 120),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Color(0xff4D81F0),
              foregroundColor: Colors.white,
              iconSize: 80,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingPage()),
              );
            },
            child: const Icon(Icons.storefront),
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(95, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xff4D81F0),
                  iconSize: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartItemPage(),
                    ),
                  );
                },
                child: const Icon(Icons.shopping_cart),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(95, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color(0xFFEFEFEF),
                  foregroundColor: Colors.grey[700],
                  iconSize: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateItemPage(),
                    ),
                  );
                },
                child: const Icon(Icons.add_business),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
