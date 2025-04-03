import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/mainPages/communityPage/pos_card_part.dart';
import 'package:music_studio/mainPages/minePage/mine_all.dart';

int listLength = 0;
List formlist = [];

class UserArticlePage extends StatefulWidget {
  final String userid;
  final String userName;
  final String userImage;
  UserArticlePage({Key key, this.userid, this.userName,this.userImage}) : super(key: key);

  @override
  State<UserArticlePage> createState() => _UserArticlePageState();
}

class _UserArticlePageState extends State<UserArticlePage> {
  List<Widget> widgetList = [];
  @override
  void initState() {
    //初始化函数、带监听滑动功能
    super.initState();
    getInfor();
  }

  getInfor() async {
    var url = Api.url + '/api/article/';
    Map<String, dynamic> map1 = Map();
    map1['userid'] =widget.userid;
  
    var dio = Dio();
    var response =
        await dio.get(url, queryParameters: map1).timeout(Duration(seconds: 3));
    // print('Response: $response');
    Map<String, dynamic> data = response.data;
  //  print("userid:"+widget.userid);
  //   print(widget.userName);
    formlist = data["data"];
    print(formlist);
    // print(formlist[0]['articleid']);
    listLength = formlist.length;
    setState(() {});
    for (var item in formlist) {
      List<String> tmp = [];
      tmp.add('http://124.220.169.238:8000/media/' + item['articlepic1']);
      tmp.add('http://124.220.169.238:8000/media/' + item['articlepic2']);
      tmp.add('http://124.220.169.238:8000/media/' + item['articlepic3']);
      String time = item['articletime'].toString().substring(5, 10) +
          ' ' +
          item['articletime'].toString().substring(11, 16);
      widgetList.add(new postCardPage(
        articletime: time,
        articlecontent: item['articlecontent'].toString(),
        articlelike: item['articlelike'],
        articlecomment: item['articlecomment'],
        username: widget.userName,
        userimage: widget.userImage ,
           
        imageList: tmp,
        articleid: item['articleid'],
      ));
    }
  }

  Widget build(BuildContext context) {
      return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Text(
            widget.userName + '的帖子',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: Scaffold(
                body: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: widgetList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return widgetList[index];
                    }),
              )),
            ],
          ),
        ),
      ),
    );
    }
  }

