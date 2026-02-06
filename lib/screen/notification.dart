import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petsmore_tele_app/widgets/appbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class data {
  String title;
  String subject;

  data({
    required this.title,
    required this.subject,
  });
}

final List<data> Data = [
  data(
      title: 'Notification Title1',
      subject:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
  data(
      title: 'Notification Title2',
      subject:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
  data(
      title: 'Notification Title3',
      subject:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
  data(
      title: 'Notification Title4',
      subject:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
  data(
      title: 'Notification Title5',
      subject:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
  data(
      title: 'Notification Title6',
      subject:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
  data(
      title: 'Notification Title7',
      subject:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
  data(
      title: 'Notification Title8',
      subject:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
];

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'NOTIFICATIONS',
        icon: Icon(null),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: Adaptive.h(2), right: Adaptive.w(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          Data.clear();
                        });
                      }
                    },
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
            notificationList(),
          ],
        ),
      ),
    );
  }

  Widget notificationList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Adaptive.w(1)),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: Data.length,
        itemBuilder: (context, itemIndex) {
          final data = Data[itemIndex];
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Adaptive.w(5), vertical: Adaptive.h(1)),
            child: Container(
              // height: Adaptive.h(20),
              width: Adaptive.w(90),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: Adaptive.w(4), top: Adaptive.h(1)),
                        child: Text(
                          data.title,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: Adaptive.w(4),
                            top: Adaptive.h(1),
                            bottom: Adaptive.h(2)),
                        child: Container(
                          width: Adaptive.w(80),
                          child: Text(
                            data.subject,
                            maxLines: 4,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
