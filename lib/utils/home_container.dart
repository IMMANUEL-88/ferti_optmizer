import 'package:flutter/material.dart';

class ReusableContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;

  const ReusableContainer({
    super.key,
    required this.height,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.15), // Set a common background color
        borderRadius: BorderRadius.circular(14.0), // Optional for rounded corners
      ),
      child: Center(child: child), // Display the passed child widget
    );
  }
}
