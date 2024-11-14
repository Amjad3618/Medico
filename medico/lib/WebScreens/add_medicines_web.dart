import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // Use for cross-platform image picking
import 'dart:io'; // for File type

import '../Models/produ_model.dart';
import '../utils/custom_text.dart';
import '../utils/custome_form.dart';

class AddMedicineWeb extends StatefulWidget {
  const AddMedicineWeb({Key? key}) : super(key: key);

  @override
  State<AddMedicineWeb> createState() => _AddMedicineWebState();
}

class _AddMedicineWebState extends State<AddMedicineWeb> {
  bool isDonation = false;
  bool isLoading = false;
  XFile? _imageFile; // For cross-platform compatibility
  String? _imagePreviewUrl;

  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<String> _cities = [
    "Karachi", "Lahore", "Islamabad", "Rawalpindi", "Faisalabad",
    "Multan", "Peshawar", "Quetta", "Sialkot", "Hyderabad"
  ];

  String? _selectedCity;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('medicine_images')
          .child('$fileName.jpg');

      final UploadTask uploadTask = storageRef.putFile(File(_imageFile!.path));
      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  Future<void> _saveMedicineData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage();
      }

      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image')),
        );
        setState(() => isLoading = false);
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        setState(() => isLoading = false);
        return;
      }

      final String sellerId = user.uid;
      final DocumentReference docRef = FirebaseFirestore.instance.collection('medicines').doc();

      final product = ProductModel(
        name: _medicineNameController.text,
        price: isDonation ? "0" : _priceController.text,
        description: _descriptionController.text,
        city: _selectedCity,
        isDonated: isDonation,
        productImage: imageUrl,
        country: _countryController.text,
        productId: docRef.id,
        sellerId: user.uid,
      );

      await docRef.set(product.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine added successfully!')),
      );

      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _clearForm() {
    _medicineNameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _countryController.clear();
    _phoneController.clear();
    setState(() {
      _selectedCity = null;
      _imageFile = null;
      _imagePreviewUrl = null;
      isDonation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTextt(
          text: "Add Medicine",
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          controller: _medicineNameController,
                          hintText: "Medicine Name",
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter medicine name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            if (!isDonation)
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _priceController,
                                  hintText: "Price",
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (!isDonation && (value?.isEmpty ?? true)) {
                                      return 'Please enter price';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            if (!isDonation) const SizedBox(width: 20),
                            const MyTextt(text: "I am donating", fontSize: 16),
                            Switch(
                              value: isDonation,
                              onChanged: (value) {
                                setState(() {
                                  isDonation = value;
                                  if (isDonation) _priceController.clear();
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _countryController,
                          hintText: "Country",
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter country';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedCity,
                          hint: const Text("Select City"),
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                            });
                          },
                          items: _cities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.add_a_photo),
                          label: const Text("Upload Image"),
                        ),
                        const SizedBox(height: 20),
                        if (_imageFile != null)
                          Image.file(File(_imageFile!.path), height: 200),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isLoading ? null : _saveMedicineData,
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text("Save Medicine"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
