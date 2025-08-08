import 'package:agri_connect/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'home_container.dart';

class Analysis_box extends StatelessWidget {
  const Analysis_box({
    super.key,
    required this.title,
    this.subTitle,
    required this.icon,
  });

  final String title;
  final String? subTitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ReusableContainer(
      height: 100,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(ESizes.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: Colors.white54),
                const SizedBox(width: 2),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ESizes.spaceBtwItems),
            subTitle != null && subTitle!.isNotEmpty
                ? Text(
              subTitle!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            )
                : Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.green[300]!,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                        color: Colors.grey
                    ),
                  ),
                 const SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey
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
