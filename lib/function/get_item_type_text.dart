import '../models/item.dart';

String getItemTypeText(Item item) {
  if (item.item_type == ItemType.food) {
    return "음식";
  } else if (item.item_type == ItemType.appliance) {
    return "가전제품";
  } else if (item.item_type == ItemType.clothing) {
    return "의류";
  } else if (item.item_type == ItemType.None) {
    return "기타";
  } else {
    return "알 수 없음"; // 안전을 위해 기본값 추가
  }
}