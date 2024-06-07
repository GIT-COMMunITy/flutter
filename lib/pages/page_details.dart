import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import 'create_post_page.dart';
import 'package:http/http.dart' as http;

class PostDetailPage extends StatelessWidget {
  final Post post;

  PostDetailPage({required this.post});

  Future<void> deletePost(BuildContext context) async {
    final url = 'http://localhost:3000/community/posts/${post.id}';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        // 게시물이 성공적으로 삭제되었을 때
        Navigator.pushReplacementNamed(context, '/community');
      } else {
        // 게시물 삭제에 실패한 경우
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete post'),
          ),
        );
      }
    } catch (e) {
      // 네트워크 오류 등의 예외 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting post'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(post.imageUrl),
              SizedBox(height: 8.0),
              Text(
                post.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text('By ${post.username}'),
              SizedBox(height: 8.0),
              Text(post.content),
              SizedBox(height: 8.0),
              Text('Posted on ${post.date.toLocal()}'),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePostPage(post: post),
                        ),
                      );
                    },
                    child: Text('수정하기'),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('삭제하기'),
                            content: Text('정말 삭제하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deletePost(context);
                                },
                                child: Text('삭제'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('삭제하기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(
        selectedIndex: 4,
        onItemTapped: (index) {
          Navigator.pushReplacementNamed(context, [
            '/home',
            '/ranking',
            '/calendar',
            '/mypage',
            '/community'
          ][index]);
        },
      ),
    );
  }
}
