import 'package:flutter/material.dart';

import 'package:medico/utils/custom_text.dart';
import '../utils/custome-button.dart';

import '../utils/custome_form.dart';

class AddMedicineWeb extends StatefulWidget {
  const AddMedicineWeb({Key? key}) : super(key: key);

  @override
  State<AddMedicineWeb> createState() => _AddMedicineWebState();
}

class _AddMedicineWebState extends State<AddMedicineWeb> {
  bool isDonation = false;
  final _medicineNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();

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
            constraints:
                BoxConstraints(maxWidth: 800), // Constrain form width for web
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Medicine Name
                      CustomTextFormField(
                        controller: _medicineNameController,
                        hintText: "Medicine Name",
                      ),
                      const SizedBox(height: 20),
                  
                      // Price and Donation Switch
                      Row(
                        children: [
                          if (!isDonation)
                            Expanded(
                              child: CustomTextFormField(
                                controller: _priceController,
                                hintText: "Price",
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
                  
                      // Country
                      CustomTextFormField(
                        controller: _countryController,
                        hintText: "Country",
                      ),
                      const SizedBox(height: 20),
                  
                      // City
                      CustomTextFormField(
                        controller: _cityController,
                        hintText: "City",
                      ),
                      const SizedBox(height: 20),
                  
                      // Description
                      TextFormField(
                        maxLines: 4,
                        maxLength: 200,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Description",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                  
                      // Image Picker
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.camera_alt_outlined, size: 30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                  
                      // Add Medicine Button
                      Center(
                        child: MyElevatedButton(
                          text: "Add Medicine",
                          onPressed: () {
                            // Handle medicine addition
                          },
                        ),
                      ),
                    ],
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
