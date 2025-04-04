import 'package:flutter/material.dart';
import '../pages/shopping_page.dart'; // ShoppingPage 임포트

class PromoteSlider extends StatelessWidget {
  const PromoteSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220, // 약간 더 높여서 여유롭게
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.93),
        itemCount: 4, // 배너 개수
        itemBuilder: (context, index) {
          return _buildPromoBanner(context, index);
        },
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, int index) {
    // 배너별 데이터 정의
    final List<Map<String, dynamic>> banners = [
      {
        'title': '특별 할인전',
        'subtitle': '최대 50% 할인!',
        'gradient': LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'icon': Icons.discount,
      },
      {
        'title': '추천 상품',
        'subtitle': '지금 뜨는 아이템',
        'gradient': LinearGradient(
          colors: [Colors.green.shade400, Colors.teal.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'icon': Icons.trending_up,
      },
      {
        'title': '한정 세일',
        'subtitle': '오늘만 특가!',
        'gradient': LinearGradient(
          colors: [Colors.red.shade400, Colors.deepOrange.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'icon': Icons.timer,
      },
      {
        'title': '개발자 데려가기',
        'subtitle': '1개월 사용 무료!',
        'gradient': LinearGradient(
          colors: [Colors.blueAccent.shade400, Colors.deepOrange.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'icon': Icons.accessibility_sharp,
      },
    ];

    final banner = banners[index];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShoppingPage()),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          gradient: banner['gradient'],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 콘텐츠
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    banner['icon'],
                    size: 40,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    banner['title'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    banner['subtitle'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // CTA 버튼 추가
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '지금 확인하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}