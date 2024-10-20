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
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.person_3_outlined))
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
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(color: Colors.blue[50]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                         
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset("assets/me2.jfif",fit: BoxFit.cover,)),
                          ),
                          const SizedBox(height: 10,)
,                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyTextt(text: "seller name ",fontSize: 20,fontWeight: FontWeight.w400,),
                                  MyTextt(text: "product name ",fontSize: 20,fontWeight: FontWeight.w400,),
                                  MyTextt(text: "price ",fontSize: 20,fontWeight: FontWeight.w400,),
                                  MyTextt(text: "country ",fontSize: 20,fontWeight: FontWeight.w400,),
                                    MyTextt(text: "city ",fontSize: 20,fontWeight: FontWeight.w400,),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  MyTextt(text: "Amjad Ali ",fontSize: 20,fontWeight: FontWeight.w400,),
                                  MyTextt(text: "my product ",fontSize: 20,fontWeight: FontWeight.w400,),
                                  MyTextt(text: " Rs 560 ",fontSize: 20,fontWeight: FontWeight.w400,),
                                  MyTextt(text: " Pakistan ",fontSize: 20,fontWeight: FontWeight.w400,),
                                  MyTextt(text: " karachi ",fontSize: 20,fontWeight: FontWeight.w400,),
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
