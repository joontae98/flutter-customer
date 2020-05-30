class Customer{
  final int id;
  final String name;
  final String price;
  final bool status;

  Customer({this.id, this.name, this.price, this.status});

  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
    id: json["id"],
    name: json['name'],
    price: json['price'],
    status: json['status'] == 1,
  );

  Map<String, dynamic> toMap() => {
    "id":id,
    "name":name,
    "price":price,
    "status":status,
  };

  Map<String, dynamic> toMapAutoID() => {
    "name":name,
    "price":price,
    "status":status,
    };
}