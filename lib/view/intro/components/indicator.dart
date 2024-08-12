import 'package:flutter/material.dart';
import '../../../constant/app_constant.dart';

Widget getIndicator(bool isActive) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 3),
    height: isActive ? 12 : 10,
    width: isActive ? 35 : 10,
    decoration: BoxDecoration(
      color: isActive ? AppConstant.cardColor : Colors.grey,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
