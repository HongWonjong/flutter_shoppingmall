// 선택된 상품 타입을 관리할 Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemTypeProvider = StateProvider<String>((ref) => "전체"); // 기본값: 전체