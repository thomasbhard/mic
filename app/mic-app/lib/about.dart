import 'package:flutter/material.dart';
import 'package:mic/utils/headers.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: Text(
                'About',
              ),
              centerTitle: true,
              textTheme: Theme.of(context).textTheme,
              elevation: 0.0,
              pinned: false,
              snap: false,
              backgroundColor: Theme.of(context).primaryColor,
              forceElevated: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: 300,
                    height: 300,
                    child: TitlePageTextBlack(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                    child: Text(
                      "This app is basically Shazam for Instruments. Dont't know what istrument you are listening to? Just let mic tell you! There is a 89% chance it's right.",
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  // InstrumentIconRow(),
                  Quotes(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
                    child: Text(
                      'The Geniuses behind this App:',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  ProfileFlatz(),
                  ProfileTom(),
                  FootNote(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileFlatz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          ProfilePicture('lukas.png'),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'Lukas', style: Theme.of(context).textTheme.title),
                TextSpan(text: ' ', style: Theme.of(context).textTheme.title),
                TextSpan(
                  text: 'Flatz',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 20, left: 10, right: 10),
            child: Text(
              'He tells the neurons how to behave. If you are not happy with the result - it is probably his fault.',
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.justify,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              'In general he is a nice guy but likes to cancel plans last minute. Be aware of that!',
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50),
          ),
        ],
      ),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Theme.of(context).accentColor)),
    );
  }
}

class ProfileTom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          ProfilePicture('tom.jpg'),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'Thomas', style: Theme.of(context).textTheme.title),
                TextSpan(text: ' ', style: Theme.of(context).textTheme.title),
                TextSpan(
                  text: 'Bernhard',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 20, left: 10, right: 10),
            child: Text(
              'He takes the hard work of Lukas and takes all the credit for it. If you are not happy with how this looks - it is probably his fault. Also he is colorbild.. So he should not design apps anyways..',
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.justify,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              '"Funniest guy i know!" - Barack Obama',
              style: Theme.of(context).textTheme.body1,
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
          ),
        ],
      ),
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Theme.of(context).accentColor)),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final String assetFile;
  ProfilePicture(this.assetFile);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundImage: AssetImage(assetFile),
        radius: 100,
      ),
      padding: EdgeInsets.symmetric(vertical: 20),
    );
  }
}

class Quote extends StatelessWidget {
  final String text;
  final String author;

  Quote({this.text, this.author});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: textTheme.body1,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          Text(
            '- $author',
            style: textTheme.subhead,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class Quotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
            child: Text(
              'What the people are saying about MIC:',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          Quote(
            text: 'This is the most useful app out there.',
            author: 'Mark Zuckerberg',
          ),
          Divider(
            color: Theme.of(context).accentColor,
            endIndent: 50,
            indent: 50,
          ),
          Quote(
            text: 'Forget Mars.. this is the future!',
            author: 'Elon Musk',
          ),
          Divider(
            color: Theme.of(context).accentColor,
            endIndent: 50,
            indent: 50,
          ),
          Quote(
            text:
                'I can never tell the difference between a Trumpet and a Cello. This app is a total lifesafer!',
            author: 'W. A. Mozart',
          ),
        ],
      ),
    );
  }
}

class InstrumentIconRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> assets = [
      'cel-50.png',
      'cla-50.png',
      'flu-50.png',
      'gac-50.png',
      'gel-50.png',
      'org-50.png',
      'pia-50.png',
      'sax-50.png',
      'tru-50.png'
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          for (String asset in assets)
            Image.asset(
              asset,
              width: 20,
            ),
        ],
      ),
    );
  }
}

class FootNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Column(
                        children: <Widget>[
                          Text(
                            'There are no problems.',
                            style: Theme.of(context).textTheme.title,
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 30),),
                          Text(
                            'Would you like to donate instead for this magnificent piece of work?',
                            style: Theme.of(context).textTheme.body1,
                          ),
                          OutlineButton(
                            onPressed: () {},
                            child: Text('Donate'),
                            borderSide: BorderSide(color: Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Text(
              'Report a problem',
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
            ),
          ),
          Text(
            'Total hours spent on StackOverflow: 257',
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          Text(
            'Total hours spent making the about section: 122',
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          Text(
            '© MIC GmbH',
            style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
