import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderRecevingPageWeb extends StatelessWidget {
  const OrderRecevingPageWeb({Key? key}) : super(key: key);

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
              final order = orders[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(order['name'] ?? 'N/A'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product ID: ${order['productId']}'),
                      Text('Email: ${order['email']}'),
                      Text('Address: ${order['address']}'),
                      Text('City: ${order['city']}'),
                      Text('Phone: ${order['phone']}'),
                    ],
                  ),
                  trailing: Text('Ordered on: ${order['timestamp']?.toDate().toString() ?? ''}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
