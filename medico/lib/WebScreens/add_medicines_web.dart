import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;
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
  html.File? _imageFile;
  String? _imagePreviewUrl;

  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<String> _cities = [
    "Karachi",
    "Lahore",
    "Islamabad",
    "Rawalpindi",
    "Faisalabad",
    "Multan",
    "Peshawar",
    "Quetta",
    "Sialkot",
    "Hyderabad"
  ];

  String? _selectedCity;

  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Accept only image files
    uploadInput.click(); // Trigger the file picker dialog

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          _imageFile = files[0]; // Assign the selected Blob
          _imagePreviewUrl =
              html.Url.createObjectUrl(_imageFile!); // Create a URL for preview
        });
      }
    });
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null; // Ensure an image is selected

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('medicine_images')
          .child('$fileName.jpg');

      // Upload the image as Blob
      final UploadTask uploadTask = storageRef.putBlob(_imageFile!);
      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl =
          await snapshot.ref.getDownloadURL(); // Get the download URL
      print("Image uploaded successfully: $downloadUrl"); // Debug print
      return downloadUrl; // Return the URL
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null; // Handle upload errors
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

      final product = ProductModel(
        name: _medicineNameController.text,
        price: isDonation ? "0" : _priceController.text,
        sellerName: _phoneController.text,
        description: _descriptionController.text,
        city: _selectedCity,
        isDonated: isDonation,
        productImage: imageUrl,
        country: _countryController.text,
      );

      await FirebaseFirestore.instance
          .collection('medicines')
          .add(product.toJson());

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (!isDonation &&
                                                      (value?.isEmpty ??
                                                          true)) {
                                                    return 'Please enter price';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          if (!isDonation)
                                            const SizedBox(width: 20),
                                          const MyTextt(
                                              text: "I am donating",
                                              fontSize: 16),
                                          Switch(
                                            value: isDonation,
                                            onChanged: (value) {
                                              setState(() {
                                                isDonation = value;
                                                if (isDonation)
                                                  _priceController.clear();
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
                                      CustomTextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.number,
                                        hintText: "Phone Number",
                                        validator: (value) {
                                          if (value?.isEmpty ?? true) {
                                            return 'Please enter phone number';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),
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
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        maxLines: 4,
                                        maxLength: 200,
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
                                      const SizedBox(height: 20),
                                      Container(
                                        height: 200,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                        ),
                                        child: _imagePreviewUrl != null
                                            ? Image.network(
                                                _imagePreviewUrl!,
                                                fit: BoxFit.cover,
                                              )
                                            : const Center(
                                                child: Text(
                                                  'No image selected',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: _pickImage,
                                        child: const Text("Upload Image"),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : _saveMedicineData, // Disable button when loading
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                        ),
                                        child: isLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors
                                                    .white, // Customize color to match button text
                                              )
                                            : const Text("Add Medicine"),
                                      )
                                    ],
                                  ),
                                ))))))));
  }
}
