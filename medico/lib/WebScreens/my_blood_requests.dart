import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBloodRequests extends StatefulWidget {
  const MyBloodRequests({Key? key}) : super(key: key);

  @override
  _MyBloodRequestsState createState() => _MyBloodRequestsState();
}

class _MyBloodRequestsState extends State<MyBloodRequests> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Delete blood donation request
  Future<void> _deleteBloodRequest(String donationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('blooddonations')
          .doc(donationId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blood request deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting blood request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Blood Requests"),
        centerTitle: true,
      ),
      body: user == null
          ? const Center(child: Text("Please log in to view your blood requests"))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('blooddonations')
                  .where('sellerId', isEqualTo: user!.uid) // Filter by logged-in user's sellerId
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No blood requests added yet."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final bloodDonationData = doc.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.bloodtype, size: 40),
                        title: Text(bloodDonationData['bloodtype']),
                        subtitle: Text(
                          "City: ${bloodDonationData['city']}\n"
                          "Hospital: ${bloodDonationData['hospitalname']}\n"
                          "Number: ${bloodDonationData['number']}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteBloodRequest(doc.id),
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
