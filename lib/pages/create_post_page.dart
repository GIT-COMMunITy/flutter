import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/post.dart';

class CreatePostPage extends StatefulWidget {
  final Post? post; // 수정을 위한 기존 게시물 정보 전달

  CreatePostPage({this.post});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    // 기존 게시물 정보가 전달되었다면 해당 정보를 입력 폼에 표시
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _contentController.text = widget.post!.content;
    }
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void createOrUpdatePost() async {
    final url = widget.post != null
        ? 'http://localhost:3000/community/posts/${widget.post!.id}'
        : 'http://localhost:3000/community/posts';
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final data = {
      'title': _titleController.text,
      'content': _contentController.text,
      'username': 'cowboysj', // 임시 사용자명
      'imageUrl': _image != null
          ? _image!.path
          : 'https://via.placeholder.com/150', // 임시 이미지 URL
    };

    final response = widget.post != null
        ? await http.patch(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    )
        : await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Post ${widget.post != null ? 'updated' : 'created'} successfully.');
      Navigator.pop(context); // 수정 또는 생성 후 이전 페이지로 이동
    } else {
      print('Failed to ${widget.post != null ? 'update' : 'create'} post.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post != null ? '글 수정하기' : '글 작성하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: '내용',
              ),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: getImage,
              child: Text('이미지 업로드'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: createOrUpdatePost,
              child: Text(widget.post != null ? '수정하기' : '업로드'),
            ),
          ],
        ),
      ),
    );
  }
}
