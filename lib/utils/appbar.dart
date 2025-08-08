
import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:agri_connect/utils/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class EAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EAppBar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.leadingIconColor,
    this.actions,
    this.leadingOnPressed,
    this.leadingIconSize,
    this.precedingIcon, // Added preceding icon
    this.precedingOnPressed, // Added preceding button action
    this.precedingIconColor,
    this.precedingIcon1, // Added preceding icon
    this.precedingOnPressed1, // Added preceding button action
    this.precedingIconColor1,
  });

  final Widget? title;
  final bool showBackArrow;
  final Color? leadingIconColor;
  final double? leadingIconSize;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  // New preceding icon and its properties
  final IconData? precedingIcon;
  final VoidCallback? precedingOnPressed;
  final Color? precedingIconColor;
  final IconData? precedingIcon1;
  final VoidCallback? precedingOnPressed1;
  final Color? precedingIconColor1;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return AppBar(
      backgroundColor: Colors.green,

      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      leading: showBackArrow
          ? IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Iconsax.arrow_left,
          color: dark ? Colors.white : Colors.black,
        ),
      )
          : leadingIcon != null
          ? IconButton(
        onPressed: leadingOnPressed,
        icon: Icon(
          leadingIcon,
          color: leadingIconColor,
          size: leadingIconSize,
        ),
      )
          : null,

      title: title,

      actions: [
        if (actions != null) ...actions!, // Other action buttons (if any)
        if (precedingIcon1 != null) // Preceding icon on the right
          IconButton(
            onPressed: precedingOnPressed1,
            icon: Icon(
              precedingIcon1,
              color: precedingIconColor1 ?? (dark ? Colors.white : Colors.black),
            ),
          ),
        if (actions != null) ...actions!, // Other action buttons (if any)
        if (precedingIcon != null) // Preceding icon on the right
          IconButton(
            onPressed: precedingOnPressed,
            icon: Icon(
              precedingIcon,
              color: precedingIconColor ?? (dark ? Colors.white : Colors.black),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(EDeviceUtils.getAppBarHeight());
}
