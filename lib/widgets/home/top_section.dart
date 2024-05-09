import 'package:flutter/material.dart';

class TopSection extends StatefulWidget {
  final int currentDate;
  final int hundred;
  final int hundredDate;

  TopSection({required this.currentDate, required this.hundred, required this.hundredDate});

  @override
  _TopSectionState createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  late String _timeLeft;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
  }

  void _updateTimeLeft() {
    _calculateTimeLeft();
    Future.delayed(Duration(seconds: 1), _updateTimeLeft);
  }

  void _calculateTimeLeft() async {
    Duration difference = await _timeUntilNextDay();
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);
    int seconds = difference.inSeconds.remainder(60);
    setState(() {
      _timeLeft = '$hours시간 $minutes분 $seconds초';
    });
  }

  Future<Duration> _timeUntilNextDay() async {
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
    DateTime midnightTomorrow = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    Duration difference = midnightTomorrow.difference(now);
    return difference;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '오늘이 끝나기까지',
              style: TextStyle(fontSize : 13, fontWeight : FontWeight.w700, color: Colors.black, fontFamily: 'Pretendard-Bold'),
              textAlign: TextAlign.center,
            ),
            Text(
              '$_timeLeft 남았어요!',
              style: TextStyle(fontSize : 18, fontWeight : FontWeight.w700, color: Colors.black, fontFamily: 'Pretendard-Bold'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(16),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
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

                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '오늘 커밋하면 연속 ${widget.currentDate}일🔥',
                    style: TextStyle(fontSize : 18, color: Colors.red, fontFamily: 'Pretendard-Bold', fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,

                  ),

                  Text(
                    '${widget.hundred}일 연속 커밋까지 D-${widget.hundredDate}',
                    style: TextStyle(fontSize : 16, color: Colors.red, fontFamily: 'Pretendard', fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
