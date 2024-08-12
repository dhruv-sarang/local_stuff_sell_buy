import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_stuff_sell_buy/model/current_user_data.dart';
import '../../constant/app_constant.dart';
import '../../service/firebase_service.dart';
import '../../utils/app_utils.dart';
import '../../widgets/custom_button.dart';

class AddAddress extends StatefulWidget {
  CurrentUserData? currentUserData;
  AddAddress(this.currentUserData, {super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _mNo = '';
  String _pinCode = '';
  String _address = '';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final FirebaseService _service = FirebaseService();
  User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = _service.currentUser;
    _nameController.text = _user!.displayName!.toString();
    _emailController.text = _user!.email!;

    if (widget.currentUserData != null) {
      _mobileController.text = widget.currentUserData!.mobileNo;
      _pinCodeController.text = widget.currentUserData!.pinCode;
      _addressController.text = widget.currentUserData!.address;
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      CurrentUserData add = CurrentUserData(
          name: _user!.displayName!,
          email: _user!.email!,
          imageUrl: _user!.photoURL!,
          mobileNo: _mNo,
          pinCode: _pinCode,
          address: _address,
          createdAt: widget.currentUserData != null
              ? widget.currentUserData!.createdAt
              : DateTime.now().millisecondsSinceEpoch);

      _service
          .addAddress(
              name: _user!.displayName!,
              email: _user!.email!,
              mobileNo: _mNo,
              imageUrl: _user!.photoURL!,
              userId: widget.currentUserData?.id,
              createdAt: widget.currentUserData?.createdAt,
              address: _address,
              pinCode: _pinCode,
              context: context)
          .then(
        (value) {
          if (value) {
            print('Address added successfully');
            Navigator.pop(context, add);
          } else {}
        },
      );
    } else {}
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
                SizedBox(width: 16),
                Text(
                  'Add Address',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        )),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        return AppUtil.validateName(value);
                      },
                      onSaved: (value) {
                        _name = value ?? '';
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        return AppUtil.validateName(value);
                      },
                      onSaved: (value) {
                        _name = value ?? '';
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(labelText: 'Mobile No.'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        return AppUtil.validateValue(value);
                      },
                      onSaved: (value) {
                        _mNo = value ?? '';
                      },
                    ),
                    SizedBox(height: 48),
                    Text('Address',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        )),
                    TextFormField(
                      controller: _pinCodeController,
                      decoration: InputDecoration(labelText: 'Pin Code'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return AppUtil.validateValue(value);
                      },
                      onSaved: (value) {
                        _pinCode = value ?? '';
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                          labelText:
                              'Address (House No, Building, Street, Area)'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        return AppUtil.validateAddress(value);
                      },
                      onSaved: (value) {
                        _address = value ?? '';
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                  ],
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
          text:
              widget.currentUserData != null ? 'Update Address' : 'Add Address',
          textColor: AppConstant.cardTextColor,
          onClick: () {
            _submitForm(context);
          },
        ),
      ),
    );
  }
}
