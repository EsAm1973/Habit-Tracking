import 'package:flutter/material.dart';

import '../widgets/edit_profile_text_form_field.dart';

class EditPasswordView extends StatefulWidget {
  const EditPasswordView({super.key});

  @override
  State<EditPasswordView> createState() => _EditPasswordViewState();
}

class _EditPasswordViewState extends State<EditPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            title: const Text("EditPassword" ,style: TextStyle(
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
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: Form(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const EditProfileTextFormField(
                      // initialValue:
                      // '**********',
                      dataKey: 'Old Password',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const EditProfileTextFormField(
                      // initialValue:
                      // '**********',
                      dataKey: 'New Password',
                    ),
                    const SizedBox(
                      height: 96,
                    ),
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
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Save",
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
          )
        ],
      ),
    );
  }
}
