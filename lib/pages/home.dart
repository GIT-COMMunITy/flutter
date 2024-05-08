import 'package:flutter/material.dart';
import 'package:flutterproject/widgets/home/top_section.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Expanded(
            flex: 3,
            child:   TopSection(
              currentDate: 10, // 예시로 임의의 데이터 사용
              hundred: 100, // 예시로 임의의 데이터 사용
              hundredDate: 90, // 예시로 임의의 데이터 사용
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Text('Section 2'),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.green,
              child: Center(
                child: Text('Section 3'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.yellow,
              child: Center(
                child: Text('Section 4'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
