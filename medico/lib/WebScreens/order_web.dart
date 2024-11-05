import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderRecevingPageWeb extends StatefulWidget {
  const OrderRecevingPageWeb({Key? key}) : super(key: key);

  @override
  _OrderRecevingPageWebState createState() => _OrderRecevingPageWebState();
}

class _OrderRecevingPageWebState extends State<OrderRecevingPageWeb> {
  // Function to cancel an order
  Future<void> _cancelOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
      PaintingBinding.instance.imageCache.clear(); // Clear the image cache after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel order: $error')),
      );
    }
  }

  // Function to show a confirmation dialog with product name
  Future<void> _showDeleteConfirmationDialog(String orderId, String productName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete the order for "$productName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    // If confirmed, proceed with deletion
    if (confirm == true) {
      _cancelOrder(orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders placed yet.'));
          }

          // List of order documents
          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;
              final productName = orderData['name'] ?? 'Unknown Product';
              final productImage = orderData['productImage'];

              return GestureDetector(
                onTap: () => _showDeleteConfirmationDialog(orderId, productName),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: (productImage != null && productImage.isNotEmpty)
                        ? Image.network(
                            productImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Log error to console to help with debugging
                              print("Error loading image for product $productName: $error");
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          )
                        : const Icon(Icons.image, size: 50), // Placeholder if no image URL
                    title: Text(productName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Product ID: ${orderData['productId'] ?? 'N/A'}'),
                        Text('Email: ${orderData['email'] ?? 'N/A'}'),
                        Text('Address: ${orderData['address'] ?? 'N/A'}'),
                        Text('City: ${orderData['city'] ?? 'N/A'}'),
                        Text('Phone: ${orderData['phone'] ?? 'N/A'}'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ordered on: ${orderData['timestamp']?.toDate().toString() ?? ''}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _showDeleteConfirmationDialog(orderId, productName),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size(70, 30),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
