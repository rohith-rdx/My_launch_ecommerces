import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_launch_ecommerce/category_product.dart';
import 'package:my_launch_ecommerce/constants.dart';
import 'package:my_launch_ecommerce/detailspage.dart';
import 'package:my_launch_ecommerce/drawer.dart';
import 'package:my_launch_ecommerce/webservice/webservice.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 241, 241),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        toolbarHeight: 60,
        title: const Text(
          "MY LAUNCH",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: maincolor,
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Category",
              style: TextStyle(
                  color: maincolor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            // ignore: sized_box_for_whitespace

            FutureBuilder(
                future: Webservice().fetchCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // ignore: sized_box_for_whitespace
                    return Container(
                      height: 80,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  log("clicked");
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CategoryProductPage(
                                        catid: snapshot.data![index].id!,
                                        catname:
                                            snapshot.data![index].category!);
                                  }));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 230, 228, 228)),
                                  child: Center(
                                    child: Text(
                                      snapshot.data![index].category!,
                                      style: const TextStyle(
                                          color: maincolor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Most Searched Products",
              style: TextStyle(
                  color: maincolor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: FutureBuilder(
                    future: Webservice().fetchProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // ignore: avoid_unnecessary_containers
                        return Container(
                          child: StaggeredGridView.countBuilder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              crossAxisCount: 2,
                              itemBuilder: (context, index) {
                                final product = snapshot.data![index];
                                return InkWell(
                                  onTap: () {
                                    log("clicked");
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DetailsPage(
                                          id: product.id!,
                                          name: product.productname!,
                                          image: Webservice().imageurl +
                                              product.image!,
                                          description: product.description!,
                                          price: product.price!.toString());
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15)),
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                  minHeight: 100,
                                                  maxHeight: 250),
                                              child: Image(
                                                  image: NetworkImage(
                                                Webservice().imageurl +
                                                    product.image!,
                                                // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvrOD46c0R-Awf-tPQXCUDfU9pHNcwREIp0Q&usqp=CAU"
                                              )),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    product.productname!,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          // ignore: prefer_interpolation_to_compose_strings
                                                          'Rs. ' +
                                                              product.price
                                                                  .toString(),
                                                          //'RS. ' + '2000',
                                                          style: const TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              staggeredTileBuilder: (context) =>
                                  const StaggeredTile.fit(1)),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
