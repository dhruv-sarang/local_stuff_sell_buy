import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_stuff_sell_buy/model/current_user_data.dart';
import 'package:local_stuff_sell_buy/widgets/custom_button.dart';
import '../../constant/app_constant.dart';
import '../../model/selectedAddress.dart';
import '../../service/firebase_service.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  final FirebaseService _service = FirebaseService();

  int? selectedOption;
  List<CurrentUserData> _address = [];

  Future<void> _loadAddress() async {
    List<CurrentUserData> address = await _service.loadAddress(email: email!);
    setState(() {
      _address = address;
    });
  }

  User? _user;
  String? email;

  SelectedAddress? _selectedAddress;

  Future<void> _loadSelectedAddress() async {
    SelectedAddress? selectedAddress = await _service.loadSelectedAddress();
    setState(() {
      _selectedAddress = selectedAddress;
      selectedOption = _selectedAddress?.selectedOption;
      print('Option  :  ${_selectedAddress?.selectedOption}');
      print('Option  :  ${_selectedAddress?.email}');
    });
  }

  @override
  void initState() {
    super.initState();
    _user = _service.currentUser;
    email = _user!.email;
    _loadAddress();
    _loadSelectedAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppConstant.appBarColor,
            title: Text('Select Address'),
            floating: true,
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, AppConstant.addAddress)
                      .then((result) {
                    if (result != null) {
                      CurrentUserData newAddress = result as CurrentUserData;
                      setState(() {
                        _address.add(newAddress);
                      });
                    }
                  });
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var address = _address[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppConstant.addAddress,
                          arguments: address);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Radio(
                              value: index,
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                  print('selectedOption : ${selectedOption}');
                                });
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${address.name}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                      '${address.address}, ${address.pinCode}'),
                                  Text('Mobile : ${address.mobileNo}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: _address.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          backgroundColor: AppConstant.cardColor,
          text: 'Save',
          textColor: Colors.black,
          onClick: () async {
            if (selectedOption! >= 0 && selectedOption! < _address.length) {
              await _service.saveSelectedAddress(email!, selectedOption!);
              SelectedAddress newSelectedAddress = SelectedAddress(
                  selectedOption: selectedOption!, email: email!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected address saved!'),
                ),
              );
              Navigator.pop(context, newSelectedAddress);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select an address first.'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
