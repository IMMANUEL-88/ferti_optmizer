import 'package:agri_connect/agri_connect/new_utils/overall_rating.dart';
import 'package:agri_connect/agri_connect/widgets/ratingBarIndicator.dart';
import 'package:agri_connect/agri_connect/widgets/userReviewCard.dart';
import 'package:agri_connect/constants/image_strings.dart';
import 'package:agri_connect/constants/sizes.dart';
import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

class ProductPage extends StatelessWidget {
  final String productName = 'Fresh Broccoli';
  final double price = 149; // Example price per unit
  final double rating = 4.5;
  final int reviewsCount = 120;
  final String description =
      'Organically grown and freshly harvested broccoli, perfect for your healthy meals.';
  final String date = '11th September 2001';

  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,
      // Light background color
      // appBar: EAppBar(
      //   title:  Text('Product Details', style: Theme.of(context).textTheme.headlineMedium,),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 300,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage(EImages.broccoli),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwItems),

            // Product Title & Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Rating and Reviews
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow[700], size: 24),
                      Text(
                        '$rating ($reviewsCount reviews)',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Price Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    '₹$price per kg',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwItems),
            // Quantity Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text('Quantity:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Decrease quantity logic
                        },
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.green),
                      ),
                      const Text('1'), // Selected quantity value
                      IconButton(
                        onPressed: () {
                          // Increase quantity logic
                        },
                        icon: const Icon(Icons.add_circle_outline,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwItems),

            // Product Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  ReadMoreText(
                    description,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show Less',
                    moreStyle:
                        const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                    lessStyle:
                        const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: ESizes.spaceBtwSections),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Text(
                            'Harvest Date:',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            date,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtwSections,
                  ),
                  const Text(
                    'Nutritional Information (per 100g):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text('• Calories: 35 kcal'),
                  const Text('• Carbohydrates: 7 g'),
                  const Text('• Fiber: 2.4 g'),
                  const Text('• Protein: 2.8 g'),
                  const Text('• Fat: 0.4 g'),
                  const SizedBox(height: ESizes.spaceBtwSections),

                  const Text(
                    'Customer Reviews:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtwItems,
                  ),
                  const Text(
                      'Ratings and reviews are verified and are from people who use the same type of device that you use.'),
                  const SizedBox(
                    height: ESizes.spaceBtwItems,
                  ),

                  // --Overall Product Ratings--
                  const EOverAllProductRating(),
                  const ERatingBarIndicator(
                    rating: 3.5,
                  ),
                  Text(
                    '1269',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtwSections,
                  ),

                  // --User Reviews List--
                  const UserReviewCard(),
                  const UserReviewCard(),
                  const UserReviewCard(),
                  const UserReviewCard(),
                  const UserReviewCard(),
                ],
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwItems),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Add to Cart Button
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, AppRoutes.cart);
                context.push('/cartScreen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Add to Cart', style: TextStyle(fontSize: 16)),
            ),
            // Buy Now Button
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, AppRoutes.checkout);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Buy Now', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
