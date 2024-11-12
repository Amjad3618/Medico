import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class ProfileScreenweb extends StatefulWidget {
  const ProfileScreenweb({super.key});

  @override
  State<ProfileScreenweb> createState() => _ProfileScreenwebState();
}

class _ProfileScreenwebState extends State<ProfileScreenweb> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = true;
  String? _currentImageUrl;
  XFile? _pickedImage;
  Uint8List? _webImage;
  bool _isEmailVerified = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        final DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) { 
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = data['name'] ?? '';
            _emailController.text = user.email ?? '';
            _currentImageUrl = data['profileImageUrl'];
            _isEmailVerified = user.emailVerified;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent! Please check your inbox.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending verification email: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_pickedImage == null) return null;
    try {
      final User? user = _auth.currentUser;
      if (user == null) throw Exception("No user logged in");

      final String filePath = 'profileImages/${user.uid}.png';
      final ref = _storage.ref().child(filePath);

      if (kIsWeb) {
        await ref.putData(await _pickedImage!.readAsBytes());
      } else {
        await ref.putFile(File(_pickedImage!.path));
      }

      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _submitProfile() async {
    setState(() => _isLoading = true);

    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      bool emailChanged = _emailController.text.trim() != user.email;

      if (emailChanged && !user.emailVerified) {
        final bool? proceedWithoutEmail = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Email Verification Required'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your email needs to be verified before you can change it.'),
                  const SizedBox(height: 16),
                  if (!_isEmailVerified)
                    ElevatedButton(
                      onPressed: () {
                        _sendVerificationEmail();
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Send Verification Email'),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Save Without Email Change'),
                ),
              ],
            );
          },
        );

        if (proceedWithoutEmail == null || !proceedWithoutEmail) {
          setState(() => _isLoading = false);
          return;
        }

        _emailController.text = user.email ?? '';
      }

      String? newImageUrl;
      if (_pickedImage != null) {
        newImageUrl = await _uploadImage();
      }

      final Map<String, dynamic> updateData = {
        'name': _nameController.text,
      };

      if (newImageUrl != null) {
        updateData['profileImageUrl'] = newImageUrl;
      }

      await _firestore.collection('users').doc(user.uid).update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      setState(() {
        _isEditing = false;
        if (newImageUrl != null) {
          _currentImageUrl = newImageUrl;
        }
        _pickedImage = null;
        _webImage = null;
      });
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  ImageProvider _getImageProvider() {
    if (_pickedImage != null) {
      return FileImage(File(_pickedImage!.path));
    } else if (_currentImageUrl != null) {
      return NetworkImage(_currentImageUrl!);
    } else {
      return const AssetImage('assets/default_avatar.png');
    }
  }

  Future<void> _deleteProduct(String productId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('medicines').doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _pickedImage = null;
                  _webImage = null;
                  _loadUserProfile();
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          width: screenSize.width > 800 ? 600 : screenSize.width * 0.85,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _isEditing ? _pickImage : null,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _getImageProvider(),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: const OutlineInputBorder(),
                      enabled: _isEditing,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: const OutlineInputBorder(),
                      enabled: _isEditing,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: _submitProfile,
                      child: const Text("Save"),
                    ),
                  const SizedBox(height: 20),
                 StreamBuilder<QuerySnapshot>(
  stream: _firestore
      .collection('medicines')
      .where('userId', isEqualTo: _auth.currentUser!.uid)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return const Text('Error loading products');
    }
    if (!snapshot.hasData) {
      return const CircularProgressIndicator();
    }

    final products = snapshot.data!.docs;

    if (products.isEmpty) {
      return const Text('No products found');
    }

    return Expanded(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final productName = product['name'] ?? 'Unnamed Product';
          final productPrice = product['price'] ?? 'Unknown Price';
          final productImage = product['productImage'] ?? '';

          return ListTile(
            leading: productImage.isNotEmpty
                ? Image.network(productImage, width: 50, height: 50, fit: BoxFit.cover)
                : const Icon(Icons.image_not_supported),
            title: Text(productName),
            subtitle: Text('Price: $productPrice'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteProduct(product.id),
            ),
          );
        },
      ),
    );
  },
),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
