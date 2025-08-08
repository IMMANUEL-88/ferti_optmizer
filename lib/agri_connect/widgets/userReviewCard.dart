
import 'package:agri_connect/agri_connect/widgets/ratingBarIndicator.dart';
import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../constants/image_strings.dart';
import '../../constants/sizes.dart';
import '../new_utils/roundedContainer.dart';



class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(EImages.ad1),
                ),
                const SizedBox(
                  width: ESizes.spaceBtwItems,
                ),
                Text(
                  'Ben Dover',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        const SizedBox(
          height: ESizes.spaceBtwItems,
        ),

        //Review
        Row(
          children: [
            const ERatingBarIndicator(rating: 4),
            Text(
              '01 JUN 2024',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(
          height: ESizes.spaceBtwItems,
        ),
        const ReadMoreText(
          'The broccoli was fresh and delicious, but the packaging could be improved. Some of the stalks were slightly damaged.',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: ' show less',
          trimCollapsedText: ' show more',
          moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green),
          lessStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green),
        ),
        const SizedBox(
          height: ESizes.spaceBtwItems,
        ),

        // --Company Review--
        ERoundedContainer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(ESizes.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'IAJ Store',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '14 JUN 2024',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: ESizes.spaceBtwItems,
                ),
                const ReadMoreText(
                  'Thank you for your feedback! We\'re glad you enjoyed the freshness of our broccoli. We sincerely apologize for the packaging issue and will work to improve it for future deliveries. Your satisfaction is important to us!',
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: ' show less',
                  trimCollapsedText: ' show more',
                  moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  lessStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: ESizes.spaceBtwSections,
        ),
      ],
    );
  }
}