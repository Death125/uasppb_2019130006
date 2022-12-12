// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:uasppb_2019130006/page/shopping/shopping_cart.dart';
import 'shopping/product_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  static bool newScreen = false;
  static int index = 0;

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final screens = [
    const ProductPage(),
    ShoppingCart(),
    const ProfilePage(),
  ];

  Widget bottomNav() {
    return NavigationBar(
        height: 60,
        backgroundColor: Colors.blue.shade300,
        selectedIndex: HomePage.index,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (index) =>
            setState(() => HomePage.index = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          const NavigationDestination(
            icon: Icon(Icons.shopping_cart_checkout_outlined),
            selectedIcon: Icon(Icons.shopping_cart_checkout),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[HomePage.index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: Colors.white12,
            labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
        child: bottomNav(),
      ),
    );
  }
}
