import 'package:flutter/material.dart';
import 'package:my_launch_ecommerce/checkoutpage.dart';
import 'package:my_launch_ecommerce/constants.dart';
import 'package:my_launch_ecommerce/provider/cart_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  List<CartProduct> cartlist = [];

  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade100,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          title: const Text(
            "Cart",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          actions: [
            context.watch<Cart>().getItems.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      context.read<Cart>().clearCart();
                    },
                    icon: const Icon(Icons.delete))
          ],
        ),
        body: context.watch<Cart>().getItems.isEmpty
            ? const Center(
                child: Text("empty cart"),
              )
            : Consumer<Cart>(builder: (context, cart, child) {
                cartlist = cart.getItems;
                return ListView.builder(
                    itemCount: cart.count,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 80,
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  cart.getItems[index].imageurl
                                                  // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvrOD46c0R-Awf-tPQXCUDfU9pHNcwREIp0Q&usqp=CAU"

                                                  ),
                                              fit: BoxFit.fill)),
                                    ),
                                  ),
                                ),
                                Flexible(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          cartlist[index].name
                                          //"product name"
                                          ,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade700),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cartlist[index].price.toString()
                                              // "2000"
                                              ,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade900),
                                            ),
                                            Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        cart.getItems[index]
                                                                    .qty ==
                                                                1
                                                            ? cart.removeItem(
                                                                cart.getItems[
                                                                    index])
                                                            : cart.reduceByOne(
                                                                cart.getItems[
                                                                    index]);
                                                      },
                                                      icon: cartlist[index]
                                                                  .qty ==
                                                              1
                                                          ? const Icon(
                                                              Icons.delete,
                                                            )
                                                          :
                                                          // ignore: prefer_const_constructors
                                                          Icon(
                                                              Icons
                                                                  .minimize_rounded,
                                                              size: 18,
                                                            )),
                                                  Text(
                                                    //"2"
                                                    cartlist[index]
                                                        .qty
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.red),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        cart.increment(cart
                                                            .getItems[index]);
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        size: 18,
                                                      ))
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // ignore: prefer_interpolation_to_compose_strings
                "total :" + context.watch<Cart>().totalprice.toString(),
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  context.read<Cart>().getItems.isEmpty
                      ? const ScaffoldMessenger(
                          child: SnackBar(
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              content: Text(
                                "cart is empty",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              )))
                      : Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                          return CheckoutPage(
                            cart: cartlist,
                          );
                        }));
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: maincolor),
                  child: const Center(
                    child: Text("order now",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
