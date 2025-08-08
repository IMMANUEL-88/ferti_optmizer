import 'package:flutter/material.dart';

class SC extends StatelessWidget {
  final String name;
  final IconData icon;
  final ValueChanged<bool>? onChanged; // Change the type to bool for the Switch
  final VoidCallback? onPressed; // Callback for the onPressed action
  final TextInputType keyboardType;
  final bool value;

  const SC({
    super.key,
    required this.name,
    required this.icon,
    this.value = false, // Default value to false if not provided
    this.onChanged,
    this.onPressed, // Include the onPressed parameter
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Trigger the onPressed action when tapped
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8), // Spacing between icon and text
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            // Switch(
            //   value: value,
            //   onChanged: onChanged, // Use the provided onChanged callback
            // ),
            const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }
}
