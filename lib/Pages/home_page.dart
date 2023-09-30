import 'package:bolig/Pages/apartment_page.dart';
import 'package:bolig/Pages/user_chat_page.dart';
import 'package:bolig/components/bottom_nav_bar.dart';
import 'package:bolig/theme/theme_provioder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //denne er til at controller bottom nav bar
  int selectedIndex = 0;

//denne metode vil opdatere vores index når brugeren trykker
  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  //pages to display
  final List<Widget> pages = [
    const ApartmentPage(),
    const UserChatPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: MyBottomNavBar(
          onTabChange: (index) => navigateBottomBar(index),
        ),
   appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  leading: Builder(
    builder: (context) => IconButton(
      icon: Provider.of<ThemeProvider>(context).dark ? 
      const Icon(Icons.menu) : const Icon(Icons.menu, color: Colors.black),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    ),
  ),
  actions: <Widget>[
    Row(
      children: [
        IconButton(
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          icon: Provider.of<ThemeProvider>(context).dark
              ? const Icon(Icons.sunny)
              : const Icon(Icons.nightlight, color: Colors.black),
        ),
        const SizedBox(
          width: 10,
        ),
          IconButton(
              onPressed: signUserOut,
              icon: const Icon(Icons.logout, color: Colors.black), // You missed the Icon widget here
            ),
      ],
    ),
  ],
),

        drawer: Drawer(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DrawerHeader(
                    child: Image.asset(
                      'lib/images/logo.png',
                      width: 100,
                      height: 25,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Divider(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text('About'),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(left: 25, bottom: 25),
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
           
            ],
          ),
        ),
        body: pages[selectedIndex]);
  }
}
