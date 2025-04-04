import 'package:flutter/material.dart';
import '../pages/shopping_page.dart'; // ShoppingPage 임포트

class PromoteSlider extends StatelessWidget {
  const PromoteSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // 배너 높이 설정
      child: PageView(
        controller: PageController(viewportFraction: 0.9),
        children: [
          _buildPromoBanner(
            context,
            '특별 할인전',
            '최대 50% 할인!',
            Colors.blue.shade100,
          ),
          _buildPromoBanner(
            context,
            '추천 상품',
            '지금 뜨는 아이템',
            Colors.green.shade100,
          ),
          _buildPromoBanner(
            context,
            '한정 세일',
            '오늘만 특가!',
            Colors.red.shade100,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, String title, String subtitle, Color color) {
    return GestureDetector(
      onTap: () {
        // 배너 클릭 시 ShoppingPage로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShoppingPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}