import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Color backgroundColor;
  String text;
  Color textColor;
  VoidCallback onClick;

  CustomButton(
      {super.key,
      required this.backgroundColor,
      required this.text,
      required this.textColor,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
