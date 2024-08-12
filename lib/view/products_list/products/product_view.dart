import 'package:flutter/material.dart';
import '../../../constant/app_constant.dart';
import '../../../model/product.dart';
import 'components/product_form.dart';

class ProductView extends StatefulWidget {
  Product? product;

  ProductView(this.product, {super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appBarColor,
        iconTheme: IconThemeData(color: AppConstant.cardTextColor),
        title: Text('Manage Product',
            style: TextStyle(
                color: AppConstant.cardTextColor, fontWeight: FontWeight.w500)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ProductForm(widget.product),
          ),
        ),
      ),
    );
  }
}
