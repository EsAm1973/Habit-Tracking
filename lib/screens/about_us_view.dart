import 'package:flutter/material.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            title: const Text(
              "About Us",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 30,
              ),
            ),
            snap: false,
            pinned: false,
            floating: false,
            stretch: true,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: Stack(
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
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset("assets/about_us.png")),
                      SizedBox(height: 18,),
                      Text(
                          "We are a passionate team of developers, designers, and wellness enthusiasts dedicated to helping people build better habits and lead more fulfilling lives. Our journey began with a shared belief that small, consistent actions can lead to big, transformative changes. This app was created with the goal of empowering individuals to track, manage, and improve their daily habits through an intuitive and user-friendly experience. We strive to offer a tool that not only supports personal growth but also fosters a sense of achievement and motivation. Together, we are committed to making a positive impact on your journey towards a healthier, more productive life." , style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                      ),)
                    ],
                  ))),
        ],
      ),
    );
  }
}
