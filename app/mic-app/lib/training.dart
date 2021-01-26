import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mic/utils/designUtils.dart';


import 'package:flutter/material.dart';
import 'package:mic/utils/waveformVisualizer.dart';

import 'package:mic_stream/mic_stream.dart';

enum SignInState { SIGNED_IN, SIGNED_OUT, SIGN_IN_ERROR }

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  SignInState _signInState;
  int _warningIndex = 0;
  Timer _timer;

  Future<FirebaseUser> _handleSignIn() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleUser =
        await _googleSignIn.signIn().catchError((e) {
      setState(() {
        _signInState = SignInState.SIGN_IN_ERROR;
        print(_signInState);
      });
      print('Error signing in google user');
    });
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication.catchError((_) {
      setState(() {
        _signInState = SignInState.SIGN_IN_ERROR;
        print(_signInState);
      });
      print('Error getting google signin authentification');
    });

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult _authResult =
        await _auth.signInWithCredential(credential).catchError((_) {
      setState(() {
        _signInState = SignInState.SIGN_IN_ERROR;
      });
      print('Error with firebase authentification');
    });
    final FirebaseUser user = _authResult.user;

    print("signed in " + user.displayName);
    setState(() {
      _signInState = SignInState.SIGNED_IN;
    });
    return user;
  }
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      if (_warningIndex < 4) {
        setState(() {
          _warningIndex = _warningIndex + 1;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        setState(() {
          _signInState = SignInState.SIGNED_IN;
        });
      } else {
        setState(() {
          _signInState = SignInState.SIGNED_OUT;
        });
        _startTimer();
      }
    }).catchError((_) {
      print('Error checking signinstate in initState');
      setState(() {
        _signInState = SignInState.SIGN_IN_ERROR;
      });
    });
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.transparent,
      onPressed: () {
        _handleSignIn();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _trainingPageWarningAsync() {
    final textTheme = Theme.of(context).textTheme;

    TextSpan boldText(String text) {
      return TextSpan(
        text: text,
        style: textTheme.subtitle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: Colors.red,
        ),
      );
    }

    TextSpan normalText(String text) {
      return TextSpan(text: text);
    }

    final List<Widget> warningTexts = [
      Container(
        margin: EdgeInsets.all(40),
        child: Row(
          children: <Widget>[
            Text(
              'Warning',
              style: textTheme.subtitle.copyWith(fontSize: 30),
            ),
            Icon(
              Icons.warning,
              size: 40,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
      RichText(
        text: TextSpan(
          style: textTheme.subtitle.copyWith(
            fontSize: 26,
          ),
          children: <TextSpan>[
            normalText('You are entering the '),
            boldText('dangerous '),
            normalText('part of this application'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      RichText(
        text: TextSpan(
          style: textTheme.subtitle.copyWith(fontSize: 26),
          children: <TextSpan>[
            normalText('Messing up the training data results in a '),
            boldText('lifetime '),
            normalText('of '),
            boldText('bad karma'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      RichText(
        text: TextSpan(
          style: textTheme.subtitle.copyWith(fontSize: 26),
          children: <TextSpan>[
            normalText('...and '),
            boldText('bad '),
            normalText('predictions in the future'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      Container(
        width: 257,
        height: 50,
        child: _signInButton(),
      ),
    ];

    List<double> heights = [200, 200, 200, 200, 50];
    List<double> widths = [300, 300, 300, 300, 270];

    return AnimatedContainer(
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.circular(40),
      ),
      height: heights[_warningIndex],
      width: widths[_warningIndex],
      alignment: Alignment.center,
      child: warningTexts[_warningIndex],
    );
  }

  void _signOut() {
    FirebaseAuth.instance.signOut().then((_) {
      GoogleSignIn().signOut().then((_) {
        setState(() {
          _signInState = SignInState.SIGNED_OUT;
          _warningIndex = 4;
        });
      }).catchError((_) {
        print('Error in google signout');
        setState(() {
          _signInState = SignInState.SIGN_IN_ERROR;
        });
      });
    }).catchError((_) {
      print('Error in firebase signout');
      setState(() {
        _signInState = SignInState.SIGN_IN_ERROR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_signInState) {
      case SignInState.SIGNED_IN:
        child = Recording();
        break;
      case SignInState.SIGNED_OUT:
        child = _trainingPageWarningAsync();
        break;
      case SignInState.SIGN_IN_ERROR:
        child = Text(
            "Apperently there is a problem signing in.. I'm sorry but the google api is tricky");
        break;
      default:
        child = Container();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Training',
          ),
          centerTitle: true,
          textTheme: Theme.of(context).textTheme,
          actions: <Widget>[
            _signInState == SignInState.SIGNED_IN
                ? FlatButton(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Text(
                        'Log out',
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 14),
                      ),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).accentColor),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      _signOut();
                    },
                  )
                : Container(),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          child: Center(
            child: child,
          ),
        ),
        bottomNavigationBar: BottomnNavigation(
          pageType: PageType.TRAINING,
        ),
      ),
    );
  }
}

enum TrainingState { RECORDING, SUBMISSION }

class Recording extends StatefulWidget {
  @override
  _RecordingState createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  TrainingState state = TrainingState.RECORDING;

  static int _recLength = 3;
  List<int> _data = List();
  List<int> _currentRecording = List.filled(_recLength * 44100, 0);
  String _currentLabel = 'Cello';
  bool _recording = false;
  double _progress = 0.0;

  List<List<int>> _recordings = List();
  List<String> _labels = List();

  static Stream<List<int>> _micStream;
  StreamSubscription<List<int>> _listener;

  void _startRecording() async {
    setState(() {
      _currentRecording = List.filled(_recLength * 44100, 0);
      _data = List();
    });
    if (_listener == null) {
      _listener = _micStream.listen((samples) => _micStreamHandler(samples));
    } else if (_listener.isPaused) {
      _listener.cancel();
      _listener = _micStream.listen((samples) => _micStreamHandler(samples));
    }
    setState(() {
      _recording = true;
    });
  }

  void _stopRecording() {
    setState(() {
      _recording = false;
    });
  }

  void _micStreamHandler(List<int> samples) {
    if (_recording) {
      print('recording..');
      print('${_data.length}');

      _data.addAll(samples);

      if (_data.length > (_recLength * 44100)) {
        _stopRecording();
        setState(() {
          _currentRecording = _data.sublist(0, (_recLength * 44100));
        });
      }
    }
  }

  void _submitRecordings() async {
    print('Submit Recordings:');
    print('$_labels');

    if (_recordings.length == 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("You have to record something first!"),
            );
          });
      return;
    }

    setState(() {
      state = TrainingState.SUBMISSION;
    });

    if (_recordings.length != _labels.length) {
      _reset();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Something went terribly wrong!"),
            );
          });
    }

    var numRecordings = _recordings.length;

    // slice and store all recordings
    for (var i = 0; i < numRecordings; i++) {
      var currentRecording = _recordings[i];
      var currentLabel = _labels[i];
      var numFrames = (currentRecording.length / 2048).floor();

      for (var j = 0; j < numFrames; j++) {
        var start = j * 2048;
        var documentName = DateTime.now().toIso8601String();

        await Firestore.instance
            .collection('recordings')
            .document(documentName)
            .setData({
          'label': currentLabel,
          'samples': currentRecording.sublist(start, start + 2048)
        });
        setState(() {
          _progress = 1 / numRecordings * (i + j / numFrames);
        });
      }
      if (i == numRecordings - 1) {
        setState(() {
          _progress = 1.0;
        });
      }
    }
  }

  void _deleteCurrentRecording() {
    setState(() {
      _currentRecording = List.filled(_recLength * 44100, 0);
    });
  }

  void _addCurrentRecording() {
    setState(() {
      _recordings.add(_currentRecording);
      _labels.add(_currentLabel);
    });

    print('$_labels');
  }

  void _reset() {
    setState(() {
      state = TrainingState.RECORDING;
      _progress = 0.0;
      _currentLabel = 'Cello';
      _data = List();
      _currentRecording = List.filled(_recLength * 44100, 0);
      _recordings = List();
      _labels = List();
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
    Widget current;

    if (state == TrainingState.SUBMISSION) {
      current = Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
          ),
          Text('Storing new data..',
              style: Theme.of(context).textTheme.subtitle),
          Wrap(
            children: <Widget>[
              for (String label in _labels)
                Text(label, style: Theme.of(context).textTheme.body1)
            ],
            spacing: 10.0,
            runSpacing: 10.0,
            alignment: WrapAlignment.center,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.start,
          ),
          // CircularPercentIndicator(
          //   progressColor: Theme.of(context).accentColor,
          //   radius: 150,
          //   percent: _progress,
          //   center: Text(
          //     '${(_progress * 100).floor()}%',
          //     style: Theme.of(context).textTheme.subtitle,
          //   ),
          // ),
          LoadingGif(),
          Text(
            '${(_progress * 100).floor()}%',
            style: Theme.of(context).textTheme.subtitle,
            textAlign: TextAlign.center,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).accentColor),
              borderRadius: BorderRadius.circular(40),
            ),
            child: FlatButton(
              child: Text(
                'More Training',
              ),
              onPressed: () {
                _reset();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    } else {
      current = Container(
        padding: EdgeInsets.only(top: 20, bottom: 0.0),
        child: Column(
          children: <Widget>[
            Text('Record an instrument:',
                style: Theme.of(context).textTheme.subtitle),
            _recording
                ? WaveformRecording()
                : WaveformVisualizer(
                    recording: _currentRecording,
                    numBars: 20,
                  ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
            ),
            Row(
              children: <Widget>[
                _recording
                    ? IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: null,
                        iconSize: 40,
                      )
                    : IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: _startRecording,
                        iconSize: 40,
                      ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            Text('Select Label:', style: Theme.of(context).textTheme.subtitle),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            DropdownButton<String>(
              value: _currentLabel,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 1,
                color: Theme.of(context).accentColor,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _currentLabel = newValue;
                });
              },
              items: <String>[
                'Cello',
                'Clarinet',
                'Flute',
                'Acustic Guitar',
                'Electric Guitar',
                'Organ',
                'Piano',
                'Saxophone',
                'Trumpet',
                'Violin',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
            ),
            Container(
              width: 250,
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _deleteCurrentRecording,
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addCurrentRecording,
                  ),
                  IconButton(
                    icon: Icon(Icons.file_upload),
                    onPressed: _submitRecordings,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      );
    }

    return current;
  }
}
