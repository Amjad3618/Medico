import 'package:flutter/material.dart';

class OrderReceivingPageWeb extends StatelessWidget {
  const OrderReceivingPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),  // Increased padding for web
        child: Center(
          child: Container(
            width: screenSize.width > 1000 ? 800 : screenSize.width * 0.9,  // Set max width for web
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  height: screenSize.height * 0.4,  // Increased height for larger screens
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage("assets/me2.jfif"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),  // Increased padding for better spacing

                // Product Information
                const Text(
                  "Product Information",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),  // Larger font for web
                ),
                const SizedBox(height: 15),
                const Text(
                  "Product Name: Stylish Chair",
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  "Price: Rs 1200",
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  "Order Quantity: 1",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),

                // Buyer Information
                const Text(
                  "Buyer Information",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Buyer Name: Ali Raza",
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  "Buyer Email: ali.raza@example.com",
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  "Shipping Address: 123, Clifton Block 5, Karachi",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),

                // Order Status
                const Text(
                  "Order Status",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Order Placed On: 21st October, 2024",
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  "Order Status: Pending",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 40),  // More space before the buttons

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Approve Order Action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),  // Increased padding for web
                      ),
                      child: const Text(
                        "Approve Order",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Cancel Order Action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),  // Increased padding for web
                      ),
                      child: const Text(
                        "Cancel Order",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
