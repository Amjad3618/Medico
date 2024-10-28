import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../Models/userr_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }

  // Upload profile image
  Future<String> uploadProfileImage({
    required String userId,
    required XFile imageFile,
  }) async {
    try {
      final storageRef = _storage.ref().child('user_images/$userId');

      if (kIsWeb) {
        await storageRef.putData(await imageFile.readAsBytes());
      } else {
        await storageRef.putFile(File(imageFile.path));
      }

      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Create user document in Firestore
  Future<void> createUserDocument({
    required UserrModel user,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.userUid)
          .set(user.toJson());
    } catch (e) {
      throw Exception('Failed to create user document: $e');
    }
  }

  // Complete sign up process
  Future<void> completeSignUpProcess({
    required String email,
    required String password,
    required String name,
    XFile? profileImage,
  }) async {
    try {
      // Create authentication account
      final userCredential = await signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      String imageUrl = '';
      if (profileImage != null) {
        // Upload profile image if provided
        imageUrl = await uploadProfileImage(
          userId: userCredential.user!.uid,
          imageFile: profileImage,
        );
      }

      // Create user model
      final user = UserrModel(
        name: name,
        email: email,
        userUid: userCredential.user!.uid,
        imageUrl: imageUrl,
      );

      // Create user document in Firestore
      await createUserDocument(user: user);
    } catch (e) {
      throw Exception('Sign up process failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}