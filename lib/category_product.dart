import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_launch_ecommerce/detailspage.dart';
import 'package:my_launch_ecommerce/webservice/webservice.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

// ignore: must_be_immutable
class CategoryProductPage extends StatefulWidget {
  String catname;
  int catid;
  CategoryProductPage({super.key, required this.catid, required this.catname});

  @override
  State<CategoryProductPage> createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  @override
  Widget build(BuildContext context) {
    log(widget.catname);
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          title: Text(
            widget.catname,
            //"Category Name",
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        body: FutureBuilder(
            future: Webservice().fetchCatProducts(widget.catid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // ignore: avoid_print
                print("include snapshot");
                return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          // ignore: avoid_print
                          print("clicked");
                          DetailsPage(
                              id: product.id!,
                              name: product.productname!,
                              image: Webservice().imageurl + product.image!,
                              description: product.description!,
                              price: product.price!.toString());
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return DetailsPage(
                                id: product.id!,
                                name: product.productname!,
                                image: Webservice().imageurl + product.image!,
                                description: product.description!,
                                price: product.price!.toString());
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minHeight: 100, maxHeight: 250),
                                    child: Image(
                                        image: NetworkImage(
                                            Webservice().imageurl +
                                                product.image!
                                            //"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvrOD46c0R-Awf-tPQXCUDfU9pHNcwREIp0Q&usqp=CAU"
                                            )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          product.productname!,
                                          // "shoes",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                // ignore: prefer_interpolation_to_compose_strings
                                                "Rs ." +
                                                    product.price
                                                        .toString(), //"2000",
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
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
                        const StaggeredTile.fit(1));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
