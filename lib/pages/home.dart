import 'package:flutter/material.dart';
import 'package:flutterproject/widgets/home/Ranking.dart';
import 'package:flutterproject/widgets/home/nocommit.dart';
import 'package:flutterproject/widgets/home/top_section.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopSection(
            currentDate: 10, // 예시로 임의의 데이터 사용
            hundred: 100, // 예시로 임의의 데이터 사용
            hundredDate: 90, // 예시로 임의의 데이터 사용
          ),

          Expanded(
            child: NoCommit(), // NoCommit 위젯을 Expanded 위젯으로 감싸서 화면의 나머지 영역을 차지하도록 합니다.
          ),
          Expanded(
            child: CommitRanking(), // NoCommit 위젯을 Expanded 위젯으로 감싸서 화면의 나머지 영역을 차지하도록 합니다.
          ),
        ],
      ),
    );
  }
}
