class ProductModel {
  String? name;
  String? price;
  String? description;
  String? city;
  bool? isDonated;
  String? productImage;
  String? country;
  String? productId;
  String? sellerId; // New field to store the ID of the user who added the product

  ProductModel({
    this.name,
    this.price,
    this.description,
    this.city,
    this.isDonated,
    this.productImage,
    this.country,
    this.productId,
    this.sellerId, // Initialize the new field in the constructor
  });

  // Factory method to create an instance of ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'],
      price: json['price'],
      description: json['description'],
      city: json['city'],
      isDonated: json['isDonated'],
      productImage: json['productImage'],
      country: json['country'],
      productId: json['productId'],
      sellerId: json['sellerId'], // Assign the sellerId from JSON
    );
  }

  // Method to convert ProductModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'city': city,
      'isDonated': isDonated,
      'productImage': productImage,
      'country': country,
      'productId': productId,
      'sellerId': sellerId, // Include sellerId in the JSON output
    };
  }

  static fromMap(Map<String, dynamic> data) {}
}
