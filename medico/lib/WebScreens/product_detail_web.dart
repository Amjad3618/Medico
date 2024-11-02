import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetailWeb extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const ProductDetailWeb({
    super.key,
    required this.productId,
    required this.productData,
  });

  @override
  State<ProductDetailWeb> createState() => _ProductDetailWebState();
}

class _ProductDetailWebState extends State<ProductDetailWeb> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for user input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Function to show bottom sheet for user input
  void _showOrderBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Order Product',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // Name Input
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Your Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Your Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Address Input
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Shipping Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // City Input
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Phone Number Input
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 11) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Process the order with user input data
                      await _submitOrder();
                      Navigator.pop(context); // Close the bottom sheet
                    }
                  },
                  child: const Text('Submit Order'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to submit the order to Firestore
  Future<void> _submitOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle user not logged in case if needed
      return;
    }

    // Create an order data map
    final orderData = {
      'productId': widget.productId,
      'userId': user.uid,
      'name': _nameController.text,
      'email': _emailController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'phone': _phoneNumberController.text,
      'timestamp': FieldValue.serverTimestamp(), // Optional: Add timestamp
    };

    try {
      // Add order data to Firestore in the 'orders' collection
      await FirebaseFirestore.instance.collection('orders').add(orderData);
      // Optionally, you can show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
    } catch (e) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order: $e')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Product Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(widget.productData['productImage'] ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Details
              ProductInfoRow(
                label: "Seller Name:",
                value: widget.productData['sellerName'] ?? "N/A",
              ),
              ProductInfoRow(
                label: "Product Name:",
                value: widget.productData['name'] ?? "N/A",
              ),
              ProductInfoRow(
                label: "Price:",
                value: "Rs ${widget.productData['price'] ?? 'N/A'}",
              ),
              ProductInfoRow(
                label: "Country:",
                value: widget.productData['country'] ?? "N/A",
              ),
              ProductInfoRow(
                label: "City:",
                value: widget.productData['city'] ?? "N/A",
              ),
              ProductInfoRow(
                label: "Donation:",
                value: widget.productData['donation'] ?? "Not Applicable",
              ),

              const SizedBox(height: 20),

              // Description Section
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  widget.productData['description'] ?? "No description available.",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange,),
                    onPressed: _showOrderBottomSheet,
                    child: const Text("Order"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Custom widget to display product info row
class ProductInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProductInfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          children: [
            TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' $value'),
          ],
        ),
      ),
    );
  }
}
