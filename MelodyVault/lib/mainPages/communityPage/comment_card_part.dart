import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_studio/common/api.dart';
import 'package:music_studio/mainPages/communityage/add_comment_part.dart';
import 'package:music_studio/mainPages/communityPage/comment_user_card.dart';

import 'package:shared_preferences/shared_preferences.dart';

dynamic test;
DateTime time;
List aList;
dynamic test2;
DateTime time2;
List aList2;

List commentFormlist = [];

class commentAllIn extends StatelessWidget {
  commentAllIn({
    Key key,
    this.articleid,
  }) : super(key: key);
  String articleid;
  int likes;
  int comments;
  int flag = 0;
  @override
  Widget build(BuildContext context) {
    return commentCard(articleid: articleid);
  }
}

class commentCard extends StatefulWidget {
  commentCard({Key key, this.articleid}) : super(key: key);
  String articleid;
  @override
  _commentCardState createState() => _commentCardState();
}

class _commentCardState extends State<commentCard> {
  List<Widget> commentWidgetList = [Divider()];
  void initState() {
    
    getAllComment();
  
    super.initState();
  }

  getAllComment() async {
    var url = Api.url + '/api/comment/';
    Map<String, dynamic> map1 = Map();
    map1['articleid'] = widget.articleid;
    var dio = Dio();
    var response = await dio.get(url, queryParameters: map1);
    Map<String, dynamic> data = response.data;
   
    print(data["data"][0]['comment'][0]);
    setState(() { commentFormlist = data["data"][0]['comment'];});
      for (var item in commentFormlist) {
      commentWidgetList.add(new commentUserCard(
          text: item['commentcontent'].toString(),
          time: item['commenttime'].toString().substring(5,10)+' '+item['commenttime'].toString().substring(11,16),
          touxiang: 'http://124.220.169.238:8000/media/' +
              item['userdata']['userimage'].toString(),
          username: item['userdata']['username'].toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.topCenter, children: [
      Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title:
                Text('评论', style: TextStyle(color: Colors.grey, fontSize: 25)),
            actions: [
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                       setState(() {
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) {
                        return new addCommentpart(
                          articleid:widget.articleid
                            );
                      }));
                    });
                  },
                  color: Colors.grey)
            ],
          ),
          body: Container(
              height: 400,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: commentWidgetList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return commentWidgetList[index];
                  })))
    ]);
  }
}
