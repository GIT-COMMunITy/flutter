import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
              child: Text(
                "COMMinITy",
                style: TextStyle(
                  color:Color(0xffff6868),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  //color: Color(0xFF6868), // FF6868 색상
                  fontFamily: 'YeongdeokSnowCrab', // 폰트 적용
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
