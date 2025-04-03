import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_studio/utils/shared_preference_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainPages/minePage/mine_all.dart';
import 'mainPages/communityPage/community_all.dart';
import 'mainPages/homePage/home_all.dart';

  class Bottom extends StatefulWidget {
   _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _bottomNavPages = []; // 底部导航栏各个可切换页面组

  void initState() {
    super.initState();
    _bottomNavPages..add(homePage())..add(communityPage())..add(minePage());
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomNavPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),

          BottomNavigationBarItem(icon: Icon(Icons.camera), label: "社区"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的")
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFAAD2AA),
        unselectedItemColor: Color(0xFFF4EFEF),
        onTap: _onItemTapped,
      ),
    );
  }
}