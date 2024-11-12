import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medico/MobileScreen/product_detail_mobile.dart';
import 'package:medico/utils/custom_text.dart';


import '../Models/produ_model.dart';
import 'my_products.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  Stream<QuerySnapshot> _getMedicinesStream() {
    return FirebaseFirestore.instance
        .collection('medicines')
        .where('name', isGreaterThanOrEqualTo: _searchQuery)
        .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const MyTextt(
          text: "Free Medico",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (_)=>const MyProducts()));
              },
              child: Image.asset("assets/user.png",height: 30,width: 30,)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                controller: _searchCtrl,
                decoration:  InputDecoration(
                  
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  hintText: "Search..",
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getMedicinesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No medicines found'));
                  }
                  
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final medicine = ProductModel.fromJson(data);

                      return InkWell(
                        onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetailMobile(medicine: medicine,)));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (medicine.productImage != null)
                                  SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        medicine.productImage!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: Icon(Icons.error),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyTextt(text: "Seller name", fontSize: 20, fontWeight: FontWeight.w400),
                                        MyTextt(text: "Product name", fontSize: 20, fontWeight: FontWeight.w400),
                                        MyTextt(text: "Price", fontSize: 20, fontWeight: FontWeight.w400),
                                        MyTextt(text: "Country", fontSize: 20, fontWeight: FontWeight.w400),
                                        MyTextt(text: "City", fontSize: 20, fontWeight: FontWeight.w400),
                                        MyTextt(text: "Donation", fontSize: 20, fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        
                                        MyTextt(text: medicine.name ?? 'N/A', fontSize: 20, fontWeight: FontWeight.w400),
                                        MyTextt(text: medicine.isDonated! ? 'Free' : 'Rs ${medicine.price}', fontSize: 20, fontWeight: FontWeight.w400),
                                        MyTextt(text: medicine.country ?? 'N/A', fontSize: 20, fontWeight: FontWeight.w400),
                                        MyTextt(text: medicine.city ?? 'N/A', fontSize: 20, fontWeight: FontWeight.w400),
                                        MyTextt(text: medicine.isDonated! ? "Yes" : "No", fontSize: 20, fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ],
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}
