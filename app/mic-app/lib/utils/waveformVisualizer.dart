import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'sigproc.dart';

class WaveformVisualizer extends StatelessWidget {
  final List<int> recording;
  final int numBars;

  WaveformVisualizer({this.recording, this.numBars});

  Float64List getBarHeights() {
    Float64List recordingFloat = intToFloat64List(recording);
    Float64List barHeights = Float64List(numBars);
    int windowLength = (recordingFloat.length / numBars).floor();
    for (var i = 0; i < numBars; i++) {
      int start = i * windowLength;
      int end = start + windowLength;

      barHeights[i] = getLevel(recordingFloat.sublist(start, end));
    }

    return normalize(barHeights);
  }

  @override
  Widget build(BuildContext context) {
    Float64List barHeights = getBarHeights();

    return Container(
      child: Center(
        child: Bars(
          barHeights: barHeights,
        ),
      ),
    );
  }
}

class Bars extends StatelessWidget {
  final Float64List barHeights;

  Bars({this.barHeights});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        children: <Widget>[
          for (var i = 0; i < barHeights.length; i++)
            Container(
              width: 7,
              height: 10 + 50 * barHeights[i],
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
    );
  }
}

class WaveformRecording extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Center(
        child: Text(
          'Recording..',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
