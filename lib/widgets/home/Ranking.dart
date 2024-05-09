import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommitRanking extends StatefulWidget {
  @override
  _CommitRankingState createState() => _CommitRankingState();
}

class _CommitRankingState extends State<CommitRanking> {
  List<Map<String, dynamic>> _rankingList = [];
  bool _isLoading = true;
  String _githubUsername = 'cowboysj'; // 사용자의 GitHub 아이디

  @override
  void initState() {
    super.initState();
    _fetchCommitRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오늘의 커밋왕'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildCommitRanking(),
    );
  }

  Widget _buildCommitRanking() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView.builder(
        itemCount: _rankingList.length,
        itemBuilder: (context, index) {
          final ranking = _rankingList[index];
          final place = index + 1;
          final imageUrl = ranking['avatar_url'];
          final username = ranking['username'];
          final commitCount = ranking['commit_count'];
          final consecutiveDays = ranking['consecutive_days'];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
            title: Text('$place등 $username  $commitCount commits'),
            subtitle: Text('연속 $consecutiveDays일'),
          );
        },
      ),
    );
  }

  Future<void> _fetchCommitRanking() async {
    final String apiUrl = 'https://api.github.com/users/$_githubUsername/following';
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

        for (var user in data) {
          final userId = user['login'];
          final commitInfo = await _getUserCommitInfo(userId, token!);
          _rankingList.add(commitInfo);
        }

        // 사용자 본인의 커밋 정보 가져오기
        if (_githubUsername != null) {
          final selfCommitInfo = await _getUserCommitInfo(_githubUsername!, token!);
          _rankingList.add(selfCommitInfo);
        }


        // 커밋 정보를 모두 가져온 후, 커밋 수와 연속 커밋일수를 기준으로 정렬
        _rankingList.sort((a, b) {
          int comparison = b['consecutive_days'].compareTo(a['consecutive_days']);
          if (comparison != 0) {
            return comparison;
          } else {
            return b['commit_count'].compareTo(a['commit_count']);
          }
        });
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

  Future<Map<String, dynamic>> _getUserCommitInfo(String userId, String token) async {
    final DateTime today = DateTime.now();
    final response = await http.get(
      Uri.parse('https://api.github.com/users/$userId/events'),
      headers: {
        'Authorization': 'token $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      int commitCount = 0;
      int consecutiveDays = 0;

      for (var event in data) {
        final eventType = event['type'];
        final payload = event['payload'];
        if (eventType == 'PushEvent' && payload != null) {
          final commitDateStr = event['created_at'].substring(0, 10);
          final commitDate = DateTime.parse(commitDateStr);
          if (commitDate.year == today.year && commitDate.month == today.month && commitDate.day == today.day) {
            commitCount++;
            consecutiveDays++;
          }
        }
      }

      return {
        'username': userId,
        'avatar_url': 'https://github.com/$userId.png',
        'commit_count': commitCount,
        'consecutive_days': consecutiveDays,
      };
    } else {
      print('Failed to load user data: ${response.statusCode}');
      return {};
    }
  }
}
