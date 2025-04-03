import 'package:flutter/material.dart';
import 'package:music_studio/GetMusic.dart';
import 'package:music_studio/assets/myIcons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/player_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

int listLength = 0;
List formlist = [];
String myid = '111';
List a = [];

Future _readShared() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  myid = preferences.get('id');
  print(myid);
}

class songListPage extends StatefulWidget {
  //songListPage({Key? key}) : super(key: key);

  @override
  State<songListPage> createState() => _songListPageState();
}

class _songListPageState extends State<songListPage> {
  
  initSongList() async {
    a.clear();
    for (var item in formlist) {
      List temp = await GetMusic.getSongDetails(item['musicid'].toString());
      a.add(temp[0]);
    }
  }

  getInfor() async {
    var url = Uri.parse(Api.url + '/api/music/rank/');
    var response = await http.post(
      url,
      headers: {"content-type": "application/json"},
    );
    var data = jsonDecode(Utf8Codec().decode(response.bodyBytes));
    print(data);
    formlist = data["data"];
    listLength = formlist.length;

    setState(() {
      formlist = data["data"];
      listLength = formlist.length;
    });
    initSongList();
  }

  @override
  void initState() {
    //初始化函数、带监听滑动功能

    initThisPage();
    getInfor();
    super.initState();
  }

  @override
  Future<void> initThisPage() async {
    await _readShared();
    print("myid:$myid");
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: new Icon(Icons.chevron_left, color: Colors.black, size: 30),
            onPressed: () {
              Navigator.of(context)..pop();
            },
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Text(
            '排行榜',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: new SingleChildScrollView(
            child: Container(
          color: Color(0xFFf4f4f4),
          child: Column(
            children: <Widget>[
              Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                  ),
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    "http://124.220.169.238:8000/media/img/0ee51f988635d262fe1d097f9671d3ff.jpeg",
                    fit: BoxFit.cover,
                  )),
              Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFF4EFEF),
                        ),
                        child: Row(children: [
                          Expanded(
                              child: Text(
                            '  每天最热排行榜',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          )),
                        ])),
                    SizedBox(
                      height: 5,
                    ),
                    buildGrid(context),
                  ]))
            ],
          ),
        )));
  }
}

class rankListItem extends StatefulWidget {
  rankListItem({
    Key key,
    this.count,
    this.musicname,
    this.musicalbum,
    this.musicid,
    this.musicsinger,
    this.followMode = 0,
  }) : super(key: key);
  final String musicname;
  final String musicalbum;
  final String musicid;
  final String musicsinger;
  int followMode;
  int count;
  @override
  State<rankListItem> createState() => _rankListItemState();
}

class _rankListItemState extends State<rankListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Colors.white),
      height: 60,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 30,
            child: Container(
              padding: EdgeInsets.fromLTRB(7, 7, 0, 0),
              child: Text(
                widget.count.toString() + "",
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(7, 7, 0, 0),
                child: Text(
                  widget.musicname + "",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                child: Text(
                  widget.musicsinger + "·" + widget.musicalbum + "",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          )),
          // IconButton(
          //     color: widget.followMode == 1 ? Colors.red[700] : Colors.black,
          //     icon: widget.followMode == 1
          //         ? Icon(MyIcons.followFont, size: 28)
          //         : Icon(MyIcons.followFont),
          //     onPressed: () {
          //       showFollowDialog(context);
          //       print("click");
          //     })
        ],
      ),
    );
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
        title: Text("添加喜欢提示框"),
        content: Text("确定添加到歌单吗？"),
        actions: [continueButton, cancelButton]);

    AlertDialog alert2 = AlertDialog(
        title: Text("移除喜欢提示框"),
        content: Text("确定移除喜欢吗？"),
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

Widget buildGrid(BuildContext context) {
  List<Widget> tiles = [];

  Widget content;
  int count = 0;
  for (var item in formlist) {
    count++;
    tiles.add(InkWell(
        onTap: () {
          print('我在这里');
          print( item['musicname'].toString());

          int temp = count;
          print('count:' + count.toString());
          PlayerPage.gotoPlayer(context, list: a, index:item['sub']);
        },
        child: rankListItem(
          count: count,
          musicname: item['musicname'].toString(),
          musicsinger: item['musicsinger'].toString(),
          musicid: item['musicid'],
          musicalbum: item['musicalbum'],
        )));
  }
  content = new Column(
    children: tiles,
  );
  return content;
}
