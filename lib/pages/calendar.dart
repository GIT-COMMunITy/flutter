import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  Map<DateTime, int> _commitCounts = {};
  Map<DateTime, List<String>> _commitMessages = {};

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now();
    _fetchCommitData(_currentMonth);
  }

  Future<void> _fetchCommitData(DateTime month) async {
    final String githubUsername = 'cowboysj';
    final String apiUrl = 'https://api.github.com/users/$githubUsername/events';
    final token = dotenv.env['GITHUB_TOKEN'];

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        Map<DateTime, int> commitCounts = {};
        Map<DateTime, List<String>> commitMessages = {};

        data.forEach((event) {
          if (event['type'] == 'PushEvent') {
            String dateStr = event['created_at'].substring(0, 10);
            DateTime date = DateTime.parse(dateStr);
            if (date.month == month.month) { // 현재 월의 데이터만 고려
              commitCounts.update(date, (value) => value + 1, ifAbsent: () => 1);
              commitMessages.update(date, (value) => value + [event['payload']['commits'].map((commit) => commit['message']).join('\n')], ifAbsent: () => [event['payload']['commits'].map((commit) => commit['message']).join('\n')]);
            }
          }
        });

        setState(() {
          _commitCounts = commitCounts;
          _commitMessages = commitMessages;
        });
      } else {
        throw Exception('Failed to load commit data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      _fetchCommitData(_currentMonth);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _fetchCommitData(_currentMonth);
    });
  }

  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
    _showCommitDialog(selectedDate);
  }

  void _showCommitDialog(DateTime date) {
    if (_commitMessages.containsKey(date)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(' ${date.year}년 ${date.month}월 ${date.day}일 Commit 기록', style: TextStyle(fontWeight: FontWeight.w700),),
            content: Text('${_commitMessages[date]?.join('\n') ?? ''}', style: TextStyle(fontWeight: FontWeight.w700)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('닫기'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 커밋 달력', style: TextStyle(fontWeight: FontWeight.w700),),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 1,
        showNavigationArrow: true,
        headerStyle: CalendarHeaderStyle(
          textStyle: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        todayHighlightColor: Colors.red,
        showDatePickerButton: true,
        showCurrentTimeIndicator: true,
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        dataSource: _getCalendarDataSource(),
        onViewChanged: (viewChangedDetails) {
          _fetchCommitData(viewChangedDetails.visibleDates[viewChangedDetails.visibleDates.length ~/ 2]);
        },
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
            _onDateSelected(calendarTapDetails.date!);
          }
        },
      ),
    );
  }

  _DataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];
    _commitCounts.forEach((key, value) {
      if (_commitCounts.containsKey(key)) {
        appointments.add(Appointment(
          startTime: key,
          endTime: key.add(Duration(days: 0)),
          subject: value.toString(),
          color: getColorForCommitCount(value),
        ));
      }
    });

    return _DataSource(appointments);
  }




  Color getColorForCommitCount(int commitCount) {
    if (commitCount == 0) {
      return Colors.grey[200]!;
    } else if (commitCount <= 5) {
      return Colors.red[400]!;
    } else if (commitCount <= 10) {
      return Colors.red[300]!;
    } else if (commitCount <= 15) {
      return Colors.red[200]!;
    } else {
      return Colors.red[100]!;
    }
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
