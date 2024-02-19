import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_launch_ecommerce/homepage.dart';
import 'package:my_launch_ecommerce/provider/cart_provider.dart';
import 'package:my_launch_ecommerce/webservice/webservice.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  List<CartProduct> cart;
  String amount;
  String paymentmethod;
  String date;
  String name;
  String address;
  String phone;
  PaymentScreen(
      {super.key,
      required this.address,
      required this.amount,
      required this.cart,
      required this.date,
      required this.name,
      required this.paymentmethod,
      required this.phone});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay? razorpay;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    flutterpayment("abcd", 10);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay!.clear();
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
    try {
      String jsondata = jsonEncode(cart);
      final vm = Provider.of<Cart>(context, listen: false);
      final response = await http.post(Uri.parse(
          // ignore: prefer_interpolation_to_compose_strings
          Webservice.mainurl + 'order.php'), body: {
        "username": username,
        "amount": amount,
        "paymentmethod": paymentmethod,
        "date": date,
        "quantity": vm.count.toString(),
        "cart": jsondata,
        'name': name,
        "address": address,
        "phone": phone
      });

      if (response.statusCode == 200) {
        if (response.body.contains("Success")) {
          vm.clearCart();
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Text(
                "Your order succesfully completed",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              )));
          // ignore: use_build_context_synchronously
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const HomePage();
          }));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void flutterpayment(String orderId, int t) {
    var options = {
      "key": "rzp_test_3npNqEo8P1RTx2",
      "amount": t * 100,
      'name': "rohith",
      'currency': "INR",
      'description': 'maligai',
      'external': {
        'wallets': ['paytm']
      },
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      "prefill": {"contact": "9946202497", "email": "rohithdrizex123@gmail.com"}
    };
    try {
      razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    response.orderId;
    sucessmethd(response.paymentId.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // ignore: prefer_interpolation_to_compose_strings
    log("error==" + response.message.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("wallet");
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }

  void sucessmethd(String paymentid) {
    orderPlace(widget.cart, widget.amount.toString(), widget.paymentmethod,
        widget.date, widget.name, widget.address, widget.phone);
  }
}
