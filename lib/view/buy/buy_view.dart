import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:local_stuff_sell_buy/constant/app_constant.dart';
import 'package:local_stuff_sell_buy/utils/app_utils.dart';
import 'package:local_stuff_sell_buy/widgets/custom_button.dart';
import '../../model/product.dart';
import '../../service/firebase_service.dart';

class BuyView extends StatefulWidget {
  Product? product;
  BuyView(this.product);

  @override
  State<BuyView> createState() => _BuyViewState();
}

class _BuyViewState extends State<BuyView> {
  String? name, gName, desc, price, selectedCat, imageUrl;
  final FirebaseService _service = FirebaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.product!.name;
    desc = widget.product!.description;
    price = widget.product!.price.toString();
    gName = widget.product!.gName;
    imageUrl = widget.product!.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 65,
            backgroundColor: AppConstant.appBarColor,
            foregroundColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Buy Now',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width - 48,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
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
                          Text(
                            '${name}',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${AppUtil.formatCurrency(widget.product!.price)}',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${desc}',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade800),
                          ),
                          Text('Seller : $gName'),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomButton(
          backgroundColor: AppConstant.cardColor,
          text: 'Buy Now',
          textColor: Colors.black,
          onClick: () {
            Navigator.pushNamed(context, AppConstant.paymentView,
                arguments: widget.product);
          },
        ),
      ),
    );
  }
}
