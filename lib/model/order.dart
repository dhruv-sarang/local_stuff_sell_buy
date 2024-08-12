import 'package:local_stuff_sell_buy/model/product.dart';

class Order {
  String? orderId;
  String? buyerName;
  String? userEmailId;
  int? orderDate;
  Product? product;
  String? paymentId;
  int? totalPrice;
  String? status;
  String? shippingAddress;
  String? buyerNo;

  Order(
      {this.orderId,
      this.userEmailId,
      this.buyerName,
      this.orderDate,
      this.product,
      this.paymentId,
      this.totalPrice,
      this.status,
      this.shippingAddress, this.buyerNo});

  Map<String, dynamic> toMap() {
    return {
      'orderId': this.orderId,
      'userId': this.userEmailId,
      'buyerName': this.buyerName,
      'orderDate': this.orderDate,
      'product': this.product!.toMap(),
      'paymentId': this.paymentId,
      'totalPrice': this.totalPrice,
      'status': this.status,
      'shippingAddress': this.shippingAddress,
      'buyerNo': this.buyerNo,
    };
  }

  factory Order.fromMap(Map<dynamic, dynamic> map) {
    return Order(
      orderId: map['orderId'] as String,
      userEmailId: map['userId'] as String,
      buyerName: map['buyerName'] as String,
      orderDate: map['orderDate'] as int,
      product: map['product'] != null ? Product.fromMap(map['product']) : null,
      paymentId: map['paymentId'] as String,
      totalPrice: map['totalPrice'] as int,
      status: map['status'] as String,
      shippingAddress: map['shippingAddress'] as String,
      buyerNo: map['buyerNo'] as String,
    );
  }
}
