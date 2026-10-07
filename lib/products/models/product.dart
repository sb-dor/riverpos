class Product {
  Product({required this.id, required this.name, required this.price});

  factory Product.fromJson(Map<String, Object?> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: double.parse('${json['price']}'),
    );
  }

  final int id;
  final String name;
  final double price;
}
