import 'package:flutter/material.dart';
import 'package:flutterproject/models/post.dart';


class Preview extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  Preview({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: ListTile(
          leading: Image.network(post.imageUrl),
          title: Text(post.title),
          subtitle: Text(post.username),
        ),
      ),
    );
  }
}
