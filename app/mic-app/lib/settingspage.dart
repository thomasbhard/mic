import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mic/utils/designUtils.dart';
import 'package:provider/provider.dart';

import 'package:mic/utils/settings.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
          ),
          centerTitle: true,
          textTheme: Theme.of(context).textTheme,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                PredictionTypeSettings(),
                ThresholdSettings(),
              ],
              shrinkWrap: true,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        bottomNavigationBar: BottomnNavigation(
          pageType: PageType.SETTINGS,
        ),
      ),
    );
  }
}

class SettingsContainer extends StatelessWidget {
  final Widget child;
  SettingsContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: child,
    );
  }
}

class ThresholdSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      child: Column(
        children: <Widget>[
          Text(
            'Threshold',
            style: Theme.of(context).textTheme.subtitle,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text('Quiet'),
                Text('Normal'),
                Text('Loud'),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          ),
          Consumer<Settings>(builder: (context, settings, child) {
            return Column(
              children: <Widget>[
                // Text('${settings.threshold}'),
                Slider(
                  onChanged: (value) {
                    settings.setThreshold(value);
                  },
                  value: settings.threshold,
                  min: 0.0,
                  max: 0.01,
                ),
              ],
            );
          }),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class PredictionTypeSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      child: Column(
        children: <Widget>[
          Text(
            'Prediction Type',
            style: Theme.of(context).textTheme.subtitle,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: Consumer<Settings>(
              builder: (context, settings, child) {
                return DropdownButton<PredictorType>(
                  value: settings.predictorType,
                  onChanged: (newType) {
                    if (newType == PredictorType.DOMAINFEATURES) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'The End to End model works better.. just saying.. You do you!',
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                            );
                          });
                    }
                    settings.setPredictorType(newType);
                  },
                  items: PredictorType.values.map((PredictorType classType) {
                    return new DropdownMenuItem<PredictorType>(
                      value: classType,
                      child: new Text(
                        classType.toString().replaceAll('PredictorType.', ''),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
