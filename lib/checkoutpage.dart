import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_launch_ecommerce/constants.dart';
import 'package:my_launch_ecommerce/homepage.dart';
import 'package:my_launch_ecommerce/model/user_model.dart';
import 'package:my_launch_ecommerce/provider/cart_provider.dart';
import 'package:my_launch_ecommerce/razorpay.dart';
import 'package:my_launch_ecommerce/webservice/webservice.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CheckoutPage extends StatefulWidget {
  List<CartProduct> cart;
  CheckoutPage({super.key, required this.cart});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int selectedValue = 1;
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  String? username;
  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  orderPlace(List<CartProduct> cart, String amount, String paymentmethod,
      String date, String name, String address, String phone) async {
    String jsondata = jsonEncode(cart);
    log("hello");
    final vm = Provider.of<Cart>(context, listen: false);
    log("hello1");
    final response =
        // ignore: prefer_interpolation_to_compose_strings
        await http.post(Uri.parse(Webservice.mainurl + 'order.php'), body: {
      "username": username,
      "amount": amount,
      "paymentmethod": paymentmethod,
      "date": date,
      "quantity": vm.count.toString(),
      "cart": jsondata,
      "name": name,
      "address": address,
      "phone": phone,
    });
    log(username!);
    log(amount);
    log(paymentmethod);
    log(date);
    log(vm.count.toString());
    log(jsondata);
    log(name);
    log(address);
    log(phone);
    if (response.statusCode == 200) {
      log("hai");
      if (response.body.contains("Success")) {
        vm.clearCart();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(15),
            content: Text(
              "Your order successfully completed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white),
            )));
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const HomePage();
        }));
      }
    }
  }

  String? name, phone, address;
  String? paymentmethod = "Cash on delivery";
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text(
          "Check Out",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder<UserModel>(
                  future: Webservice().fetchUser(username.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      name = snapshot.data!.name;
                      phone = snapshot.data!.phone;
                      address = snapshot.data!.address;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "name : ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(name.toString())
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "phone : ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(phone.toString())
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "address : ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // ignore: sized_box_for_whitespace
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        address.toString(),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            RadioListTile(
              activeColor: Colors.blue,
              value: 1,
              groupValue: selectedValue,
              onChanged: (int? value) {
                setState(() {
                  selectedValue = value!;
                  paymentmethod = 'Cash on delivery';
                });
              },
              title: const Text(
                'Cash on delivery',
                style: TextStyle(fontFamily: "muli"),
              ),
              subtitle: const Text('Pay Cash at Home'),
            ),
            RadioListTile(
              activeColor: Colors.blue,
              value: 2,
              groupValue: selectedValue,
              onChanged: (int? value) {
                setState(() {
                  selectedValue = value!;
                  paymentmethod = 'Online';
                });
              },
              title: const Text(
                'Pay Now',
                style: TextStyle(fontFamily: "muli"),
              ),
              subtitle: const Text('Online Payment'),
            )
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            String datetime = DateTime.now().toString();

            if (paymentmethod == 'Online') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PaymentScreen(
                    address: address.toString(),
                    amount: vm.totalprice.toString(),
                    cart: widget.cart,
                    date: datetime.toString(),
                    name: name.toString(),
                    paymentmethod: paymentmethod.toString(),
                    phone: phone.toString());
              }));
            } else if (paymentmethod == "Cash on delivery") {
              orderPlace(widget.cart, vm.totalprice.toString(), paymentmethod!,
                  datetime, name!, address!, phone!);
            }
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
                "Checkout",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
