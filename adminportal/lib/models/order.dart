class Order {
  final String documentid;
  final String productid;
  final String userid;
  final int quantity;
  final double price;
  final String status;

  Order({
    required this.documentid,
    required this.productid,
    required this.userid,
    required this.quantity,
    required this.price,
    required this.status,
  });
}