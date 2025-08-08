import 'package:agri_connect/constants/sizes.dart';
import 'package:flutter/material.dart';



class adBox extends StatelessWidget {
  const adBox({
    super.key,
    required this.img,
  });

  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      color: Colors.transparent.withOpacity(.15),
      child: Padding(
        padding: const EdgeInsets.all(ESizes.sm),
        child: Image.asset(img,
          fit: BoxFit.cover,)
      ),
    );
  }
}