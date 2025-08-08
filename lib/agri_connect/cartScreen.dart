
import 'package:agri_connect/agri_connect/new_utils/cartItems.dart';
import 'package:agri_connect/constants/sizes.dart';
import 'package:agri_connect/utils/appbar.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EAppBar(
        showBackArrow: true,
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(
          ESizes.defaultSpace,
        ),
        child: ECartItems(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () {
            // Navigator.pushNamed(context, AppRoutes.checkout);
          },
          child: const Text('Checkout   ₹ 298'),
        ),
      ),
    );
  }
}