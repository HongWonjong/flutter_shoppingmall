import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../components/custom_app_bar.dart';
import '../providers/item_provider.dart';
import 'item_detail_page.dart';

class ShoppingPage extends ConsumerWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemListProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: '쇼핑 페이지'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              leading: item.imageFile != null
                  ? Image.file(item.imageFile!, width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 50),
              title: Text(item.name),
              subtitle: Text('가격: \$${item.price}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailPage(itemId: item.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}