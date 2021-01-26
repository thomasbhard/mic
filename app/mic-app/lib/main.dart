import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'titlepage.dart';
import 'package:mic/utils/settings.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ChangeNotifierProvider(
      builder: (context) => Settings(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TitlePage(),
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.blueAccent,
          dividerColor: Colors.blueAccent,//Color.fromRGBO(211, 211, 211, 1.0),
          fontFamily: 'Montserrat',
          textTheme: TextTheme(
            headline: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            title: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            subtitle: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
            body1: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
            button: TextStyle(
                fontSize: 20.0,
                color: Colors.blue,
                fontWeight: FontWeight.w300),
          ),
          disabledColor: Colors.grey,
          appBarTheme: AppBarTheme(
            elevation: 0.0,
          ),
        ),
      ),
    );
  }
}

