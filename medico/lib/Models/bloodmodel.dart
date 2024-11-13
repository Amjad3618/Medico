class Bloodmodel {
  String? bloodtype;
  String? number;
  String? hospitalname;
  String? description;
  String? city;
  String? productId;
  String? sellerId; // ID of the user who added the product

  Bloodmodel({
    this.bloodtype,
    this.number,
    this.hospitalname,
    this.description,
    this.city,
    this.productId,
    this.sellerId,
  });

  // Factory method to create an instance of Bloodmodel from JSON
  factory Bloodmodel.fromJson(Map<String, dynamic> json) {
    return Bloodmodel(
      bloodtype: json['bloodtype'],
      number: json['number'],
      hospitalname: json['hospitalname'],
      description: json['description'],
      city: json['city'],
      productId: json['productId'],
      sellerId: json['sellerId'],
    );
  }

  // Method to convert Bloodmodel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'bloodtype': bloodtype,
      'number': number,
      'hospitalname': hospitalname,
      'description': description,
      'city': city,
      'productId': productId,
      'sellerId': sellerId,
    };
  }
}
