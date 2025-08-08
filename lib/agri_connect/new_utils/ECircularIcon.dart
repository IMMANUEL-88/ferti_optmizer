import 'package:agri_connect/constants/sizes.dart';
import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';


class ECircularIcon extends StatelessWidget {
  const ECircularIcon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.size = ESizes.lg,
    this.onPressed,
    this.color,
    this.backgroundColor,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : EHelperFunctions.isDarkMode(context)
            ? Colors.black.withOpacity(0.9)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100),
      ), // BoxDecoration
      child: IconButton(
          onPressed: onPressed, icon: Icon(icon, color: color, size: size)),
    );
  }
}