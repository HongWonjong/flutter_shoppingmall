import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/custom_app_bar.dart';
import '../models/item.dart';
import '../providers/cart_provider.dart';
import '../providers/item_provider.dart';

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
        price: 0.0,
        description: '해당 아이템을 찾을 수 없습니다.',
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(title: item.name),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.imageFile != null
                ? Image.file(item.imageFile!, height: 200, width: double.infinity, fit: BoxFit.cover)
                : Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Text('이미지 없음')),
            ),
            const SizedBox(height: 16),
            Text('이름: ${item.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('가격: \$${item.price}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('설명: ${item.description}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(cartProvider.notifier).addToCart(item, 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('장바구니에 추가되었습니다')),
                );
              },
              child: const Text('장바구니에 추가'),
            ),
          ],
        ),
      ),
    );
  }
}