import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoCommit extends StatefulWidget {
  @override
  _NoCommitState createState() => _NoCommitState();
}

class _NoCommitState extends State<NoCommit> {
  Set<String> userIdSet = {};
  List<String> _noCommitUsers = [];
  List<dynamic> _followingList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFollowingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffFFF7F0), // 배경색을 lightBlue로 설정합니다.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽으로 정렬합니다.
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '⭐ 오늘 커밋 안 한 사람',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard-Bold'
                ),
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(child: _buildNoCommitList()),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCommitList() {
    if (_noCommitUsers.isEmpty) {
      return Center(
        child: Text('No users found without commits today.'),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _noCommitUsers.length,
      itemBuilder: (context, index) {
        final user = _noCommitUsers[index];
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('https://github.com/$user.png'),
                radius: 30,
              ),
              SizedBox(height: 8),
              Text(user),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchFollowingList() async {
    final String githubUsername = 'cowboysj';
    final String apiUrl = 'https://api.github.com/users/$githubUsername/following';
    final token = dotenv.env['GITHUB_TOKEN'];

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _followingList = [];
          for (var user in data) {
            final userId = user['login'];
            if (!userIdSet.contains(userId)) {
              _followingList.add(userId);
              userIdSet.add(userId);
            }
          }
        });

        // 사용자 목록을 가져온 후에 커밋 확인
        await _checkCommits(token!);
      } else {
        throw Exception('Failed to load following list');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkCommits(String githubToken) async {
    final DateTime today = DateTime.now();
    final List<String> noCommitUsers = [];

    for (var userId in userIdSet) {
      final response = await http.get(
        Uri.parse('https://api.github.com/users/$userId/events'),
        headers: {
          'Authorization': 'token $githubToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final hasCommitToday = data.any((event) {
          final eventType = event['type'];
          final payload = event['payload'];
          if (eventType == 'PushEvent' && payload != null) {
            final commits = payload['commits'];
            final commitDateStr = event['created_at'].substring(0, 10);
            final commitDate = DateTime.parse(commitDateStr);
            return commitDate.year == today.year &&
                commitDate.month == today.month &&
                commitDate.day == today.day;
          }
          return false;
        });

        if (!hasCommitToday) {
          noCommitUsers.add(userId);
        }
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    }

    setState(() {
      _noCommitUsers = noCommitUsers;
    });
  }
}