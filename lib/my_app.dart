import 'package:flutter/material.dart';
import 'widgets/header.dart'; // 중복된 임포트 제거

import 'pages/calendar.dart';
import 'pages/home.dart';
import 'pages/mypage.dart';
import 'pages/ranking.dart';
import 'widgets/footer.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    RankingPage(),
    CalendarPage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // 페이지 이동
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/ranking');
        break;
      case 2:
        Navigator.pushNamed(context, '/calendar');
        break;
      case 3:
        Navigator.pushNamed(context, '/mypage');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Footer(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/ranking': (context) => RankingPage(),
        '/calendar': (context) => CalendarPage(),
        '/mypage': (context) => MyPage(),
      },
    );
  }
}
