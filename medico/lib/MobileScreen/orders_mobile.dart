import 'package:flutter/material.dart';

class OrderReceivingPageMobile extends StatelessWidget {
  const OrderReceivingPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage("assets/me2.jfif"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Product Information
            const Text(
              "Product Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Product Name: Stylish Chair",
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              "Price: Rs 1200",
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              "Order Quantity: 1",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Buyer Information
            const Text(
              "Buyer Information",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Buyer Name: Ali Raza",
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              "Buyer Email: ali.raza@example.com",
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              "Shipping Address: 123, Clifton Block 5, Karachi",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Order Status
            const Text(
              "Order Status",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Order Placed On: 21st October, 2024",
              style: TextStyle(fontSize: 18),
            ),
            const Text(
              "Order Status: Pending",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

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
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    "Approve Order",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Cancel Order Action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    "Cancel Order",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
