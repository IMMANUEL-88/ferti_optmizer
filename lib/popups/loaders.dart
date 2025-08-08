import 'package:agri_connect/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



class EAnimationLoaderWidget extends StatelessWidget {
  final String text;

  const EAnimationLoaderWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(EImages.leafLoadingLogo, height: 85, width: 85,),
        const SizedBox(height: 20),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge!.apply(
            color: Colors.black,

          ),
        ),
      ],
    );
  }
}