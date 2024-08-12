import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_stuff_sell_buy/constant/app_constant.dart';
import 'package:local_stuff_sell_buy/model/homeGridData.dart';
import 'package:local_stuff_sell_buy/utils/app_utils.dart';
import '../../model/product.dart';
import '../../service/firebase_service.dart';
import '../../widgets/custom_button.dart';

class CategoryViseProductView extends StatefulWidget {
  HomeGridData homeGridData;

  CategoryViseProductView(this.homeGridData, {super.key});

  @override
  State<CategoryViseProductView> createState() =>
      _CategoryViseProductViewState();
}

class _CategoryViseProductViewState extends State<CategoryViseProductView> {
  final FirebaseService _service = FirebaseService();

  String? selectedCategory, email;
  List<Product> _products = [];

  User? _user;
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _service.currentUser;
    email = _user!.email;
    selectedCategory = widget.homeGridData!.title;
    print(selectedCategory);
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    List<Product> products = await _service.loadProductByCategory(
        email: email!, selectedCategory: selectedCategory!);
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        return product.name!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: 65,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            _onSearchChanged();
                          }, // Assign controller
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            labelText: 'Search',
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 14),
                            prefixIcon: Icon(Icons.location_on,
                                size: 18, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust this number for desired columns
                  childAspectRatio:
                      0.55, // Maintain aspect ratio (width/height)
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Product product = _filteredProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      child: CachedNetworkImage(
                                        imageUrl: product.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${product.name}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${AppUtil.formatCurrency(product.price)}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${product.description}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                CustomButton(
                                  backgroundColor: AppConstant.cardColor,
                                  text: 'Buy Now',
                                  textColor: Colors.black,
                                  onClick: () {
                                    Navigator.pushNamed(
                                        context, AppConstant.paymentView,
                                        arguments: product);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _filteredProducts.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
