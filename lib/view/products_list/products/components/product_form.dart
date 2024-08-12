import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constant/app_constant.dart';
import '../../../../model/category.dart';
import '../../../../model/product.dart';
import '../../../../service/firebase_service.dart';
import '../../../../utils/app_utils.dart';
import '../../../../widgets/custom_button.dart';

class ProductForm extends StatefulWidget {
  Product? product;
  ProductForm(this.product, {super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final List<Category> _categories = [
    Category(name: "Car"),
    Category(name: "Electronics"),
    Category(name: "Household"),
    Category(name: "Clothing"),
    Category(name: "Shoes"),
    Category(name: "Furniture"),
    Category(name: "Jewelry"),
    Category(name: "Cell Phones"),
  ];

  String _name = '';
  String _desc = '';
  XFile? _newImage;
  int? _price;
  String? _selectedCategoryId;
  String _selectedCategory = '';
  String? existingImageUrl;

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();

  final FirebaseService _service = FirebaseService();
  User? _user;
  String? email, gName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.product != null) {
      existingImageUrl = widget.product!.imageUrl;
      _nameController.text = widget.product!.name;
      _descController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _selectedCategoryId = widget.product!.selectedCategory;
    }
    _user = _service.currentUser;
    email = _user!.email;
    gName = _user!.displayName;
    print(email);
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (existingImageUrl != null || _newImage != null) {
        _formKey.currentState!.save();
        _service
            .addProduct(
                productId: widget.product?.id,
                gId: email!,
                gName: gName!,
                name: _name,
                desc: _desc,
                price: _price!,
                newImage: _newImage,
                selectedCategory: _selectedCategory,
                createdAt: widget.product?.createdAt,
                existingImageUrl: existingImageUrl,
                context: context)
            .then(
          (value) {
            if (value) {
              print('Product added successfully');
              Navigator.pop(context);
            } else {}
          },
        );
      } else {}
    }
  }

  Future<void> _pickImage() async {
    var image = await AppUtil.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _newImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    child: Card(
                      child: Container(
                        height: 150,
                        width: 150,
                        child: _newImage == null && existingImageUrl != null
                            ? Container(
                                height: 150,
                                width: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    existingImageUrl!,
                                  ),
                                ),
                              )
                            : _newImage != null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      child: Image.file(
                                        File(_newImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
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
                  controller: _descController,
                  decoration: InputDecoration(labelText: 'Product Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    return AppUtil.validateDescription(value);
                  },
                  onSaved: (value) {
                    _desc = value ?? '';
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    return AppUtil.validateValue(value);
                  },
                  onSaved: (value) {
                    _price = int.parse(value!);
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: InputDecoration(labelText: 'Select Category'),
                  items: _categories
                      .map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.name,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategoryId = value!;
                    });
                  },
                  onSaved: (newValue) {
                    _selectedCategory = newValue!;
                    _selectedCategory = _categories
                        .firstWhere((element) => element.name == newValue)
                        .name;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                CustomButton(
                  backgroundColor: AppConstant.cardColor,
                  text:
                      widget.product != null ? 'Update Product' : 'Add Product',
                  textColor: AppConstant.cardTextColor,
                  onClick: () {
                    setState(() {
                      if (_newImage == null && existingImageUrl == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select an Image'),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                    });
                    _submitForm(context);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
