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
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    fetchGuestbookOnStart(); // 처음 렌더링될 때만 호출
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
            child: ListView.builder(
              itemCount: guestbookEntries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(guestbookEntries[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '방명록을 작성하세요',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              postToGuestbook(_controller.text); // 등록 버튼을 눌렀을 때 호출
              _controller.clear();
            },
            child: Text('등록'),
          ),
        ],
      ),
    );
  }

  void postToGuestbook(String content) async {
    final String url = 'http://localhost:3000/guestbook/cowboysj';
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Origin': 'http://localhost:3000',
    };
    final Map<String, dynamic> data = {'id': 'cowboysj', 'content': content};

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Guestbook entry added successfully');
      fetchGuestbookOnStart(); // 등록 후 방명록 새로고침
    } else {
      print('Failed to add entry to guestbook');
    }
  }

  void fetchGuestbookOnStart() async {
    final response = await http.get(Uri.parse('http://localhost:3000/guestbook/cowboysj'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        guestbookEntries = data.map((entry) => entry['content'].toString()).toList();
      });
    } else {
      print('Failed to load guestbook');
    }
  }
}
