import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_studio/assets/myIcons.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/mainPages/communityPage/comment_card_part.dart';
import 'package:http/http.dart' as http;
import 'package:music_studio/mainPages/communityPage/user_article.dart';

class postCardPage extends StatefulWidget {
  postCardPage(
      {Key key,
      this.userid_id,
      this.articleid,
      this.userimage,
      this.username,
      this.articletime,
      this.device,
      this.articlecontent,
      this.imageList,
      this.articlelike,
      this.articlecomment,
      this.forwards,
      this.likeMode = 0,
      this.followMode = 0})
      : super(key: key);
  String articleid;
  String userimage;
  String username;
  String articletime;
  String device;
  String articlecontent;
  String userid_id;
  List<String> imageList;
  int articlelike;
  int articlecomment;
  int forwards;
  int likeMode;
  int followMode;

  @override
  State<postCardPage> createState() => _postCardPageState();
}

class _postCardPageState extends State<postCardPage> {
  List<Widget> widgetList = [];

  updatePostLikeCommShare(String articleid) async {
    var url = Uri.parse(Api.url + '/api/article/');
    print(articleid);
    var response = await http.put(url,
        headers: {"content-type": "application/json"},
        body: '{"articleid": "$articleid"' + '}');
  }

  delUpdatePostLikeCommShare(String articleid) async {
    var url = Uri.parse(Api.url + '/api/article/del/');
    print(articleid);
    var response = await http.put(url,
        headers: {"content-type": "application/json"},
        body: '{"articleid": "$articleid"' + '}');
  }

  @override
  Widget build(BuildContext context) {
    widgetList.clear();
    for (int i = 0; i < widget.imageList.length; ++i) {
      widgetList.add(Image(
          image: NetworkImage(widget.imageList[i]), height: 70, width: 70));
    }
    commentArea(String pid) {
      RenderBox renderBox = context.findRenderObject();
      var screenSize = renderBox.size;
      final option = showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, state) {
              return commentAllIn(
                articleid: widget.articleid.toString(),
              );
            });
          });
    }

    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
            padding: EdgeInsets.all(15.0),
            alignment: Alignment.center,
            height: 400,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: new AppBar(
                    elevation: 6.0,
                    shape: ContinuousRectangleBorder(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    backgroundColor: Color.fromARGB(255, 240, 240, 240),
                    leading: InkWell(
                        child: Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                            child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(widget.userimage),
                                child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.center,
                                    // width: 150,
                                    height: 150))),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserArticlePage(
                                        userName:widget.username,
                                        userid: widget.userid_id,
                                        userImage: widget.userimage,
                                      )));
                        }),
                    title: IntrinsicWidth(
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(widget.username,
                                  style: TextStyle(
                                      color: Color(0xFF111111),
                                      decorationStyle:
                                          TextDecorationStyle.double,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      textBaseline: TextBaseline.alphabetic,
                                      fontSize: 13,
                                      letterSpacing: 2,
                                      wordSpacing: 10,
                                      height: 1.5),
                                  textAlign: TextAlign.start)),
                          Text(widget.articletime,
                              style: TextStyle(
                                  color: Colors.grey,
                                  decorationStyle: TextDecorationStyle.double,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 11,
                                  letterSpacing: 2,
                                  wordSpacing: 10,
                                  height: 1.5),
                              textAlign: TextAlign.start)
                        ])),
                    actions: <Widget>[
                      // widget.uid == int.parse(UID)
                      //     ? Text("")
                      //     :
                      // IconButton(
                          // color: widget.followMode == 1
                          //     ? Colors.red[700]
                          //     : Colors.black,
                          // icon: widget.followMode == 1
                          //     ? Icon(MyIcons.followFont, size: 28)
                          //     : Icon(MyIcons.followFont),
                          // onPressed: () {
                          //   showFollowDialog(context);
                          //   print("click");
                          // })
                    ]),
                body: Neumorphic(
                    style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.only(bottomLeft: Radius.circular(0))),
                        depth: 20,
                        color: Color.fromARGB(255, 240, 240, 240)),
                    child: Container(
                        padding: EdgeInsets.only(left: 10, top: 20, right: 10),
                        child: new ListView(children: [
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(widget.articlecontent,
                                  style: TextStyle(
                                      color: Color(0xFF111111),
                                      decorationStyle:
                                          TextDecorationStyle.double,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      textBaseline: TextBaseline.alphabetic,
                                      fontSize: 13,
                                      letterSpacing: 2,
                                      wordSpacing: 10,
                                      height: 1.2),
                                  softWrap: true,
                                  maxLines: 100,
                                  overflow: TextOverflow.ellipsis)),
                          SizedBox(height: 10),
                          Container(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 15, right: 10),
                                  child: new Wrap(
                                      spacing: 10,
                                      runSpacing: 8,
                                      children: widgetList)))
                        ]))),
                bottomNavigationBar: Neumorphic(
                    style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        depth: -10,
                        color: Color.fromARGB(255, 240, 240, 240)),
                    child: IntrinsicWidth(
                        child: Container(
                            height: 40,
                            child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Row(children: <Widget>[
                                    new Row(children: [
                                      IconButton(
                                          color: widget.likeMode == 1
                                              ? Colors.red
                                              : Colors.black,
                                          icon: widget.likeMode == 1
                                              ? Icon(MyIcons.likeFont, size: 28)
                                              : Icon(MyIcons.likeFont),
                                          onPressed: () {
                                            //print(widget.likeMode.toString()+"11111111111");
                                            if (widget.likeMode == 0) {
                                              updatePostLikeCommShare(
                                                  widget.articleid);
                                              setState(() {
                                                widget.articlelike += 1;
                                                widget.likeMode = 1;
                                              });
                                            } else {
                                              delUpdatePostLikeCommShare(
                                                  widget.articleid);
                                              setState(() {
                                                widget.articlelike -= 1;
                                                widget.likeMode = 0;
                                              });
                                            }
                                          }),
                                      Text('${widget.articlelike}',
                                          style: TextStyle(
                                              color: Color(0xFF111111),
                                              decorationStyle:
                                                  TextDecorationStyle.double,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              fontSize: 15,
                                              letterSpacing: 2,
                                              wordSpacing: 10,
                                              height: 1.2))
                                    ]),
                                    SizedBox(width: 40),
                                    new Row(children: [
                                      IconButton(
                                          icon: Icon(Icons.chat),
                                          onPressed: () {
                                            //                          Navigator.of(context).push(
                                            // MaterialPageRoute(builder: (context) => commentUserCard()));
                                            commentArea(widget.articleid);
                                          }),
                                      Text('${widget.articlecomment}', //评论
                                          style: TextStyle(
                                              color: Color(0xFF111111),
                                              decorationStyle:
                                                  TextDecorationStyle.double,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              fontSize: 15,
                                              letterSpacing: 2,
                                              wordSpacing: 10,
                                              height: 1.2))
                                    ]),
                                    SizedBox(width: 40),
                                    new Row(children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.launch)),
                                      Text('0',
                                          style: TextStyle(
                                              color: Color(0xFF111111),
                                              decorationStyle:
                                                  TextDecorationStyle.double,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              fontSize: 15,
                                              letterSpacing: 2,
                                              wordSpacing: 10,
                                              height: 1.2))
                                    ])
                                  ])
                                ])))))));
  }
  showFollowDialog(BuildContext context) {
    //设置按钮
    Widget cancelButton = FlatButton(
      child: Text("取消"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("确定"),
      onPressed: () {
        if (widget.followMode == 0)
          //insertFollow(widget.uid, int.parse(UID))
          print("insert");
        else
          // deleteFollow(widget.uid, int.parse(UID));
          print('delect');
        setState(() {
          widget.followMode = 1 - widget.followMode;
        });
        Navigator.of(context).pop();
      },
    );

    //设置对话框
    AlertDialog alert = AlertDialog(
        title: Text("关注提示框"),
        content: Text("确定关注吗？"),
        actions: [continueButton, cancelButton]);

    AlertDialog alert2 = AlertDialog(
        title: Text("取消关注提示框"),
        content: Text("确定取消关注吗？"),
        actions: [continueButton, cancelButton]);

    //显示对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (widget.followMode == 0)
          return alert;
        else
          return alert2;
      },
    );
  }
}
