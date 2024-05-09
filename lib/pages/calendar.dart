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
            commitCounts.update(date, (value) => value + 1, ifAbsent: () => 1);
            commitMessages.update(date, (value) => value + [event['payload']['commits'].map((commit) => commit['message']).join('\n')], ifAbsent: () => [event['payload']['commits'].map((commit) => commit['message']).join('\n')]);
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
            title: Text('Commits on ${date.year}-${date.month}-${date.day}'),
            content: Text('${_commitMessages[date]?.join('\n') ?? ''}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
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
        title: Text('GitHub Contribution Calendar'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousMonth,
              ),
              Text(
                '${_currentMonth.year}-${_currentMonth.month}',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextMonth,
              ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemCount: _currentMonth.difference(DateTime(_currentMonth.year, _currentMonth.month, 1)).inDays +
                  DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day,
              itemBuilder: (context, index) {
                DateTime date = DateTime(_currentMonth.year, _currentMonth.month, index + 1);
                int commitCount = _commitCounts[date] ?? 0;
                Color color = commitCount == 0
                    ? Colors.grey[200]!
                    : commitCount <= 2
                    ? Colors.lightGreen[100]!
                    : commitCount <= 5
                    ? Colors.lightGreen[300]!
                    : commitCount <= 10
                    ? Colors.lightGreen[500]!
                    : commitCount <= 15
                    ? Colors.lightGreen[700]!
                    : Colors.lightGreen[900]!;

                return InkWell(
                  onTap: () {
                    _onDateSelected(date);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
