import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_stuff_sell_buy/model/order.dart';
import '../../constant/app_constant.dart';
import '../../service/firebase_service.dart';

class SoldProductListView extends StatefulWidget {
  const SoldProductListView({super.key});

  @override
  State<SoldProductListView> createState() => _SoldProductListViewState();
}

class _SoldProductListViewState extends State<SoldProductListView> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appBarColor,
        iconTheme: IconThemeData(color: AppConstant.cardTextColor),
        title: Text(
          'Sold Product',
          style: TextStyle(
              color: AppConstant.cardTextColor, fontWeight: FontWeight.w500),
        ),
      ),
      body: StreamBuilder(
        stream: _service.getSoldProductStream(email: email!),
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
            List<Order> orders = snapshot.data ?? [];
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    Order order = orders[index];
                    DateTime od =
                        DateTime.fromMillisecondsSinceEpoch(order.orderDate!);

                    String orderDate = DateFormat('MMMM dd, yyyy').format(
                        (DateTime.fromMillisecondsSinceEpoch(
                            order.orderDate!)));

                    String orderTime = DateFormat.jm().format(od);

                    return GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, AppConstant.productView,
                        //     arguments: product);
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
                                          imageUrl: order.product!.imageUrl,
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
                                                '${order.product!.name}',
                                                style: TextStyle(
                                                    fontSize: AppConstant
                                                        .titleFontSize,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDeleteDialog(
                                                      order.orderId, context);
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
                                                      '${order.product!.selectedCategory}',
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
                                                  text: '${order.totalPrice}',
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
                                      text: 'Order Date : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '$orderTime, $orderDate',
                                      style: TextStyle(
                                        fontSize: AppConstant.subDetailSize,
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Payment Id : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${order.paymentId}',
                                      style: TextStyle(
                                        fontSize: AppConstant.subDetailSize,
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Buyer Name : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${order.buyerName}',
                                      style: TextStyle(
                                        fontSize: AppConstant.subDetailSize,
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Buyer No. : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${order.buyerNo}',
                                      style: TextStyle(
                                        fontSize: AppConstant.subDetailSize,
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Buyer Email : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${order.userEmailId}',
                                      style: TextStyle(
                                        fontSize: AppConstant.subDetailSize,
                                        fontStyle: FontStyle.italic,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                overflow: TextOverflow.ellipsis,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Shipping Address : ',
                                      style: TextStyle(
                                          fontSize: AppConstant.subDetailSize,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: '${order.shippingAddress}',
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
    );
  }

  Future<void> showDeleteDialog(String? orderId, BuildContext context) async {
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
      await _service.deleteOrder(orderId!);
    }
  }
}
