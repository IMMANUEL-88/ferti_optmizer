import 'package:flutter/material.dart';
class NPK extends StatelessWidget {
  const NPK({
    super.key,
    required this.nutrient,
    required this.value,
  });

  final String nutrient;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          nutrient,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Text(
          '$value',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}