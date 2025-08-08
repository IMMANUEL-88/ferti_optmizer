import 'package:agri_connect/agri_connect/ShopingHome.dart';
import 'package:agri_connect/agri_connect/cartScreen.dart';
import 'package:agri_connect/agri_connect/pages/addProducts.dart';
import 'package:agri_connect/agri_connect/productScreen.dart';
import 'package:agri_connect/pages/analytics.dart';
import 'package:agri_connect/pages/analytics2.dart';
import 'package:agri_connect/pages/home.dart';
import 'package:agri_connect/pages/login.dart';
import 'package:agri_connect/pages/settings.dart';
import 'package:agri_connect/pages/week_screen.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
class AppRoutes {
  static GoRouter createRouter() {
    return GoRouter(
      // initialLocation: prefs.getBool('login') ?? false ? '/shopHome' : '/',
      initialLocation: prefs.getBool('login') ?? false ? '/home' : '/',
      // errorPageBuilder: (context, state) {
      //   return MaterialPage(child: Scaffold(
      //     appBar: AppBar(title: Text('Error')),
      //     body: Center(child: Text('Page not found')),
      //   ));
      // },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Login(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) =>  const Home(),
        ),
        GoRoute(
          path: '/analytics',
          builder: (context, state) =>  SoilDataChart(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const Settings(),
        ),
        GoRoute(
          path: '/weekScreen',
          builder: (context, state) => const WeekScreen(),
        ),
        GoRoute(
          path: '/shopHome',
          builder: (context, state) => const ShopingHome(),
        ),
        GoRoute(
          path: '/productScreen',
          builder: (context, state) =>  const ProductPage(),
        ),
        GoRoute(
          path: '/cartScreen',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/ProductAddScreen',
          builder: (context, state) => const AddProductPage(),
        ),
      ],
    );
  }
}
