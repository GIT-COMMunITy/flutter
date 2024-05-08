import 'package:flutter/material.dart';

class TopSection extends StatelessWidget {
  final int currentDate;
  final int hundred;
  final int hundredDate;

  TopSection({required this.currentDate, required this.hundred, required this.hundredDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘이 끝나기까지\n${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} 남았어요!',
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오늘 커밋하면 연속 ${currentDate}일🔥',
                  style: TextStyle(color: Colors.pink),
                ),
                SizedBox(height: 8),
                Text(
                  '${hundred}일 연속 커밋까지 D-${hundredDate}',
                  style: TextStyle(color: Colors.pink),
                ),
                SizedBox(height: 8),
                Text(
                  '연속 ${currentDate}일, ${hundred}, ${hundredDate} 는 핑크색으로 하고 나머지는 검은색으로 해줘',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
