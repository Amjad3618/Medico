// firebase_profile_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;

class FirebaseProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get current user profile data
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot doc = 
            await _firestore.collection('users').doc(user.uid).get();
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? email,
    dynamic profileImage, // Can be File, XFile, or html.File
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return false;

      Map<String, dynamic> updateData = {};
      
      // Update name if provided
      if (name != null && name.isNotEmpty) {
        updateData['name'] = name;
      }

      // Update email if provided
      if (email != null && email.isNotEmpty && email != user.email) {
        await user.updateEmail(email);
        updateData['email'] = email;
      }

      // Update profile image if provided
      if (profileImage != null) {
        String imageUrl = await _uploadProfileImage(user.uid, profileImage);
        updateData['profileImageUrl'] = imageUrl;
      }

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updateData);
      }

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Upload profile image
  Future<String> _uploadProfileImage(String userId, dynamic imageFile) async {
    try {
      final Reference storageRef = _storage.ref().child('profile_images/$userId');
      UploadTask uploadTask;

      if (imageFile is html.File) {
        // Web platform
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        uploadTask = storageRef.putBlob(imageFile, metadata);
      } else if (imageFile is File) {
        // Mobile platform
        uploadTask = storageRef.putFile(imageFile);
      } else if (imageFile is XFile) {
        // Handle XFile
        final bytes = await imageFile.readAsBytes();
        uploadTask = storageRef.putData(bytes);
      } else {
        throw Exception('Unsupported image file type');
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      rethrow;
    }
  }
}