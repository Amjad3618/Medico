class ProductModel {
  String? name;
  String? price;
  String? sellerName;
  String? description;
  String? city;
  bool? isDonated;
  String? productImage;
  String? country;

  var id;

  ProductModel({
    this.name,
    this.price,
    this.sellerName,
    this.description,
    this.city,
    this.isDonated,
    this.productImage,
    this.country,
  });

  // Factory method to create an instance of ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      price: json['price'],
      sellerName: json['sellerName'],
      description: json['description'],
      city: json['city'],
      isDonated: json['isDonated'],
      productImage: json['productImage'],
      country: json['country'],
    );
  }

  // Method to convert ProductModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'sellerName': sellerName,
      'description': description,
      'city': city,
      'isDonated': isDonated,
      'productImage': productImage,
      'country': country,
    };
  }
}
