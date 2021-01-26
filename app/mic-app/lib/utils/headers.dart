import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final double height;

  Header({this.height = 400});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TitleImageClipper(),
      child: Container(
        width: double.infinity,
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: -100,
              top: -30,
              bottom: 0,
              child: Image.asset(
                'title_bw.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                height: height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 44, 154, 0.3),
                    Color.fromRGBO(0, 44, 154, 0.8)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
              ),
            ),
            TitlePageText(),
          ],
        ),
      ),
    );
  }
}

class TitleImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var w = size.width;
    var h = size.height;
    Path path = Path();
    path.lineTo(0, h);
    path.quadraticBezierTo(w * 0.033, h - (h * 0.1), w * 0.11, h - (h * 0.12));
    path.lineTo(w - w * 0.11, h - (h * 0.35));
    path.quadraticBezierTo(w - (w * 0.033), h - (h * 0.37), w, h - h * 0.47);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TitlePageText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 40,
          top: 60,
          child: Text('MIC',
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(letterSpacing: 4.0, fontWeight: FontWeight.w500)),
        ),
        Positioned(
          left: 40,
          top: 120,
          child: Text(
            'Musical',
            style: Theme.of(context).textTheme.headline.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = Colors.white,
                fontWeight: FontWeight.w700),
          ),
        ),
        Positioned(
          left: 40,
          top: 160,
          child: Text(
            'Instrument',
            style: Theme.of(context).textTheme.headline.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = Colors.white,
                fontWeight: FontWeight.w700),
          ),
        ),
        Positioned(
          left: 40,
          top: 200,
          child: Text(
            'Classifier',
            style: Theme.of(context).textTheme.headline.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = Colors.white,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class TitlePageTextBlack extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).accentColor;
    return Stack(
      children: <Widget>[
        Positioned(
          left: 40,
          top: 60,
          child: Text('MIC',
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(letterSpacing: 4.0, fontWeight: FontWeight.w500, color: color)),
        ),
        Positioned(
          left: 40,
          top: 120,
          child: Text(
            'Musical',
            style: Theme.of(context).textTheme.headline.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = color,
                fontWeight: FontWeight.w700),
          ),
        ),
        Positioned(
          left: 40,
          top: 160,
          child: Text(
            'Instrument',
            style: Theme.of(context).textTheme.headline.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = color,
                fontWeight: FontWeight.w700),
          ),
        ),
        Positioned(
          left: 40,
          top: 200,
          child: Text(
            'Classifier',
            style: Theme.of(context).textTheme.headline.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = color,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
