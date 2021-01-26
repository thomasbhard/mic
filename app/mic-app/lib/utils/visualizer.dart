import 'dart:typed_data';

import 'package:flutter/material.dart';

class DebugVisualizer extends StatelessWidget {
  final Float64List _labels;

  const DebugVisualizer(this._labels);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Labels: $_labels'),
    );
  }
}

class BoxVisualizer extends StatelessWidget {
  final Float64List probabilties;
  final List<String> labels = [
    'cel',
    'cla',
    'flu',
    'gac',
    'gel',
    'org',
    'pia',
    'sax',
    'tru',
    'vio'
  ];

  BoxVisualizer(this.probabilties);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          for (var i = 0; i < probabilties.length - 1; i++)
            InstrumentBoxIcon(
              instrument: labels[i],
              probability: probabilties[i],
              boxSize: 90,
            ),
        ],
      ),
      padding: EdgeInsets.all(4),
    );
  }
}

class InstrumentBoxIcon extends StatelessWidget {
  final String instrument;
  final double probability;
  final double boxSize;

  InstrumentBoxIcon(
      {@required this.instrument,
      @required this.probability,
      @required this.boxSize});

  Color _getColorFromProbabilty() {
    double opacity = probability;
    return Color.fromRGBO(0, 44, 154, opacity);
  }

  String _getFullInstrumentName(String label) {
    var instruments = Map();
    instruments = {
      'cel': 'Cello',
      'cla': 'Clarinet',
      'flu': 'Flute',
      'gac': 'Ac. Guitar',
      'gel': 'El. Guitar',
      'org': 'Organ',
      'pia': 'Piano',
      'sax': 'Saxophone',
      'tru': 'Trumpet',
      'vio': 'Violin'
    };

    return instruments[label];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxSize,
      height: boxSize,
      child: Column(
        children: <Widget>[
          Image(image: AssetImage('$instrument-50.png')),
          Text(
            '${_getFullInstrumentName(instrument)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      alignment: Alignment(0.0, 0.0),
      decoration: BoxDecoration(
          color: _getColorFromProbabilty(),
          borderRadius: BorderRadius.circular(boxSize / 10),
          border: Border.all(color: Colors.blueGrey)),
      margin: EdgeInsets.all(boxSize / 10),
      padding: EdgeInsets.all(5),
    );
  }
}
