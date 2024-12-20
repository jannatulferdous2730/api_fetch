import 'dart:convert';

import 'package:api_fetch/product_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart ' as http;

import 'api_service/api.dart';
import 'model/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Future<List<Product>> getAllProducts() async {
    List<Product> productList = [];

    try {
      final url = Uri.parse(Api.getAllProducts);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responsData = jsonDecode(response.body);

        for (var eachRecord in responsData as List) {
          productList.add(Product.fromJson(eachRecord));
        }
      }
    } catch (e) {
      print(e.toString());
    }

    return productList; // ze ei funtion call krbe take product er list dorai dibo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Product List",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FutureBuilder(
                future: getAllProducts(),
                builder: (context, AsyncSnapshot<List<Product>> dataSnapShot) {
                  if (dataSnapShot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (dataSnapShot.data == null) {
                    return Text("No data found");
                  }

                  if (dataSnapShot.data!.isNotEmpty) {
                    return GridView.builder(


                        itemCount: dataSnapShot.data!.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          childAspectRatio: 2.4
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          Product eachProduct = dataSnapShot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(ProductDetails(productInfo: eachProduct));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 2,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(10.0, 10.0))),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [

                                          Hero(
                                            tag: eachProduct.image!,
                                            child: CachedNetworkImage(
                                              imageUrl: eachProduct.image!,
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.contain,
                                            ),
                                          ),




                                          Text(eachProduct.title!, style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis
                                          ),),
                                          Text("Tk " + eachProduct.price.toString()),

                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  minimumSize: Size.fromHeight(30),
                                                  backgroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  )
                                              ),

                                              onPressed: (){
                                                Fluttertoast.showToast(msg: "Add to cart");
                                              }, child: Text("Add to cart", style: TextStyle(
                                            color: Colors.white,
                                          ),) )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }

                  else
                  {
                    return Text("No data found");
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
