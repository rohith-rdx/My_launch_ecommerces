import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:my_launch_ecommerce/constants.dart';
import 'package:my_launch_ecommerce/homepage.dart';
import 'package:my_launch_ecommerce/provider/cart_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DetailsPage extends StatelessWidget {
  String name, price, image, description;
  int id;
  DetailsPage(
      {super.key,
      required this.id,
      required this.name,
      required this.image,
      required this.description,
      required this.price});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(id.toString());
    // ignore: avoid_print
    print(name);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                      image: NetworkImage(
                    image,
                    //"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvrOD46c0R-Awf-tPQXCUDfU9pHNcwREIp0Q&usqp=CAU"
                  )),
                ),
                Positioned(
                    left: 15,
                    top: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return const HomePage();
                          }));
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                        color: Colors.black,
                      ),
                    )),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 234, 233, 233),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        name,
                        //  "Shoes",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      // ignore: prefer_interpolation_to_compose_strings
                      "RS. " + price, //"2000",
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      description,
                      // "A shoe is an item of footwear to protect and comfort the human foot.",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            log("");

            var existingItemCart = context
                .read<Cart>()
                .getItems
                .firstWhereOrNull((element) => element.id == id);
            if (existingItemCart != null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  content: Text(
                    "This item is already in cart",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "muli", fontSize: 18, color: Colors.white),
                  )));
            } else {
              context
                  .read<Cart>()
                  .addItem(id, name, double.parse(price), 1, image);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  content: Text(
                    "Added to cart !!!!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "muli", fontSize: 18, color: Colors.white),
                  )));
            }
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            //   return CartPage();
            // }));
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: maincolor,
            ),
            child: const Center(
              child: Text(
                "Add to Cart",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
