import 'package:flutter/material.dart';

import 'package:weather_animation/weather_animation.dart';

class TutorialAnimationPage extends StatelessWidget {
  const TutorialAnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const WrapperScene(
            colors: [
              Color(0xff283593),
              Color(0xffff8a65),
              Color(0xd6ffee58),
            ],
            children: [
              SunWidget(
                sunConfig: SunConfig(
                  width: 262.0,
                  blurSigma: 10.0,
                  blurStyle: BlurStyle.solid,
                  isLeftLocation: true,
                  coreColor: Color(0xffffa726),
                  midColor: Color(0xd6ffee58),
                  outColor: Color(0xffff9800),
                  animMidMill: 2000,
                  animOutMill: 1800,
                ),
              ),
              CloudWidget(
                cloudConfig: CloudConfig(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: const Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Fetching city...",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
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
    );
  }
}
