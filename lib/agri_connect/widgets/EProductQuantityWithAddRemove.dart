import 'package:agri_connect/agri_connect/new_utils/ECircularIcon.dart';
import 'package:agri_connect/constants/sizes.dart';
import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class EProductQuantityWithAddRemove extends StatelessWidget {
  const EProductQuantityWithAddRemove({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ECircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: ESizes.md,
          color: EHelperFunctions.isDarkMode(context)
              ? Colors.white
              : Colors.black,
          backgroundColor: EHelperFunctions.isDarkMode(context)
              ? Colors.grey
              : Colors.white,
        ),
        const SizedBox(
          width: ESizes.spaceBtwItems,
        ),
        Text(
          '2',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          width: ESizes.spaceBtwItems,
        ),
        const ECircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: ESizes.md,
          color: Colors.white,
          backgroundColor: Colors.green,
        ),
      ],
    );
  }
}
