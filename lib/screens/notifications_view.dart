import 'package:flutter/material.dart';
import 'package:habit_tracking/widgets/notification_list_item.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            title: const Text("Notifications" ,style: TextStyle(
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
           const SliverToBoxAdapter(
              child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: Column(
                    children: [
                      NotificationListItem(),
                      NotificationListItem(),
                      NotificationListItem(),
                      NotificationListItem(),
                    ],
                  ))
          ),
        ],
      ),
    );
  }
}
