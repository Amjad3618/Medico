import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/bloodmodel.dart';

class BloodViewMobile extends StatefulWidget {
  const BloodViewMobile({super.key});

  @override
  State<BloodViewMobile> createState() => _BloodViewMobileState();
}

class _BloodViewMobileState extends State<BloodViewMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Requests'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('blooddonations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No blood requests found."));
          }

          final bloodRequests = snapshot.data!.docs.map((doc) {
            final bloodRequest =
                Bloodmodel.fromJson(doc.data() as Map<String, dynamic>);
            print(
                bloodRequest.hospitalname); // Check if hospital name is fetched
            print(bloodRequest.number); // Check if phone number is fetched
            return bloodRequest;
          }).toList();

          return ListView.builder(
            itemCount: bloodRequests.length,
            itemBuilder: (context, index) {
              final bloodRequest = bloodRequests[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(bloodRequest.bloodtype ?? '-'),
                    backgroundColor: Colors.red,
                  ),
                  title:
                      Text('Hospital: ${bloodRequest.hospitalname ?? "N/A"}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('City: ${bloodRequest.city ?? "N/A"}'),
                      Text('Phone: ${bloodRequest.number ?? "N/A"}'),
                      Text(bloodRequest.description ?? ""),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
