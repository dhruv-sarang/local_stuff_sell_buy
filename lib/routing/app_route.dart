import 'package:flutter/material.dart';
import 'package:local_stuff_sell_buy/model/current_user_data.dart';
import 'package:local_stuff_sell_buy/model/homeGridData.dart';
import 'package:local_stuff_sell_buy/view/add_address/add_address.dart';
import 'package:local_stuff_sell_buy/view/add_address/view_address.dart';
import 'package:local_stuff_sell_buy/view/buy/buy_view.dart';
import 'package:local_stuff_sell_buy/view/payment/payment_view.dart';
import 'package:local_stuff_sell_buy/view/soldProduct/sold_product.dart';
import '../constant/app_constant.dart';
import '../model/product.dart';
import '../view/category_vise_product/category_vise_view.dart';
import '../view/home/home_view.dart';
import '../view/intro/intro_view.dart';
import '../view/login/login_view.dart';
import '../view/products_list/product_list_view.dart';
import '../view/products_list/products/product_view.dart';
import '../view/splash/splash_view.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstant.splashView:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );

      case AppConstant.introView:
        return MaterialPageRoute(
          builder: (context) => IntroView(),
        );

      case AppConstant.loginView:
        return MaterialPageRoute(
          builder: (context) => LoginView(),
        );

      case AppConstant.homeView:
        return MaterialPageRoute(
          builder: (context) => HomeView(),
        );

      case AppConstant.buyView:
        Product? product =
            settings.arguments != null ? settings.arguments as Product : null;
        return MaterialPageRoute(
          builder: (context) => BuyView(product),
        );

      case AppConstant.catagoryViseProduct:
        HomeGridData? homeGridData = settings.arguments != null
            ? settings.arguments as HomeGridData
            : null;
        return MaterialPageRoute(
          builder: (context) => CategoryViseProductView(homeGridData!),
        );

      case AppConstant.paymentView:
        Product? product =
            settings.arguments != null ? settings.arguments as Product : null;
        return MaterialPageRoute(
          builder: (context) =>
              PaymentView(product: product),
        );

      case AppConstant.addressView:
        return MaterialPageRoute(
          builder: (context) => AddressView(),
        );

      case AppConstant.addAddress:
        CurrentUserData? currentUserData = settings.arguments != null
            ? settings.arguments as CurrentUserData
            : null;
        return MaterialPageRoute(
          builder: (context) => AddAddress(currentUserData),
        );

      case AppConstant.productListView:
        return MaterialPageRoute(
          builder: (context) => ProductListView(),
        );

      case AppConstant.soldProductListView:
        return MaterialPageRoute(
          builder: (context) => SoldProductListView(),
        );

      case AppConstant.productView:
        Product? product =
            settings.arguments != null ? settings.arguments as Product : null;
        return MaterialPageRoute(
          builder: (context) => ProductView(product),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
    }
  }
}
