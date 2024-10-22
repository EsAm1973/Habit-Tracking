import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../widgets/custom_text_form_field.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  @override
  Widget build(BuildContext context) {
    List icons = ["snapchat", "facebook", "x", "instagram"];
    TextEditingController username = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController phone = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body:  CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            title: const Text("Contact Us" ,style: TextStyle(
                color: Colors.white
            ), ),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon:
              const Icon(Icons.arrow_back_ios_new , color: Colors.white, size: 30,),),
            snap: false,
            pinned: false,
            floating: false,
            stretch: true,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background:
                  Stack(
                    children: [
                      Container(
                        color: Colors.deepPurple,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(
                                  30,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            expandedHeight: 130,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Connection Information with Management :",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    margin: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            spreadRadius: 0.5)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color:Colors.grey,
                                      blurRadius: 2,
                                      spreadRadius: 0.5),
                                ],
                              ),
                              child: Icon(Icons.phone),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              "96678754546",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                      spreadRadius: 0.5),
                                ],
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset("assets/whatsapp.jpg")),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              "https://web.whatsapp.com",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Color(0xff007AFF),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "Connect through :",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.sizeOf(context).width,
                          child: ListView.builder(
                              itemCount: icons.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return index==2?Row(
                                  children: [
                                    Image.asset(
                                        "assets/${icons[index]}.jpg" , scale: .8,),
                                    SizedBox(width: 5,),
                                  ],
                                ):Row(
                                  children: [
                                    Image.asset(
                                        "assets/${icons[index]}.png" , scale: 1.5,),
                                    SizedBox(width: 5,),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Send Message :",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            spreadRadius: 0.5)
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextFormField(
                              controller: username,
                              label: "User Name",
                              hintText: "Enter your Name",
                              keyboardType: TextInputType.name,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onChanged: (userName) {

                              }),
                          CustomTextFormField(
                              controller: email,
                              label: "Email",
                              hintText: "example@gmail.com",
                              keyboardType: TextInputType.name,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                              onChanged: (email) {

                              }),
                          CustomTextFormField(
                              controller: phone,
                              label: "Phone Number",
                              hintText: "0123456789",
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.phoneNumber(),
                              ]),
                              onChanged: (phone) {

                              }),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              height: 56,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 56,
                                    width: MediaQuery.sizeOf(context).width,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Colors.purpleAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(50),
                                            )),
                                        onPressed: () {
                                          if (formKey.currentState!.validate()) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text(
                                          "Send Message",
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        )),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_outlined,
                                          color: Colors.purpleAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
