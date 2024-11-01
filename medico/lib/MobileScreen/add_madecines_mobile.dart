import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';  // For web images
import '../Models/produ_model.dart';
import '../utils/custom_text.dart';
import '../utils/custome-button.dart';
import '../utils/custome_form.dart';

class AddMedicineMobile extends StatefulWidget {
  const AddMedicineMobile({Key? key}) : super(key: key);

  @override
  State<AddMedicineMobile> createState() => _AddMedicineMobileState();
}

class _AddMedicineMobileState extends State<AddMedicineMobile> {
  bool isDonation = false;
  bool isLoading = false;
  Uint8List? _webImageFile;  // For web image data
  String? _imageUrl;  // Store the URL of the uploaded image
  final _formKey = GlobalKey<FormState>();

  final _medicineNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<String> _cities = [
    "Karachi", "Lahore", "Islamabad", "Rawalpindi", 
    "Faisalabad", "Multan", "Peshawar", "Quetta", 
    "Sialkot", "Hyderabad"
  ];

  String? _selectedCity;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        if (kIsWeb) {
          final imageData = await image.readAsBytes();
          setState(() {
            _webImageFile = imageData;
          });
          _imageUrl = await _uploadImageWeb();
        } else {
          // Handle non-web platforms
          final imageData = await image.readAsBytes();
          _webImageFile = imageData;
          _imageUrl = await _uploadImageWeb();
        }
        setState(() {});  // Refresh to display uploaded image
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<String?> _uploadImageWeb() async {
    if (_webImageFile == null) return null;

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('medicine_images')
          .child('$fileName.jpg');

      final UploadTask uploadTask = storageRef.putData(_webImageFile!);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
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
      final product = ProductModel(
        name: _medicineNameController.text,
        price: isDonation ? "0" : _priceController.text,
        sellerName: _phoneController.text,
        description: _descriptionController.text,
        city: _selectedCity,
        isDonated: isDonation,
        productImage: _imageUrl,  // Use the uploaded image URL
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
      _webImageFile = null;
      _imageUrl = null;  // Clear the image URL
      isDonation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const MyTextt(text: "Add Medicine"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormField(
                  controller: _medicineNameController,
                  hintText: "Medicine name",
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter medicine name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    if (!isDonation) ...[
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
                      const SizedBox(width: 10),
                    ],
                    const MyTextt(text: "I am donating"),
                    const SizedBox(width: 5),
                    Switch(
                      value: isDonation,
                      onChanged: (value) {
                        setState(() {
                          isDonation = value;
                          if (isDonation) {
                            _priceController.clear();
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _webImageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: kIsWeb && _imageUrl != null
                              ? Image.network(
                                  _imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : const Center(child: CircularProgressIndicator()),
                        )
                      : Center(
                          child: IconButton(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.camera_alt_outlined, size: 30),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyElevatedButton(
                    text: isLoading ? "Saving..." : "Save",
                    onPressed: (){isLoading ? null : _saveMedicineData();}
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
