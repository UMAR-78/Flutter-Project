class Cart{
  String documentid;
  String productid;
  String userid;
  double price;
  int quantity;
  //String image;

  Cart(
      {
        required this.documentid,
        required this.productid,
      required this.userid,
      required this.price,
      required this.quantity
      //required this.image
      });
}