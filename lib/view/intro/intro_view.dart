import 'package:flutter/material.dart';
import '../../constant/app_constant.dart';
import '../../model/item.dart';
import '../../preference/pref_utils.dart';
import '../../widgets/custom_button.dart';
import 'components/indicator.dart';
import 'components/slide_view.dart';

class IntroView extends StatefulWidget {
  const IntroView({super.key});
  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  int _currentIndex = 0;
  PageController _controller = PageController();

  List<Item> itemList = [
    Item(
        title: 'Sell Or Buy',
        desc:
            'A Mobile application that allows users to browse, select, purchase, and track products or services from a range of online stores or retailers. The application can be accessed by or downloaded as a mobile app on a smartphone or tablet.',
        image: 'assets/images/on_boarding_1.png'),
    Item(
        title: 'Purchase',
        desc:
            'A Mobile application that allows users to browse, select, purchase, and track products or services from a range of online stores or retailers. The application can be accessed by or downloaded as a mobile app on a smartphone or tablet.',
        image: 'assets/images/on_boarding_2.png'),
    Item(
        title: 'Delivery',
        desc:
            'A Mobile application that allows users to browse, select, purchase, and track products or services from a range of online stores or retailers. The application can be accessed by or downloaded as a mobile app on a smartphone or tablet.',
        image: 'assets/images/on_boarding_3.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (value) {
                setState(() {
                  print(value);
                  _currentIndex = value;
                });
              },
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                Item item = itemList[index];
                return SlideView(item);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < itemList.length; i++)
                if (i == _currentIndex)
                  getIndicator(true)
                else
                  getIndicator(false)
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 0, 70, 50),
            child: CustomButton(
              textColor: AppConstant.cardTextColor,
              backgroundColor: AppConstant.cardColor,
              text: _currentIndex == itemList.length - 1 ? 'FINISH' : 'NEXT',
              onClick: () async {
                if (_currentIndex != itemList.length - 1) {
                  _currentIndex++;
                  // navigate to next page
                  _controller.animateToPage(_currentIndex,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear);
                } else {
                  await PrefUtils.updateOnboardingStatus(true);
                  // navigate to login page
                  Navigator.pushReplacementNamed(
                      context, AppConstant.loginView);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
