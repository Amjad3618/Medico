import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({Key? key}) : super(key: key);

  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _deleteMedicine(String medicineId) async {
    try {
      await FirebaseFirestore.instance
          .collection('medicines')
          .doc(medicineId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting medicine: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Medicines"),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(child: Text("Please log in to view your medicines"))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('medicines')
                  .where('sellerId', isEqualTo: user!.uid) // Filter by logged-in user's ID
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No medicines added yet."));
                }

                final medicineDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: medicineDocs.length,
                  itemBuilder: (context, index) {
                    final doc = medicineDocs[index];
                    final medicineData = doc.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(medicineData['productImage']),
                          onBackgroundImageError: (_, __) => const Icon(Icons.error),
                        ),
                        title: Text(medicineData['name'] ?? 'No Name'),
                        subtitle: Text("Price: ${medicineData['price'] ?? 'N/A'}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteMedicine(doc.id),
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
