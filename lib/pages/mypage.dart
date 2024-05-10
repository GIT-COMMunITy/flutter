import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> guestbookEntries = [];

  // GitHub 사용자 정보를 저장할 변수
  String? userId;
  List<String> followers = [];
  List<String> following = [];

  @override
  void initState() {
    super.initState();
    fetchGuestbookOnStart();
    fetchGitHubUserInfo(
        'cowboysj'); // GitHub 사용자 정보 가져오기 (여기서 'username'에는 사용자의 GitHub 아이디를 넣어야 함)
    fetchFollowersAndFollowing(
        'cowboysj'); // 팔로워와 팔로잉 정보 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xffFFF2F2),
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text(
                userId ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Color(0xffFFF2F2),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 팔로워 리스트 보여주기
                      showFollowers();
                    },
                    child: Text('팔로워'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // 팔로잉 리스트 보여주기
                      showFollowing();
                    },
                    child: Text('팔로잉'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: guestbookEntries.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(guestbookEntries[index]),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '글을 입력하세요...',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    postToGuestbook(_controller.text);
                    _controller.clear();
                  },
                  child: Text('등록'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void postToGuestbook(String content) async {
    final url = 'http://localhost:3000/guestbook/cowboysj';
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Origin': 'http://localhost:3000',
    };
    final data = {'id': 'cowboysj', 'content': content};

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Guestbook entry added successfully');
      fetchGuestbookOnStart();
    } else {
      print('Failed to add entry to guestbook');
    }
  }

  void fetchGuestbookOnStart() async {
    final response = await http.get(
        Uri.parse('http://localhost:3000/guestbook/cowboysj'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        guestbookEntries =
        List<String>.from(data.map((entry) => entry['content'].toString()));
      });
    } else {
      print('Failed to load guestbook');
    }
  }

  // GitHub 사용자 정보 가져오는 함수
  void fetchGitHubUserInfo(String username) async {
    final response = await http.get(
      Uri.parse('https://api.github.com/users/$username'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userId = data['login'];
      });
    } else {
      print('Failed to load GitHub user info');
    }
  }

  // 팔로워와 팔로잉 정보 가져오는 함수
  void fetchFollowersAndFollowing(String username) async {
    final followerResponse = await http.get(
      Uri.parse('https://api.github.com/users/$username/followers'),
    );
    final followingResponse = await http.get(
      Uri.parse('https://api.github.com/users/$username/following'),
    );

    if (followerResponse.statusCode == 200 &&
        followingResponse.statusCode == 200) {
      final followerData = jsonDecode(followerResponse.body);
      final followingData = jsonDecode(followingResponse.body);
      List<String> followersList = [];
      List<String> followingList = [];
      for (var follower in followerData) {
        followersList.add(follower['login']);
      }
      for (var following in followingData) {
        followingList.add(following['login']);
      }
      setState(() {
        followers = followersList;
        following = followingList;
      });
    } else {
      print('Failed to load followers or following list');
    }
  }

  void showFollowers() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '팔로워',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Pretendard-Bold",
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: followers.map((follower) {
                return ListTile(
                  title: Text(follower),
                );
              }).toList(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void showFollowing() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '팔로잉',
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Pretendard-Bold",
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: following.map((following) {
                return ListTile(
                  title: Text(following),
                );
              }).toList(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
