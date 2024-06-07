import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterproject/models/post.dart';
import 'package:http/http.dart' as http;
import "../widgets/post/preview.dart";
import './create_post_page.dart';
import './page_details.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void fetchPosts() async {
    final url = 'http://localhost:3000/community/posts';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        posts = List<Post>.from(data.map((post) => Post.fromJson(post)));
      });
    } else {
      print('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '커뮤니티',
          style: TextStyle( fontSize : 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 /2 , // 가로:세로 비율 설정
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Preview(
              post: posts[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailPage(post: posts[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostPage(),
            ),
          ).then((_) {
            // 페이지가 닫힌 후 다시 데이터를 가져오도록 함
            fetchPosts();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
