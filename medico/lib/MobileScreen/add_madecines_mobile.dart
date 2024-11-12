import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../Models/produ_model.dart';
import '../utils/custom_text.dart';
import '../utils/custome_form.dart';

class AddMedicineMobile extends StatefulWidget {
  const AddMedicineMobile({Key? key}) : super(key: key);

  @override
  State<AddMedicineMobile> createState() => _AddMedicineMobileState();
}

class _AddMedicineMobileState extends State<AddMedicineMobile> {
  bool isDonation = false;
  bool isLoading = false;
  Uint8List? _imageFile;
  String? _imageUrl;

  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sellernameController = TextEditingController();

  final List<String> _cities = ["Karachi", "Lahore", "Islamabad", "Rawalpindi", "Faisalabad", "Multan", "Peshawar", "Quetta", "Sialkot", "Hyderabad"];
  String? _selectedCity;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imageData = await image.readAsBytes();
        setState(() {
          _imageFile = imageData;
        });
        _imageUrl = await _uploadImage();
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
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

      final UploadTask uploadTask = storageRef.putData(_imageFile!);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  Future<void> _saveMedicineData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save medicine')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      _imageUrl ??= await _uploadImage();

      if (_imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image upload failed')),
        );
        return;
      }

      final docRef = FirebaseFirestore.instance.collection('medicines').doc();

      final product = ProductModel(
        name: _medicineNameController.text,
        price: isDonation ? "0" : _priceController.text,
        description: _descriptionController.text,
        city: _selectedCity,
        isDonated: isDonation,
        productImage: _imageUrl,
        country: _countryController.text,
        productId: docRef.id,
        sellerId: currentUser.uid, // Ensure current user UID is set correctly
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
      _imageUrl = null;
      isDonation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTextt(text: "Add Medicine"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                const SizedBox(height: 16),
                if (!isDonation)
                  CustomTextFormField(
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Donation?"),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _phoneController,
                  hintText: "Phone Number",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  hint: const Text("Select City"),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a city';
                    }
                    return null;
                  },
                  items: _cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 5,
                  maxLength: 500,
                  controller: _descriptionController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _imageFile != null
                        ? Image.memory(_imageFile!, fit: BoxFit.cover)
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 40),
                                Text("Tap to add image"),
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    textStyle: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: isLoading ? null : _saveMedicineData,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Add Medicine"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
