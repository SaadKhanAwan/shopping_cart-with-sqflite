import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shopping_cart_app/model.dart';
import 'cart_provider.dart';
import 'db_helper.dart';

class cart_Screen extends StatefulWidget {
  const cart_Screen({super.key});

  @override
  State<cart_Screen> createState() => _cart_ScreenState();
}

class _cart_ScreenState extends State<cart_Screen> {
  DB_helper? dBhelper = DB_helper();

  @override
  Widget build(BuildContext context) {
    final Cart = Provider.of<Cart_provider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Product"),
        actions: [
          // this is for notification animation
          badges.Badge(
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
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              //this  Cart is define upper
              future: Cart.getdata(),
              builder: (context, AsyncSnapshot<List<cart>> snapshot) {
                // here is data fetch
                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
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
                                        // here image is fetch
                                        Image(
                                            height: 80,
                                            width: 80,
                                            image: AssetImage(
                                                "assets/images/${snapshot.data![index].image.toString()}")),
                                        // here fruit names are fetch
                                        Text(
                                          snapshot.data![index].productname
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 65,
                                        ),
                                        // here prouduct price is fetch
                                        Text(
                                          "Price ${snapshot.data![index].product_price.toString()}",
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              // this is to delete the whole product
                                              dBhelper!.delete(
                                                  snapshot.data![index].id!);
                                              Cart.removeCounter();
                                              Cart.removeTotalprice(
                                                  double.parse(snapshot
                                                      .data![index]
                                                      .product_price
                                                      .toString()));
                                            },
                                            child: Icon(Icons.delete))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Wrap(
                                            // this is to fetch units
                                            direction: Axis.horizontal,
                                            spacing: 190,
                                            children: [
                                              Text(
                                                snapshot.data![index].unit_tag
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Container(
                                                height: 35,
                                                width: 85,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                          // this is for decrese number of one specific items and the price
                                                          onTap: () {
                                                            int quantity =
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .quantity!;
                                                            int price = snapshot
                                                                .data![index]
                                                                .initail_price!;
                                                            quantity--;
                                                            int? new_Price =
                                                                price *
                                                                    quantity;
                                                            if (quantity > 0) {
                                                              dBhelper!
                                                                  .updateQuantity(
                                                                      cart(
                                                                id: snapshot
                                                                    .data![
                                                                        index]
                                                                    .id!,
                                                                productid: snapshot
                                                                    .data![
                                                                        index]
                                                                    .id!
                                                                    .toString(),
                                                                productname: snapshot
                                                                    .data![
                                                                        index]
                                                                    .productname
                                                                    .toString(),
                                                                unit_tag: snapshot
                                                                    .data![
                                                                        index]
                                                                    .unit_tag
                                                                    .toString(),
                                                                image: snapshot
                                                                    .data![
                                                                        index]
                                                                    .image
                                                                    .toString(),
                                                                initail_price:
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .initail_price!,
                                                                product_price:
                                                                    new_Price,
                                                                quantity:
                                                                    quantity,
                                                              ))
                                                                  .then(
                                                                      (value) {
                                                                new_Price = 0;
                                                                quantity = 0;
                                                                Cart.removeTotalprice(
                                                                    double.parse(snapshot
                                                                        .data![
                                                                            index]
                                                                        .initail_price
                                                                        .toString()));
                                                              }).onError((error,
                                                                      stackTrace) {
                                                                print(
                                                                    "error in update");
                                                              });
                                                            }
                                                          },
                                                          child: Icon(
                                                              Icons.remove)),
                                                      Text(snapshot
                                                          .data![index].quantity
                                                          .toString()),
                                                      InkWell(
                                                          onTap: () {
                                                            // this is for increse number of a specific items and price
                                                            int quantity =
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .quantity!;
                                                            int price = snapshot
                                                                .data![index]
                                                                .initail_price!;
                                                            quantity++;
                                                            int? new_Price =
                                                                price *
                                                                    quantity;
                                                            dBhelper!
                                                                .updateQuantity(
                                                                    cart(
                                                              id: snapshot
                                                                  .data![index]
                                                                  .id!,
                                                              productid: snapshot
                                                                  .data![index]
                                                                  .id!
                                                                  .toString(),
                                                              productname: snapshot
                                                                  .data![index]
                                                                  .productname
                                                                  .toString(),
                                                              unit_tag: snapshot
                                                                  .data![index]
                                                                  .unit_tag
                                                                  .toString(),
                                                              image: snapshot
                                                                  .data![index]
                                                                  .image
                                                                  .toString(),
                                                              initail_price:
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .initail_price!,
                                                              product_price:
                                                                  new_Price,
                                                              quantity:
                                                                  quantity,
                                                            ))
                                                                .then((value) {
                                                              new_Price = 0;
                                                              quantity = 0;
                                                              Cart.addTotalprice(
                                                                  double.parse(snapshot
                                                                      .data![
                                                                          index]
                                                                      .initail_price
                                                                      .toString()));
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              print(
                                                                  "error in update");
                                                            });
                                                          },
                                                          child:
                                                              Icon(Icons.add)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }));
                }
                return Text("");
              }),
          Consumer<Cart_provider>(builder: (context, value, child) {
            return Visibility(
                visible: value.get_totalprice().toStringAsFixed(2) == '0.0'
                    ? false
                    : true,
                child: Column(
                  children: [
                    reueable(
                        title: 'Total=',
                        value: r'$' + value.get_totalprice().toStringAsFixed(2))
                  ],
                ));
          })
        ],
      ),
    );
  }
}

class reueable extends StatelessWidget {
  final String title, value;
  const reueable({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text(value,
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
        ],
      ),
    );
  }
}
