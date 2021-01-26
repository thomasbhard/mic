import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mic/utils/designUtils.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:provider/provider.dart';

import 'package:mic/utils/visualizer.dart';
import 'package:mic/utils/sigproc.dart';
import 'package:mic/utils/settings.dart';

class PredictionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Classification',
            ),
            textTheme: Theme.of(context).textTheme,
            centerTitle: true,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Consumer<Settings>(
                builder: (context, settings, child) {
                  return Prediction(settings.threshold, settings.predictorType);
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomnNavigation(
            pageType: PageType.PREDICTION,
          ),
        ),
      ),
    );
  }
}

class Prediction extends StatefulWidget {
  final double threshold;
  final predictorType;
  static const platform = const MethodChannel('prediction');

  Prediction(this.threshold, this.predictorType);

  @override
  _PredictionState createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  static Stream<List<int>> _micStream;
  StreamSubscription<List<int>> _listener;

  bool _levelOK = true;
  bool _paused = true;
  bool _isProcessing = false;
  Float64List _probabilies = Float64List(10);
  String _bestInst = '';
  int _bestProbabilty = 0;
  double _level = 0.0;

  void _startRecording() async {
    if (_listener == null) {
      // if listener is not initialized, get instance and start listening
      _listener = _micStream.listen((samples) => _micStreamHandler(samples));
    } else if (_listener.isPaused) {
      // if somehow, the listener gets paused, destroy the current listener and start listening again
      // in order to keep uptodate and prevent listening to old data
      _listener.cancel();
      _listener = _micStream.listen((samples) => _micStreamHandler(samples));
    }
    setState(() {
      _paused = false;
    });
  }

  void _pauseRecording() {
    setState(() {
      _paused = true;
    });
  }

  void _micStreamHandler(List<int> samples) async {
    if (_isProcessing) {
      print('Is Processing..');
    } else if (_paused) {
      print('Paused');
    } else {
      print('Process data');
      setState(() {
        _isProcessing = true;
      });

      // Prepare input array
      Float64List input = intToFloat64List(samples);
      input = input.sublist(0, 2048);

      // check level
      double level = getLevel(input);
      setState(() {
        _level = level;
      });

      if (level > widget.threshold) {
        input = normalize(input);

        Float64List labels = await _predict(input);
        setState(() {
          _levelOK = true;
          _probabilies = labels;
        });
        _setPredictedInstrument();
      } else {
        setState(() {
          _levelOK = false;
        });
      }
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<Float64List> _predict(Float64List input) async {
    Float64List probabilies = Float64List(10);
    try {
      if (widget.predictorType == PredictorType.ENDTOEND) {
        probabilies = await Prediction.platform
            .invokeMethod('ENDTOEND', {'input': input});
        print('ENDTOEND PREDICTION');
      } else if (widget.predictorType == PredictorType.DOMAINFEATURES) {
        probabilies = await Prediction.platform
            .invokeMethod('DOMAINFEATURES', {'input': input});
        print('DOMAINFEATURE PREDICTION');
      }
      print(probabilies);
    } on PlatformException catch (e) {
      print(e.details);
    }

    return probabilies;
  }

  void _setPredictedInstrument() {
    var instAndProb = {
      'Cello': _probabilies[0],
      'Clarinet': _probabilies[1],
      'Flute': _probabilies[2],
      'Acustic Guitar': _probabilies[3],
      'Electric Guitar': _probabilies[4],
      'Organ': _probabilies[5],
      'Piano': _probabilies[6],
      'Saxophone': _probabilies[7],
      'Trumpet': _probabilies[8],
      'Violin': _probabilies[9]
    };

    String bestInst = instAndProb.keys.elementAt(0);
    for (String inst in instAndProb.keys) {
      if (instAndProb[inst] > instAndProb[bestInst]) bestInst = inst;
    }

    setState(() {
      _bestInst = bestInst;
      _bestProbabilty = (instAndProb[bestInst] * 100).floor();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _micStream = microphone(
          sampleRate: 44100, audioFormat: AudioFormat.ENCODING_PCM_16BIT);
    });
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(3),
              width: (_level * 100),
              height: 10,
              color: Colors.black,
            ),
            Container(
              width: MediaQuery.of(context).size.width-10,
              foregroundDecoration: BoxDecoration(
                color: _levelOK
                    ? Color.fromRGBO(211, 211, 211, 0)
                    : Color.fromRGBO(211, 211, 211, 0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: BoxVisualizer(_probabilies),
              alignment: Alignment(0.0, 0.0),
              margin: EdgeInsets.symmetric(horizontal: 9),
              padding: EdgeInsets.only(left: 2, right: 2, bottom: 2, top: 2),
            ),
            InfoBox(_bestInst, _bestProbabilty, _levelOK, _paused),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).accentColor),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: _paused
                    ? IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: _startRecording,
                        iconSize: 40.0,
                        splashColor: Colors.transparent,
                      )
                    : IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: _pauseRecording,
                        iconSize: 40.0,
                        splashColor: Colors.transparent,
                      ),
              ),
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.all(10),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final bool _levelOK;
  final String _bestInst;
  final int _bestProbabilty;
  final bool _paused;

  InfoBox(this._bestInst, this._bestProbabilty, this._levelOK, this._paused);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_paused) {
      child = Text('Paused');
    } else if (_levelOK) {
      child = Text(
        'Predicted instrument: \n$_bestInst with $_bestProbabilty%',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body1,
      );
    } else {
      child = Text(
        'Level too low..',
        style: Theme.of(context).textTheme.body1,
      );
    }

    return Container(
      width: double.infinity,
      height: 100,
      child: child,
      padding: EdgeInsets.all(10),
      alignment: Alignment(0.0, 0.0),
    );
  }
}
