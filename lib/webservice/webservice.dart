import 'dart:convert';
import 'dart:developer';

import 'package:my_launch_ecommerce/model/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:my_launch_ecommerce/model/orderdetailsmodel.dart';
import 'package:my_launch_ecommerce/model/product_model.dart';
import 'package:my_launch_ecommerce/model/user_model.dart';

class Webservice {
  final imageurl = "http://bootcamp.cyralearnings.com/products/";
  static const mainurl = "http://bootcamp.cyralearnings.com/";

  // ignore: body_might_complete_normally_nullable
  Future<List<CategoryModel>?> fetchCategory() async {
    try {
      final response = await http.get(
          Uri.parse("http://bootcamp.cyralearnings.com/getcategories.php"));
      if (response.statusCode == 200) {
        final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
        return parsed
            .map<CategoryModel>((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        throw Exception('failed to load category');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<ProductModel>?> fetchProducts() async {
    final response =
        // ignore: prefer_interpolation_to_compose_strings
        await http.get(Uri.parse(mainurl + 'view_offerproducts.php'));
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<ProductModel>?> fetchCatProducts(int catid) async {
    final response = await http.post(
        Uri.parse(
            'http://bootcamp.cyralearnings.com/get_category_products.php'),
        body: {'catid': catid.toString()});
    if (response.statusCode == 200) {
      log(response.statusCode.toString());
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception("failed to load data");
    }
  }

  Future<List<OrderModel>?> fetchOrderDetails(String username) async {
    try {
      final response = await http.post(
          // ignore: prefer_interpolation_to_compose_strings
          Uri.parse(mainurl + 'get_orderdetails.php'),
          body: {'username': username.toString()});
      if (response.statusCode == 200) {
        log(response.statusCode.toString());
        final parsed = json.decode(response.body.toString()).cast<Map<String, dynamic>>();
        return parsed
            .map<OrderModel>((json) => OrderModel.fromJson(json))
            .toList();
      } else {
        throw Exception("failed to load orderdetails");
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<UserModel> fetchUser(String username) async {
    // ignore: prefer_interpolation_to_compose_strings
    final response = await http.post(Uri.parse(mainurl + 'get_user.php'),
        body: {'username': username});
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load fetch user');
    }
  }
}
