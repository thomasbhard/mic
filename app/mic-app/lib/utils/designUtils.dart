import 'package:flutter/material.dart';
import 'package:mic/prediction.dart';
import 'package:mic/settingspage.dart';
import 'package:mic/titlepage.dart';
import 'package:mic/training.dart';

class FlatNavigationButton extends StatelessWidget {
  final String text;
  final Function pageConstructor;
  final EdgeInsetsGeometry margin;

  FlatNavigationButton(
      {@required this.text, @required this.pageConstructor, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: FlatButton(
        child: Text(
          text,
        ),
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => pageConstructor(),
            ),
          );
        },
      ),
    );
  }
}

enum PageType { HOME, PREDICTION, TRAINING, SETTINGS }

class BottomnNavigation extends StatelessWidget {
  final PageType pageType;
  final Color _activeColor = Colors.blueAccent;
  final Color _defaultColor = Colors.black;

  BottomnNavigation({@required this.pageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            color: pageType == PageType.HOME ? _activeColor : _defaultColor,
            onPressed: () {
              if (pageType != PageType.HOME) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TitlePage(),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.mic),
            color:
                pageType == PageType.PREDICTION ? _activeColor : _defaultColor,
            onPressed: () {
              if (pageType != PageType.PREDICTION) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PredictionPage(),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.train),
            color: pageType == PageType.TRAINING ? _activeColor : _defaultColor,
            onPressed: () {
              if (pageType != PageType.TRAINING) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingPage(),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            color: pageType == PageType.SETTINGS ? _activeColor : _defaultColor,
            onPressed: () {
              if (pageType != PageType.SETTINGS) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class LoadingGif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'output1.gif',
        alignment: Alignment.center,
        height: 300,
        width: 300,
      ),
    );
  }
}
