import 'package:agri_connect/agri_connect/new_utils/EBrandTitleText.dart';
import 'package:agri_connect/agri_connect/new_utils/TextSizes.dart';
import 'package:agri_connect/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class EBrandTitleWithVerifiedIcon extends StatelessWidget {
  const EBrandTitleWithVerifiedIcon({
    super.key,
    this.textColor,
    this.maxLines = 1,
    required this.title,
    this.iconColor = Colors.green,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor, iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
    Flexible(
    child: EBrandTitleText(
    title: title,
      color: textColor,
      maxLines: maxLines,
      textAlign: textAlign,
      brandTextSize: brandTextSize,
    ),
    ),
    const SizedBox(width: ESizes.xs),
    Icon(Iconsax.verify5, color: iconColor, size: ESizes.iconSm),
   ]);
    }
}