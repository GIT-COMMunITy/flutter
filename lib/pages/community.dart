import 'package:flutter/material.dart';
import 'package:flutterproject/pages/page_details.dart';
import 'package:flutterproject/widgets/post/preview.dart';
import '../models/post.dart';


class CommunityPage extends StatelessWidget {
  final List<Post> posts = [
    Post(
      title: 'Sample Title 1',
      content: 'This is the content of the first post.',
      username: 'User1',
      imageUrl: 'https://via.placeholder.com/150',
      date: DateTime.now(),
    ),
    Post(
      title: 'Sample Title 2',
      content: 'This is the content of the second post.',
      username: 'User2',
      imageUrl: 'https://via.placeholder.com/150',
      date: DateTime.now(),
    ),
    // Add more posts here...
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Preview(
          post: posts[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailPage(post: posts[index]),
              ),
            );
          },
        );
      },
    );
  }
}
