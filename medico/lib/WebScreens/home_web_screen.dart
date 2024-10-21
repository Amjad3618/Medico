import 'package:flutter/material.dart';
import 'package:medico/WebScreens/product_detail_web.dart';
import 'package:medico/utils/custom_text.dart';
import 'package:medico/utils/custome_form.dart';


class HomeWeb extends StatefulWidget {
  const HomeWeb({super.key});

  @override
  State<HomeWeb> createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const MyTextt(
          text: "Free Medico",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.person_3_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: CustomTextFormField(
                controller: _searchCtrl,
                hintText: "Search...",
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
              
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Three items per row
                  childAspectRatio: 0.6, // Adjust aspect ratio to fit
                  mainAxisSpacing: 10, // Space between rows
                  crossAxisSpacing: 10, // Space between columns
                ),
                
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductDetailWeb(),
                        ),
                      );
                    },
                    child: Container(
                      height: 300, // Fixed height for each product card
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 150, // Set image height
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  "assets/me2.jfif",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Seller Name: Amjad Ali",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Product Name: My Product",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Price: Rs 560",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Country: Pakistan",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "City: Karachi",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Donation: Not Applicable",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
