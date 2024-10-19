import 'package:flutter/material.dart';
import 'package:medico/utils/custom_text.dart';
import 'package:medico/utils/custome_form.dart';

class HomeMoile extends StatefulWidget {
  const HomeMoile({super.key});

  @override
  State<HomeMoile> createState() => _HomeMoileState();
}

class _HomeMoileState extends State<HomeMoile> {
  final _seaarchctrl = TextEditingController();
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: CustomTextFormField(
                    controller: _seaarchctrl,
                    hintText: "Search...",
                  )),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(color: Colors.blue[100]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 10,)
,                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  MyTextt(text: "seller name "),
                                  MyTextt(text: "product name "),
                                  MyTextt(text: "price "),
                                ],
                              ),
                              Column(
                                children: [
                                  MyTextt(text: "Amjad Ali "),
                                  MyTextt(text: "my product "),
                                  MyTextt(text: " Rs 560 "),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ));
  }
}
