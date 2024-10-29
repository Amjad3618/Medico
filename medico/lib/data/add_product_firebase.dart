import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/produ_model.dart';
import 'dart:html' as html;

class FirebaseServiceaaMedicines {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> uploadImage(html.File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef =
          _storage.ref().child('medicine_images/$fileName.jpg');
      final UploadTask uploadTask = storageRef.putBlob(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Return null if upload fails
    }
  }

  Future<void> addProductData(ProductModel product) async {
    try {
      await _firestore.collection('medicines').add(product.toJson());
    } catch (e) {
      print('Error adding product data: $e');
      throw e; // Re-throw for UI-level error handling
    }
  }
}
