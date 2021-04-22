import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:intl/intl.dart' show DateFormat;

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binary Clock',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          display1: TextStyle(color: Colors.black38, fontSize: 30),
        ),
        fontFamily: 'Alatsi',
      ),
      home: Scaffold(
        body: clock(),
      ),
    );
  }
}

class BinaryTime {
  List<String> binaryIntegers;

  BinaryTime() {
    DateTime now = DateTime.now();
    String hhmmss = DateFormat("Hms").format(now).replaceAll(':', '');

    binaryIntegers = hhmmss
        .split('')
        .map((str) => int.parse(str).toRadixString(2).padLeft(4, '0'))
        .toList();
  }
  get hoursTens => binaryIntegers[0];
  get hoursOnes => binaryIntegers[1];

  get minutesTens => binaryIntegers[2];
  get minuteOnes => binaryIntegers[3];
  get secondTens => binaryIntegers[4];
  get secondOnes => binaryIntegers[5];
}

class clock extends StatefulWidget {
  clock({Key key}) : super(key: key);

  @override
  _clockState createState() => _clockState();
}

class _clockState extends State<clock> {
  BinaryTime _now = BinaryTime();
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {
        _now = BinaryTime();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClockColumn(
            binaryInteger: _now.hoursTens,
            title: 'H',
            color: Colors.blue,
          ),
          ClockColumn(
            binaryInteger: _now.hoursOnes,
            title: 'h',
            color: Colors.blue,
          ),
          ClockColumn(
            binaryInteger: _now.minutesTens,
            title: 'M',
            color: Colors.green,
          ),
          ClockColumn(
            binaryInteger: _now.minuteOnes,
            title: 'm',
            color: Colors.green,
          ),
          ClockColumn(
            binaryInteger: _now.secondTens,
            title: 'S',
            color: Colors.red,
          ),
          ClockColumn(
            binaryInteger: _now.secondOnes,
            title: 's',
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

class ClockColumn extends StatelessWidget {
  String binaryInteger;
  String title;
  Color color;
  int rows;
  List bits;
  ClockColumn({this.binaryInteger, this.title, this.color, this.rows = 4}) {
    bits = binaryInteger.split('');
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...[
          Container(
            child: Text(
              title,
              style: Theme.of(context).textTheme.display1,
            ),
          )
        ],
        ...bits.asMap().entries.map((e) {
          int idx = e.key;
          String bit = e.value;
          bool isActive = bit == '1';
          int binaryCellValue = pow(2, 3 - idx);
          return AnimatedContainer(
            duration: Duration(milliseconds: 475),
            curve: Curves.ease,
            height: 40,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: isActive
                  ? color
                  : idx < 4 - rows
                      ? Colors.white.withOpacity(0)
                      : Colors.black38,
            ),
            margin: EdgeInsets.all(4),
            child: Center(
              child: isActive
                  ? Text(
                      binaryCellValue.toString(),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Container(),
            ),
          );
        }),
        ...[
          Text(
            int.parse(binaryInteger, radix: 2).toString(),
            style: TextStyle(fontSize: 30, color: color),
          )
        ]
      ],
    );
  }
}
