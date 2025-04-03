import 'package:flutter/material.dart';
import '../pages/shopping_page.dart';

class PromoSlider extends StatelessWidget {
  const PromoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: PageController(viewportFraction: 0.9),
        children: [
          _buildPromoBanner(
            context,
            '쿠쿠팡팡 봄철 특별 할인전',
            '최대 50% 할인!',
            Colors.blue.shade100,
          ),
          _buildPromoBanner(
            context,
            '해외 직구 최대 50% 할인!',
            '',
            Colors.green.shade100,
          ),
          _buildPromoBanner(
            context,
            '신선 식품 할인중',
            '최대 70%!',
            Colors.red.shade100,
          ),
          _buildPromoBanner(
            context,
            '무료 개발자 나눔 중',
            '제발 데려가 주십시오..',
            Colors.red.shade100,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, String title, String subtitle, Color color) {
    return GestureDetector(
      onTap: () {
        // 배너 클릭 시 ShoppingPage로 이동할 것
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