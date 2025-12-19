import 'package:flutter/material.dart';
import 'package:nrs_tele_apps/screen/login.dart';
import 'package:nrs_tele_apps/widgets/custom_container.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: const Color(0xFFEA1C24),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(7)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Adaptive.h(15)),
                  _buildText('SENHENG'),
                  _buildText('CRM'),
                  _buildText('TELEMARKETING'),
                  _buildText('APP'),
                  SizedBox(height: Adaptive.h(8)),
                  Center(
                    child: Image.asset(
                      'assets/images/sh-crm-launch-screen-img.png',
                      height: Adaptive.h(30),
                      width: Adaptive.w(90),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: Adaptive.h(6),
            left: Adaptive.w(5),
            right: Adaptive.w(5),
            child: CustomContainer(
              backgroundColor: Colors.white,
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()));
              },
              title: 'GET STARTED',
              width: Adaptive.w(0),
              height: Adaptive.h(6.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Adaptive.h(1)),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontSize: 38,
          color: Colors.white,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w700,
          height: 0.8,
          letterSpacing: 0,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
