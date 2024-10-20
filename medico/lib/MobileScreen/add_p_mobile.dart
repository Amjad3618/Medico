import 'package:flutter/material.dart';
import 'package:medico/utils/custom_text.dart';
import 'package:medico/utils/custome-button.dart';
import 'package:medico/utils/custome_form.dart';

class AddPMobile extends StatefulWidget {
  const AddPMobile({super.key});

  @override
  State<AddPMobile> createState() => _AddPMobileState();
}

class _AddPMobileState extends State<AddPMobile> {
  final _productnamectrl = TextEditingController();
  final _pricectrl = TextEditingController();
  final _productdiscreptionctrl = TextEditingController();
  final _countryctrl = TextEditingController();
  final _cityctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTextt(text: "Add Medicens"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextFormField(
                controller: _productnamectrl,
                hintText: "Medicen name",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                controller: _pricectrl,
                hintText: "price",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                controller: _countryctrl,
                hintText: "Country",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextFormField(
                controller: _cityctrl,
                hintText: "City",
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLines: 4,
                maxLength: 200,
                controller: _productdiscreptionctrl,
                decoration: const InputDecoration(
                    hintText: "discreption", border: OutlineInputBorder()),
              ),
                const SizedBox(height: 15,),
          
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(color: Colors.grey[200],border: Border.all(),borderRadius: BorderRadius.circular(20)),
                  child: Center(child: IconButton(onPressed: (){}, icon: const Icon(Icons.camera_alt_outlined,size: 30,)),),
                ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyElevatedButton(text: "Add Medicen", onPressed: (){})
                  )
            ],
          ),
        ),
      ),
    );
  }
}
