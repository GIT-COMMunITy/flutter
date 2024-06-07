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
        child: Column(
          children: [

            // 이미지를 가로로 더 넓게 표시하기 위해 Expanded 위젯 사용
            Expanded(
              flex: 15, // 이미지가 전체 너비의 80%를 차지하도록 설정
              child: Image.network(
                post.imageUrl,
                fit: BoxFit.cover, // 이미지가 공간을 채우도록 설정
              ),
            ),
            Expanded(
              flex: 12, // 제목과 유저명이 전체 너비의 20%를 차지하도록 설정
              child: ListTile(
                title: Text(post.title),
                subtitle: Text(post.username),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
