import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart_app/cart_provider.dart';
import 'package:shopping_cart_app/cart_screen.dart';
import 'package:shopping_cart_app/db_helper.dart';
import 'package:shopping_cart_app/model.dart';

class ProductLiatScreen extends StatefulWidget {
  const ProductLiatScreen({super.key});

  @override
  State<ProductLiatScreen> createState() => _ProductLiatScreenState();
}

class _ProductLiatScreenState extends State<ProductLiatScreen> {
  // this is for initialse database
  DB_helper? dBhelper = DB_helper();

  // this is list of fruits
  List<String> productName = [
    "Mango ",
    "Orange",
    "Grapes",
    "Banana",
    "Cherry",
    "Peach ",
    "  Mix   "
  ];
  List<String> productUnit = [
    "  KG   ",
    "Dozen",
    "  KG   ",
    "Dozen",
    "  KG   ",
    "Dozen",
    "  KG   "
  ];

  // this is list of price
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  // tjis is list of Pictures
  List<String> productImage = [
    "mango.jpg",
    "orange.jpg",
    "grapes.jpg",
    "banana.jpg",
    "cherry.jpg",
    "peach.jpg",
    "mix.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    final Cart = Provider.of<Cart_provider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Product List"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => cart_Screen()));
            },
            // this is for notification number animation if a product is added
            child: badges.Badge(
              badgeAnimation: badges.BadgeAnimation.slide(
                  animationDuration: Duration(milliseconds: 300)),
              badgeContent: Consumer<Cart_provider>(
                builder: (context, value, child) {
                  return Text(value.getCounter().toString(),
                      style: TextStyle(color: Colors.white));
                },
              ),
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                // here image is called
                                Image(
                                    height: 80,
                                    width: 80,
                                    image: AssetImage(
                                        "assets/images/${productImage[index].toString()}")),
                                // here fruit names are called
                                Text(
                                  productName[index].toString(),
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 98,
                                ),
                                // here prices are called
                                Text(
                                  "Price ${productPrice[index].toString()}",
                                  style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 190,
                                    children: [
                                      // here units are called KG/Dozen
                                      Text(
                                        productUnit[index].toString(),
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // here data is insert
                                          dBhelper!
                                              .insert(cart(
                                                id: index,
                                                productid: index.toString(),
                                                productname: productName[index]
                                                    .toString(),
                                                unit_tag: productUnit[index]
                                                    .toString(),
                                                image: productImage[index]
                                                    .toString(),
                                                initail_price:
                                                    productPrice[index],
                                                product_price:
                                                    productPrice[index],
                                                quantity: 1,
                                              ))
                                              .then((value) => {
                                                    print("cart is added"),
                                                    Cart.addTotalprice(
                                                        double.parse(
                                                            productPrice[index]
                                                                .toString())),
                                                    Cart.addCounter(),
                                                  })
                                              .onError((error, stackTrace) =>
                                                  {print("error found")});
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            width: 80,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(9)),
                                            child: Text("add to cart")),
                                      ),
                                    ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
