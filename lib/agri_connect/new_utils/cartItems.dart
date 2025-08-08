
import 'package:agri_connect/agri_connect/new_utils/EProductPriceText.dart';
import 'package:agri_connect/agri_connect/new_utils/cartItem.dart';
import 'package:agri_connect/agri_connect/widgets/EProductQuantityWithAddRemove.dart';
import 'package:agri_connect/constants/sizes.dart';
import 'package:flutter/material.dart';


class ECartItems extends StatelessWidget {
  const ECartItems({super.key, this.showAddRemoveButtons = true});

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) => const SizedBox(
        height: ESizes.spaceBtwSections,
      ),
      itemCount: 2,
      itemBuilder: (_, index) => Column(
        children: [
          // Cart Item
          const ECartItem(),
          if (showAddRemoveButtons)
            const SizedBox(
              height: ESizes.spaceBtwItems,
            ),

          if (showAddRemoveButtons)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Extra Space
                    SizedBox(
                      width: 70,
                    ),
                    // Add Remove Buttons
                    EProductQuantityWithAddRemove(),
                  ],
                ),

                // --Product Price
                EProductPriceText(price: '149'),
              ],
            )
        ],
      ),
    );
  }
}