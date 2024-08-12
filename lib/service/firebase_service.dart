import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_stuff_sell_buy/model/current_user_data.dart';
import 'package:local_stuff_sell_buy/model/selectedAddress.dart';
import '../model/order.dart';
import '../model/product.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final Reference _storageReference = FirebaseStorage.instance.ref();

  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return await _firebaseAuth.signInWithCredential(credential);
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addProduct(
      {required String gId,
      required String gName,
      required String name,
      required String desc,
      XFile? newImage,
      required int price,
      required String selectedCategory,
      String? productId,
      String? existingImageUrl,
      int? createdAt,
      required BuildContext context}) async {
    String imageUrl = existingImageUrl ?? '';
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );

      if (newImage != null) {
        TaskSnapshot snapshot = await _storageReference
            .child('product')
            .child('${DateTime.now().millisecondsSinceEpoch}.png')
            .putFile(File(newImage.path));

        imageUrl = await snapshot.ref.getDownloadURL();
      }

      int timestampProduct = createdAt ?? DateTime.now().millisecondsSinceEpoch;

      Product product = Product(
          id: productId,
          gId: gId,
          gName: gName,
          name: name,
          description: desc,
          price: price,
          selectedCategory: selectedCategory,
          imageUrl: imageUrl,
          createdAt: timestampProduct);

      if (productId == null) {
        // create
        var id = _databaseReference.child('product').push().key;
        product.id = id;

        _databaseReference
            .child('product')
            .child(product.id!)
            .set(product.toMap());
      } else {
        // update
        _databaseReference
            .child('product')
            .child(product.id!)
            .update(product.toMap());
      }

      Navigator.pop(context);
      return true;
    } catch (e) {
      Navigator.pop(context);
      return false;
    }
  }

  Stream<List<Product>> getSellProductStream({required String email}) {
    if (currentUser == null) {
      return Stream.value([]);
    }
    String userGId = currentUser!.email!;
    return _databaseReference.child("product").onValue.map((event) {
      List<Product> productList = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          final product = Product.fromMap(value);
          if (product.gId == userGId) {
            productList.add(product);
          }
        });
      }
      return productList;
    });
  }

  Future<List<Product>> loadProduct({required String email}) async {
    DataSnapshot snapshot = await _databaseReference.child('product').get();
    List<Product> products = [];
    String userGId = currentUser!.email!;

    if (snapshot.exists) {
      Map<dynamic, dynamic> categoriesMap =
          snapshot.value as Map<dynamic, dynamic>;
      categoriesMap.forEach((key, value) {
        final product = Product.fromMap(value);
        if (product.gId != userGId) {
          products.add(product);
        }
      });
    }
    return products;
  }

  Future<List<Product>> loadProductByCategory(
      {required String email, required String selectedCategory}) async {
    DataSnapshot snapshot = await _databaseReference.child('product').get();
    List<Product> products = [];
    String userGId = currentUser!.email!;

    if (snapshot.exists) {
      Map<dynamic, dynamic> categoriesMap =
          snapshot.value as Map<dynamic, dynamic>;
      categoriesMap.forEach((key, value) {
        final product = Product.fromMap(value);
        if (product.gId != userGId &&
            product.selectedCategory == selectedCategory) {
          products.add(product);
        }
      });
    }
    return products;
  }

  Future<bool> deleteProduct(String proId) async {
    try {
      await _databaseReference.child('product').child(proId).remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addAddress(
      {String? userId,
      required String name,
      required String email,
      required String mobileNo,
      required String imageUrl,
      required String pinCode,
      required String address,
      int? createdAt,
      required BuildContext context}) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );

      int timestamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;

      CurrentUserData currentUserData = CurrentUserData(
          id: userId,
          name: name,
          email: email,
          imageUrl: imageUrl,
          mobileNo: mobileNo,
          pinCode: pinCode,
          address: address,
          createdAt: timestamp);

      if (userId == null) {
        // create
        var id = _databaseReference.child('address').push().key;
        currentUserData.id = id;
        _databaseReference
            .child('address')
            .child(currentUserData.id!)
            .set(currentUserData.toMap());
      } else {
        // update
        _databaseReference
            .child('address')
            .child(currentUserData.id!)
            .update(currentUserData.toMap());
      }

      Navigator.pop(context);
      return true;
    } catch (e) {
      Navigator.pop(context);
      return false;
    }
  }

  Future<List<CurrentUserData>> loadAddress({required String email}) async {
    DataSnapshot snapshot = await _databaseReference.child('address').get();
    List<CurrentUserData> addressList = [];
    String userGId = currentUser!.email!;

    if (snapshot.exists) {
      Map<dynamic, dynamic> addressMap =
          snapshot.value as Map<dynamic, dynamic>;
      addressMap.forEach((key, value) {
        final address = CurrentUserData.fromMap(value);
        if (address.email == userGId) {
          addressList.add(address);
        }
      });
    }
    return addressList;
  }

  Future<void> saveSelectedAddress(String email, int selectedOption) async {
    String userId = currentUser!.uid;

    SelectedAddress selectedAddress = SelectedAddress(
        id: userId, email: email, selectedOption: selectedOption);

    await _databaseReference
        .child('selectedAddress')
        .child(userId)
        .child('selectedAddress')
        .set(selectedAddress.toMap());
  }

  Future<SelectedAddress?> loadSelectedAddress() async {
    String userId = currentUser!.uid;
    try {
      DatabaseEvent event = await _databaseReference
          .child('selectedAddress')
          .child(userId)
          .child('selectedAddress')
          .once();
      DataSnapshot snapshot = event.snapshot;

      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      return SelectedAddress.fromMap(data);
    } catch (error) {
      // Handle error
      print("Error loading selected address: $error");
    }
    return null;
  }

  Future<void> placeOrder(Order order) async {
    String? id = _databaseReference.child('orders').push().key;
    order.orderId = id;
    if (id != null) {
      await _databaseReference.child('orders').child(id).set(order.toMap());
      await _databaseReference
          .child('product')
          .child(order.product!.id!)
          .remove();
    }
  }

  Stream<List<Order>> getSoldProductStream({required String email}) {
    if (currentUser == null) {
      return Stream.value([]);
    }
    String userGId = currentUser!.email!;
    return _databaseReference.child("orders").onValue.map((event) {
      List<Order> soldProductList = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          final order = Order.fromMap(value);
          if (order.product!.gId == userGId) {
            soldProductList.add(order);
          }
        });
      }
      return soldProductList;
    });
  }

  Future<bool> deleteOrder(String orderId) async {
    try {
      await _databaseReference.child('orders').child(orderId).remove();
      return true;
    } catch (e) {
      return false;
    }
  }
}
