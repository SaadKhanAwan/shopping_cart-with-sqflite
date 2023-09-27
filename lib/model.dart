class cart {
  late final int? id;
  final String? productid;
  final String? productname;
  final String? unit_tag;
  final String? image;
  final int? initail_price;
  final int? product_price;
  final int? quantity;
  cart({
    required this.id,
    required this.productid,
    required this.productname,
    required this.unit_tag,
    required this.image,
    required this.initail_price,
    required this.product_price,
    required this.quantity,
  });

  cart.formMap(Map<dynamic, dynamic> res)
      : id = res["id"],
        productid = res["productid"],
        productname = res["productname"],
        unit_tag = res["unit_tag"],
        image = res["image"],
        initail_price = res["initail_price"],
        product_price = res["product_price"],
        quantity = res["quantity"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productid': productid,
      'productname': productname,
      'unit_tag': unit_tag,
      'image': image,
      'initail_price': initail_price,
      'product_price': product_price,
      'quantity': quantity
    };
  }
}
