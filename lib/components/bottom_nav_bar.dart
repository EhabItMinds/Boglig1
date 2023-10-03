import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GNav(
          color: Theme.of(context).colorScheme.primary,
          activeColor: Colors.grey.shade800,
          tabActiveBorder: Border.all(color: Colors.white),
          tabBackgroundColor: Colors.grey.shade200,
          mainAxisAlignment: MainAxisAlignment.center,
          onTabChange: (value) => onTabChange!(value),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.message,
              text: 'chat',
            ),
            GButton(
              icon: Icons.favorite,
              text: 'Loved',
            ),
          ]),
    );
  }
}
