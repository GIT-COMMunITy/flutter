import 'package:flutter/material.dart';
import 'package:flutterproject/widgets/home/Ranking.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('순위'),
      ),
      body: Center(
        child:CommitRanking()
      ),
    );
  }
}
