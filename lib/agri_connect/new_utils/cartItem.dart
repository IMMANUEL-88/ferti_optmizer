import 'package:agri_connect/agri_connect/new_utils/EBrandTitleWithVerifiedIcon.dart';
import 'package:agri_connect/agri_connect/new_utils/ERoundedImage.dart';
import 'package:agri_connect/constants/image_strings.dart';
import 'package:agri_connect/constants/sizes.dart';
import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
class ECartItem extends StatelessWidget {
  const ECartItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // --Image--
        ERoundedImage(
          imageUrl: EImages.broccoli,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(ESizes.sm),
          backgroundColor: EHelperFunctions.isDarkMode(context)
              ? Colors.grey
              : Colors.white,
        ),
        const SizedBox(
          width: ESizes.spaceBtwItems,
        ),

        // Title, Price And Size
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EBrandTitleWithVerifiedIcon(title: 'AgroFarm'),
              const Flexible(
                child: Text(
                  'Fresh Broccoli',
                  maxLines: 2,
                ),
              ),

              // Attributes
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'Harvest Date ',
                        style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(
                        text: '11th September 2001 ',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}