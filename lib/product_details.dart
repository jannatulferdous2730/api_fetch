
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'model/product.dart';

class ProductDetails extends StatefulWidget {

  final Product productInfo;
  const ProductDetails({super.key, required this.productInfo});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),

      body: Column(
        children: [
          Hero(
            child: CachedNetworkImage(
              imageUrl: widget.productInfo.image!,
              height: MediaQuery.sizeOf(context).height/3,
              width: MediaQuery.sizeOf(context).width,
              fit: BoxFit.contain,
            ),
            tag: widget.productInfo!.image!,
          ),

          Text(widget.productInfo.title!),

          Text("Tk" + widget.productInfo.price.toString()),


        ],
      ),
    );
  }
}
