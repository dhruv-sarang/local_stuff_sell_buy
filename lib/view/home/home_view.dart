import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_stuff_sell_buy/model/current_user_data.dart';
import '../../constant/app_constant.dart';
import '../../model/homeGridData.dart';
import '../../model/product.dart';
import '../../service/firebase_service.dart';
import '../login/login_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseService _service = FirebaseService();
  User? _user;
  String? gName, email, imageUrl;
  List<Product> _products = [];
  CurrentUserData? currentUserData;

  @override
  void initState() {
    super.initState();
    _user = _service.currentUser;
    gName = _user!.displayName;
    email = _user!.email;
    imageUrl = _user!.photoURL;
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    List<Product> products = await _service.loadProduct(email: email!);
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  List<HomeGridData> gridList = [
    HomeGridData(
        title: 'Car', imagePath: 'assets/images/car.png', color: Colors.red),
    HomeGridData(
        title: 'Electronics',
        imagePath: 'assets/images/electronics.png',
        color: Colors.orange),
    HomeGridData(
        title: 'Household',
        imagePath: 'assets/images/home.png',
        color: Colors.green.shade900),
    HomeGridData(
        title: 'Clothing',
        imagePath: 'assets/images/cloth.png',
        color: Colors.blue.shade900),
    HomeGridData(
        title: 'Shoes',
        imagePath: 'assets/images/shoes.png',
        color: Colors.purple),
    HomeGridData(
        title: 'Furniture',
        imagePath: 'assets/images/furniture.png',
        color: Colors.red.shade900),
    HomeGridData(
        title: 'Jewelry',
        imagePath: 'assets/images/jewelry.png',
        color: Colors.purple.shade900),
    HomeGridData(
        title: 'Cell Phones',
        imagePath: 'assets/images/phone.png',
        color: Colors.pink.shade900),
  ];

  List<Product> _filteredProducts = [];
  TextEditingController _searchController = TextEditingController();

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: 65,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            _onSearchChanged();
                          },
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 14),
                            prefixIcon: Icon(Icons.location_on,
                                size: 18, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppConstant.catagoryViseProduct,
                                arguments: gridList[index]);
                          },
                          child: Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: gridList[index].color,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  gridList[index].imagePath,
                                  color: Colors.grey.shade200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${gridList[index].title}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: gridList.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Divider(thickness: 2, color: Colors.grey.shade400),
                ),
              ),
              SliverStaggeredGrid.countBuilder(
                crossAxisCount: 3, // Number of columns
                itemCount: _filteredProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  Product product = _filteredProducts[index];

                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppConstant.buyView,
                            arguments: product);
                        print(_filteredProducts[index].name);
                      },
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: _filteredProducts[index].imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) =>
                    const StaggeredTile.fit(1), // Adjust size as needed
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade300,
                    foregroundImage: NetworkImage('${imageUrl}'),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('${gName}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 22)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${email}',
                        style: TextStyle(
                            color: Colors.grey.shade200, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppConstant.addressView);
                        },
                        child: Icon(
                          Icons.edit,
                          size: 24,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: AppConstant.appBarColor,
              ),
            ),
            ListTile(
              title: Text('Sell Product'),
              onTap: () {
                Navigator.pushNamed(context, AppConstant.productListView);
              },
            ),
            ListTile(
              title: Text('Sold Product'),
              onTap: () {
                Navigator.pushNamed(context, AppConstant.soldProductListView);
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showAlertDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text('Are you sure you want to Logout'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              _service.logout().then((value) {
                if (value) {
                  _user = null;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginView(),
                      ),
                      (route) => false);
                }
              });
            },
            child: Text('Yes'),
          )
        ],
      ),
    );
  }
}
