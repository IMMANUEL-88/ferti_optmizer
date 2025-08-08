import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';


class ERatingProgressIndicator extends StatelessWidget {
  const ERatingProgressIndicator({
    super.key,
    required this.text,
    required this.value,
  });

  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: EHelperFunctions.screenWidth(context) * 0.5,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 11,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation(Colors.green),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        )
      ],
    );
  }
}