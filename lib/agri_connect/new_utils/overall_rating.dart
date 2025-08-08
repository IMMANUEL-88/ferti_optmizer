import 'package:agri_connect/agri_connect/widgets/progressIndicator.dart';
import 'package:flutter/material.dart';

class EOverAllProductRating extends StatelessWidget {
  const EOverAllProductRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            '4.8',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        const Expanded(
          flex: 7,
          child: Column(
            children: [
              ERatingProgressIndicator(
                text: '5',
                value: 1.0,
              ),
              ERatingProgressIndicator(
                text: '4',
                value: 0.8,
              ),
              ERatingProgressIndicator(
                text: '3',
                value: 0.6,
              ),
              ERatingProgressIndicator(
                text: '2',
                value: 0.4,
              ),
              ERatingProgressIndicator(
                text: '1',
                value: 0.2,
              ),
            ],
          ),
        )
      ],
    );
  }
}