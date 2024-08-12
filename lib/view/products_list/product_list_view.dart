import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_constant.dart';
import '../../model/product.dart';
import '../../service/firebase_service.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final FirebaseService _service = FirebaseService();
  User? _user;
  String? email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = _service.currentUser;
    email = _user!.email;
    print(email);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appBarColor,
        iconTheme: IconThemeData(color: AppConstant.cardTextColor),
        title: Text(
          'Your Products on Sell',
          style: TextStyle(
              color: AppConstant.cardTextColor, fontWeight: FontWeight.w500),
        ),
      ),
      body: StreamBuilder(
        stream: _service.getSellProductStream(email: email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error : ${snapshot.error.toString()}'),
            );
          } else {
            // success
            List<Product> products = snapshot.data ?? [];
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppConstant.productView,
                            arguments: product);
                      },
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    color: AppConstant.imageBgColour,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CachedNetworkImage(
                                          imageUrl: product.imageUrl,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${product.name}',
                                                style: TextStyle(
                                                    fontSize: AppConstant
                                                        .titleFontSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDeleteDialog(
                                                      product.id, context);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Category : ',
                                                  style: TextStyle(
                                                      fontSize: AppConstant
                                                          .subDetailSize,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${product.selectedCategory}',
                                                  style: TextStyle(
                                                      fontSize: AppConstant
                                                          .subDetailSize),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Price : ',
                                                  style: TextStyle(
                                                      fontSize: AppConstant
                                                          .subDetailSize,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text: '${product.price}',
                                                  style: TextStyle(
                                                      fontSize: AppConstant
                                                          .subDetailSize),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Description : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${product.description}',
                                      style: TextStyle(
                                        fontSize: AppConstant.subDetailSize,
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstant.imageBgColour,
        onPressed: () {
          Navigator.pushNamed(context, AppConstant.productView);
        },
        child: Icon(
          Icons.add,
          color: AppConstant.cardTextColor,
          size: 30,
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(String? proId, BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Are you sure you want to delete this category?',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (res) {
      await _service.deleteProduct(proId!);
    }
  }
}
