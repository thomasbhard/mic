import 'package:flutter/material.dart';
import 'package:mic/utils/designUtils.dart';

import 'about.dart';
import 'prediction.dart';
import 'package:mic/utils/headers.dart';

class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Header(),
              FlatNavigationButton(
                text: 'Get Started',
                pageConstructor: () => PredictionPage(),
                margin: EdgeInsets.only(top: 100, bottom: 20),
              ),
              FlatNavigationButton(
                text: 'About',
                pageConstructor: () => AboutPage(),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
      ),
    );
  }
}
