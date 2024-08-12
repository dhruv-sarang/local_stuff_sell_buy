import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_stuff_sell_buy/constant/app_constant.dart';
import 'package:local_stuff_sell_buy/model/current_user_data.dart';
import 'package:local_stuff_sell_buy/model/product.dart';
import 'package:local_stuff_sell_buy/utils/app_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../model/order.dart';
import '../../model/selectedAddress.dart';
import '../../service/firebase_service.dart';
import '../../widgets/custom_button.dart';

class PaymentView extends StatefulWidget {
  Product? product;
  PaymentView({super.key, this.product, this.currentUserData});

  CurrentUserData? currentUserData;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  FirebaseService _service = FirebaseService();
  User? _user;
  String? email;
  List<CurrentUserData> _address = [];
  SelectedAddress? _selectedAddress;
  int selectedOption = 0;

  Future<void> _loadAddress() async {
    List<CurrentUserData> address = await _service.loadAddress(email: email!);
    setState(() {
      _address = address;
    });
  }

  Future<void> _loadSelectedAddress() async {
    SelectedAddress? selectedAddress = await _service.loadSelectedAddress();
    setState(() {
      _selectedAddress = selectedAddress;
      selectedOption = _selectedAddress!.selectedOption;
    });
  }

  Razorpay _razorpay = Razorpay();
  int? total;

  void openCheckOut() {
    var options = {
      'key': 'rzp_test_QZSgOum86mXT8q',
      'amount': total! * 100,
      'name': 'Local Stuff App',
      'prefill': {
        'contact': _address[selectedOption].mobileNo,
        'email': email ?? 'test@gmail.com'
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _storeOrderDetails(String paymentId, Product product) {
    Order order = Order(
      product: product,
      orderDate: DateTime.now().millisecondsSinceEpoch,
      paymentId: paymentId,
      shippingAddress:
          '${_address[selectedOption].address}, ${_address[selectedOption].pinCode}',
      status: 'pending',
      totalPrice: total,
      userEmailId: _user!.email,
      buyerName: _user!.displayName,
      buyerNo: _address[selectedOption].mobileNo,
    );

    FirebaseService().placeOrder(order).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Order placed successfully')));
      Navigator.pushNamedAndRemoveUntil(
          context, AppConstant.homeView, (route) => false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = _service.currentUser;
    email = _user!.email;
    _loadAddress();
    _loadSelectedAddress();
    total = widget.product!.price;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment here
    final String paymentId = response.paymentId!;
    _storeOrderDetails(
        paymentId, widget.product!); // Custom function to store order details
    print('payment id : $paymentId');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error here
    final String code = response.code.toString();
    final String message = response.message!;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payments
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
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
                  'Pay Now',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 24),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: widget.product!.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.product!.name}',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${AppUtil.formatCurrency(widget.product!.price)}',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Text('Seller : ${widget.product!.gName}'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, left: 24.0),
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
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shopping Address',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                    context, AppConstant.addressView);
                                if (result is SelectedAddress) {
                                  setState(() {
                                    _selectedAddress = result;
                                    selectedOption =
                                        _selectedAddress!.selectedOption;
                                  });
                                }
                                // Navigator.pushNamed(
                                //     context, AppConstant.addressView);
                              },
                              child: Icon(Icons.edit_note),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: _address.isNotEmpty && selectedOption >= 0
                              ? Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_address[selectedOption].address}, ${_address[selectedOption].pinCode}',
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                        'Mobile No. : ${_address[selectedOption].mobileNo}'),
                                  ],
                                )
                              : Text(
                                  'No address available',
                                  style: TextStyle(color: Colors.red),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, left: 24.0),
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
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Product Cost : ',
                                    style: TextStyle(fontSize: 16)),
                                Text('Shippind fee : ',
                                    style: TextStyle(fontSize: 16)),
                                Text('Total :  ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${AppUtil.formatCurrency(widget.product!.price)}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                Text('₹ 0', style: TextStyle(fontSize: 16)),
                                Text(
                                    '${AppUtil.formatCurrency(widget.product!.price)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomButton(
          backgroundColor: AppConstant.cardColor,
          text: 'Pay Now',
          textColor: Colors.black,
          onClick: () {
            openCheckOut();
          },
        ),
      ),
    );
  }
}
