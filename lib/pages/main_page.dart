import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shippingmall/components/search_text_field.dart';
import '../providers/search_query_provider.dart';
import 'create_item_page.dart';
import 'shopping_page.dart';
import 'cart_item_page.dart';
import 'package:flutter_shippingmall/components/promote_slider.dart';
import '../providers/filtered_item_list_provider.dart';
import 'item_detail_page.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredItemListProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // 검색어와 일치하는 아이템 필터링
    final searchResults = items.where((item) =>
        item.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 메인 컨텐츠
          Column(
            children: [
              Image.network(
                'https://i.imgur.com/baFkWzl.png',
                width: 500,
                height: 200,
              ),
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const SearchTextField(),
              ),
              PromoteSlider(),
              SizedBox(height: 50,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: const Color(0xff4D81F0),
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
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(95, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xff4D81F0),
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(95, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFFEFEFEF),
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
          // 검색 결과 (Stack으로 오버레이)
          if (searchQuery.isNotEmpty && searchResults.isNotEmpty)
            Positioned(
              top: 300,
              left: 16,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final item = searchResults[index];
                      return ListTile(
                        leading: item.imageFile != null
                            ? Image.file(
                          item.imageFile!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : const Icon(Icons.image, size: 50),
                        title: Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetailPage(itemId: item.id),
                            ),
                          ).then((_) {
                            ref.read(searchQueryProvider.notifier).state = '';
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}