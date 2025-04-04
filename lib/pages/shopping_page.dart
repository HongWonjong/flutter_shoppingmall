import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailPage(itemId: item.id),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(horizontal: BorderSide(
                  color: Colors.grey.shade300
                ))
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.imageFile != null)
                    SizedBox(
                      width: 190,
                      height: 190,
                      child: Image.file(item.imageFile!, fit: BoxFit.cover),
                    )
                  else
                    const Icon(Icons.image, size: 200),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: TextStyle(fontSize: 20)),
                        Text(
                          item.price == 0.0 ? '무료' : '\$${item.price}',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(item.company_name,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(item.description),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
