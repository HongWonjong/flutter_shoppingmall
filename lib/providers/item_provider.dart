import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle; // rootBundle 사용
import 'package:path_provider/path_provider.dart'; // 임시 디렉토리 사용
import '../models/item.dart';

final itemListProvider = StateNotifierProvider<ItemListNotifier, List<Item>>((ref) {
  return ItemListNotifier();
});

class ItemListNotifier extends StateNotifier<List<Item>> {
  ItemListNotifier() : super([]) {
    _initializeItems();
  }

  // 초기 아이템 리스트를 생성하는 비동기 메서드
  Future<void> _initializeItems() async {
    state = [
      Item(
        id: '1',
        name: '개발자(무료)',
        company_name: "스파르타 코딩 클럽",
        price: 0,
        description: '열정으로 가득한 무료 개발자',
        imageFile: await _assetToFile('assets/developer.png'),
        item_type: ItemType.None,
      ),
      Item(
        id: '2',
        name: '이베리코 삼겹살',
        company_name: "(주) 믿고 먹는 우리 한돈",
        price: 25000,
        description: '스페인산 고급 이베리코 돼지의 삼겹살',
        imageFile: await _assetToFile('assets/iberico_pork.png'),
        item_type: ItemType.food,
      ),
      Item(
        id: '3',
        name: '요구르트',
        company_name: "(주) 야쿠르트",
        price: 1000,
        description: '유산균 100억마리 포함',
        imageFile: await _assetToFile('assets/yogurt.png'),
        item_type: ItemType.food,
      ),
      Item(
        id: '4',
        name: '치즈 햄부기',
        company_name: "(주) 햄부기킹",
        price: 25000,
        description: '100% 자연산 치즈와 신선한 호주산 쇠고기 패티의 조합',
        imageFile: await _assetToFile('assets/cheese_hamburger.png'),
        item_type: ItemType.food,
      ),
      Item(
        id: '5',
        name: '크림빵',
        company_name: "(주) 3립",
        price: 1700,
        description: '그 시절 그 맛',
        imageFile: await _assetToFile('assets/cream_bread.png'),
        item_type: ItemType.food,
      ),
      Item(
        id: '6',
        name: 'LG Dios 냉장고',
        company_name: "LG",
        price: 1300000,
        description: '효율적인 냉방 기능을 탑재한 신형 냉장고',
        imageFile: await _assetToFile('assets/lg_dios_refrigerator.png'),
        item_type: ItemType.appliance,
      ),
      Item(
        id: '7',
        name: '엘지 안마의자',
        company_name: "LG",
        price: 1400000,
        description: '효도의 최첨단',
        imageFile: await _assetToFile('assets/lg_massage_chair.png'),
        item_type: ItemType.appliance,
      ),
      Item(
        id: '8',
        name: '마크 앤 로나 집업 후드',
        company_name: "MARK & LONA",
        price: 780000,
        description: '고급진 안감과 고급진 아무튼 무언가',
        imageFile: await _assetToFile('assets/mark_and_lona.png'),
        item_type: ItemType.clothing,
      ),
      Item(
        id: '9',
        name: '무지 후드티',
        company_name: "보세",
        price: 25000,
        description: '단색의 후드 티',
        imageFile: await _assetToFile('assets/muji_hood.png'),
        item_type: ItemType.clothing,
      ),
    ];
  }

  // assets 이미지를 File로 변환하는 메서드
  Future<File> _assetToFile(String assetPath) async {
    // assets에서 이미지 데이터 읽기
    final byteData = await rootBundle.load(assetPath);
    // 임시 디렉토리 경로 가져오기
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/${assetPath.split('/').last}';
    // File 객체 생성 및 데이터 쓰기
    final file = File(filePath);
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  void addItem(String name, String companyName, double price, String description, File? imageFile, ItemType itemType) {
    final newItem = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      company_name: companyName,
      price: price,
      description: description,
      imageFile: imageFile,
      item_type: itemType,
    );
    state = [...state, newItem];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}
final couponProvider = StateProvider<String>((ref) => '쿠폰 선택');
