import 'package:flutter/material.dart';
import 'package:my_launch_ecommerce/webservice/webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class OrderdetailsPage extends StatefulWidget {
  const OrderdetailsPage({super.key});

  @override
  State<OrderdetailsPage> createState() => _OrderdetailsPageState();
}

class _OrderdetailsPageState extends State<OrderdetailsPage> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    // ignore: avoid_print
    print("hai");
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade200,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
          title: const Text(
            "Order Details",
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
        body: FutureBuilder(
            future: Webservice().fetchOrderDetails(username.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // ignore: avoid_print
                print(snapshot.data!.length);

                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      // ignore: non_constant_identifier_names
                      final order_details = snapshot.data![index];
                      // ignore: avoid_print
                      print("rohith");
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Card(
                          elevation: 0,
                          color: const Color.fromARGB(15, 74, 20, 140),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ExpansionTile(
                            trailing: const Icon(Icons.arrow_drop_down),
                            textColor: Colors.black,
                            collapsedTextColor: Colors.black,
                            iconColor: Colors.red,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat.yMMMEd()
                                      .format(order_details.date!),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  order_details.paymentmethod.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  order_details.totalamount.toString() + "/-",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red.shade900,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                            children: [
                              ListView.separated(
                                itemCount: order_details.products!.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 25),
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  // ignore: avoid_print
                                  print("kind");
                                  // List<Option> options=quiz.option;
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: SizedBox(
                                      height: 100,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 80,
                                            width: 100,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 9),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        Webservice().imageurl +
                                                            order_details
                                                                .products![
                                                                    index]
                                                                .image!,
                                                      ),
                                                      fit: BoxFit.fill),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Wrap(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Text(
                                                    order_details
                                                        .products![index]
                                                        .productname
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .grey.shade700),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        order_details
                                                            .products![index]
                                                            .price
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                      ),
                                                      Text(
                                                        order_details
                                                            .products![index]
                                                            .quantity
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.green),
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
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  // ignore: avoid_print
                                  print("seperator");
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
