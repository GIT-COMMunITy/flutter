import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  Footer({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // 물결처럼 번지는 애니메이션을 제거
      backgroundColor: Colors.white, // 배경색을 검은색으로 지정
      selectedItemColor: Colors.black, // 선택된 아이템의 색상을 검은색으로 지정
      unselectedItemColor: Colors.grey, // 선택되지 않은 아이템의 색상을 회색으로 지정
      selectedLabelStyle: TextStyle(color: Colors.black), // 선택된 아이템의 글자 색상을 검은색으로 지정
      unselectedLabelStyle: TextStyle(color: Colors.grey), // 선택되지 않은 아이템의 글자 색상을 회색으로 지정
      showSelectedLabels: true, // 선택된 아이템의 라벨을 표시
      showUnselectedLabels: true, // 선택되지 않은 아이템의 라벨을 표시
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: '순위',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: '커밋 달력',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '마이페이지',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
