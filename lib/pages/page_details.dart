import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  PostDetailPage({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(post.imageUrl),
            SizedBox(height: 8.0),
            Text(
              post.title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('By ${post.username}'),
            SizedBox(height: 8.0),
            Text(post.content),
            SizedBox(height: 8.0),
            Text('Posted on ${post.date.toLocal()}'),
          ],
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
