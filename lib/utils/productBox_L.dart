import 'package:flutter/material.dart';
import 'package:agri_connect/constants/sizes.dart';

class ProductBoxL extends StatelessWidget {
  const ProductBoxL({
    super.key,
    required this.img,
    required this.name,
    required this.price
  });

  final String img;
  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 150, // Set a fixed height
      width: 150, // Set a fixed width for each product box
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Image.asset(
              img,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image,
                color: Colors.white54,
              ),
            ),
          ),
           Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Farmer1',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            '₹$price/- kg',
            style: const TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.normal,
              fontSize: ESizes.fontSizeSm,
            ),
          ),
        ],
      ),
    );
  }
}
