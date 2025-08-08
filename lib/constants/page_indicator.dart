import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  Widget _buildDottedLineIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pageCount, (int index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: currentPage == index ? 12.0 : 8.0,
            height: currentPage == index ? 12.0 : 8.0,
            decoration: BoxDecoration(
              color: currentPage == index
                  ? Theme.of(context).colorScheme.primary
                  : Colors.orange,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDottedLineIndicator(context);
  }
}
