import 'package:agri_connect/constants/image_strings.dart';
import 'package:agri_connect/constants/sizes.dart';
import 'package:agri_connect/helper_functions/helper_functions.dart';
import 'package:agri_connect/utils/CategoryItems.dart';
import 'package:agri_connect/utils/adBox.dart';
import 'package:agri_connect/utils/appbar.dart';
import 'package:agri_connect/utils/productBox_L.dart';
import 'package:agri_connect/utils/productBox_s.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ShopingHome extends StatefulWidget {
  const ShopingHome({super.key});

  @override
  State<ShopingHome> createState() => _ShopingHomeState();
}

class _ShopingHomeState extends State<ShopingHome> {
  final TextEditingController searchController = TextEditingController();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: EAppBar(
        leadingIcon: Icons.arrow_back_ios_new_rounded,
        leadingIconColor: Colors.white,
        leadingIconSize: 24,
        leadingOnPressed: () {
          context.pop();
        },
        precedingIcon: Icons.filter_alt_outlined,
        precedingOnPressed: (){ context.push('/productScreen');},
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent.withOpacity(0.15),
              labelText: 'Search',
              labelStyle: const TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.6), width: 1.5),
              ),
              hintStyle: const TextStyle(color: Colors.white60),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
              suffixIcon: const Icon(Icons.search, color: Colors.white,),
            ),
          ),
        ),
      ),
      body: NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: (_, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              floating: true,
              scrolledUnderElevation: 0,
              expandedHeight: EHelperFunctions.screenHeight(context) * 0.35,
              backgroundColor: Colors.transparent,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var top = constraints.biggest.height;
                  var opacity = (top - 80) / 250;

                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: SizedBox(
                        height: 175,
                        child: Column(
                          children: [
                            Container(
                              height: 25,
                              color: Colors.transparent.withOpacity(0.05),
                              child: const Row(
                                children: [
                                  Icon(
                                    Iconsax.location,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  Text(
                                    ' Deliver to Tirunelveli -Palayankottai 627001',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: 4,
                                // Number of items (update if you add more pages)
                                itemBuilder: (context, index) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    // Spacing between items
                                    child: adBox(
                                        img: EImages
                                            .ad1), // Use a single instance or change as needed
                                  );
                                },
                                physics: const BouncingScrollPhysics(),
                                pageSnapping: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            color: Colors.green,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  CategoryItems(),
                  Divider(thickness: 3, color: Colors.white54),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Deal of the Day',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: ESizes.fontSizeLg,
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ProductBox(
                              img: EImages.broccoli,
                              name: 'brocolis',
                              price: '30',
                            ),
                            ProductBox(
                              img: EImages.carrots,
                              name: 'carrots',
                              price: '32',
                            ),
                            ProductBox(
                              img: EImages.beans,
                              name: 'beans',
                              price: '29',
                            ),
                            ProductBox(
                              img: EImages.carrots,
                              name: 'carrots',
                              price: '22',
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ProductBox(
                              img: EImages.carrots,
                              name: 'carrots',
                              price: '31',
                            ),
                            ProductBox(
                              img: EImages.beans,
                              name: 'beans',
                              price: '27',
                            ),
                            ProductBox(
                              img: EImages.broccoli,
                              name: 'brocolis',
                              price: '40',
                            ),
                            ProductBox(
                              img: EImages.carrots,
                              name: 'carrots',
                              price: '28',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(thickness: 3, color: Colors.white54),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Weekly Buy",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: ESizes.fontSizeLg,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ProductBoxL(
                                  img: EImages.carrots,
                                  name: 'carrot',
                                  price: '30'),
                              ProductBoxL(
                                  img: EImages.carrots,
                                  name: 'carrot',
                                  price: '30'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ProductBoxL(
                                  img: EImages.carrots,
                                  name: 'carrot',
                                  price: '30'),
                              ProductBoxL(
                                  img: EImages.carrots,
                                  name: 'carrot',
                                  price: '30'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                          height: 220,
                          child: adBox(img: EImages.ad1)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
