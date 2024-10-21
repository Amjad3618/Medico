import 'package:flutter/material.dart';

class ProductDetailWeb extends StatefulWidget {
  const ProductDetailWeb({super.key});

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
      isScrollControlled: true, // To allow full screen height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wraps content height
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
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Process the order with user input data
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Product"),
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
                    image: const DecorationImage(
                      image: AssetImage("assets/me2.jfif"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Details
              const ProductInfoRow(
                label: "Seller Name:",
                value: "Amjad Ali",
              ),
              const ProductInfoRow(
                label: "Product Name:",
                value: "My Product",
              ),
              const ProductInfoRow(
                label: "Price:",
                value: "Rs 560",
              ),
              const ProductInfoRow(
                label: "Country:",
                value: "Pakistan",
              ),
              const ProductInfoRow(
                label: "City:",
                value: "Karachi",
              ),
              const ProductInfoRow(
                label: "Donation:",
                value: "Not Applicable",
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
                child: const Text(
                  "This is a detailed description of the product. It contains all the features, specifications, and other relevant details that a buyer might want to know before purchasing.",
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showOrderBottomSheet,
        child:  Icon(Icons.shopping_cart,color: Colors.white,),
        tooltip: 'Order Now',
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Positioning the FAB to the right
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
