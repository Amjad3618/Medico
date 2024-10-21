import 'package:flutter/material.dart';
import 'package:medico/utils/custom_text.dart';
import '../utils/custome-button.dart';
import '../utils/custome_form.dart';

class AddMedicineMobile extends StatefulWidget {
  const AddMedicineMobile({Key? key}) : super(key: key);

  @override
  State<AddMedicineMobile> createState() => _AddMedicineMobileState();
}

class _AddMedicineMobileState extends State<AddMedicineMobile> {
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
        automaticallyImplyLeading: false,
        title: const MyTextt(text: "Add Medicine"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextFormField(
                controller: _medicineNameController,
                hintText: "Medicine name",
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  if (!isDonation) ...[
                    Expanded(
                      child: CustomTextFormField(
                        controller: _priceController,
                        hintText: "Price",
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
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: _cityController,
                hintText: "City",
              ),
              const SizedBox(height: 15),
              TextFormField(
                maxLines: 4,
                maxLength: 200,
                controller: _descriptionController,
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
                child: Center(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined, size: 30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyElevatedButton(
                  text: "Add Medicine",
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
