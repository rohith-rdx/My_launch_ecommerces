import 'package:flutter/material.dart';
import 'package:my_launch_ecommerce/cartpage.dart';
import 'package:my_launch_ecommerce/constants.dart';
import 'package:my_launch_ecommerce/homepage.dart';
import 'package:my_launch_ecommerce/login_screen.dart';
import 'package:my_launch_ecommerce/orderdetailspage.dart';
import 'package:my_launch_ecommerce/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 241, 240, 240),
      child: SafeArea(
          child: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Align(
              alignment: Alignment.center,
              child: Text(
                "MY LAUNCH",
                style: TextStyle(
                    color: maincolor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            thickness: 0.5,
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const HomePage();
              }));
            },
          ),
          ListTile(
            leading: badges.Badge(
                showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
                badgeContent: Text(
                  context.watch<Cart>().getItems.length.toString(),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                child: const Icon(Icons.shopping_cart)),
            title: const Text(
              "Cart Page",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CartPage();
              }));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(Icons.book_online_rounded),
            title: const Text(
              "Order Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const OrderdetailsPage();
              }));
            },
          ),
          const Divider(
            thickness: 0.2,
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              // ignore: use_build_context_synchronously
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LoginScreen();
              }));
            },
          )
        ],
      )),
    );
  }
}
