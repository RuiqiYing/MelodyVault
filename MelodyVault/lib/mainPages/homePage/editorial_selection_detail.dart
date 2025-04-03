import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:music_studio/GetMusic.dart';
import 'package:music_studio/assets/myIcons.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/mainPages/communityPage/add_post_part.dart';
import 'package:music_studio/player_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String myid = '';
List a = [];
List<Widget> tiles = [Divider()];
List formlist = [];

updatePostLike(String playlistname, String userid) async {
  var url = Uri.parse(Api.url + '/api/playlist/');
  var response = await http.post(url,
      headers: {"content-type": "application/json"},
      body: '{"playlistname": "' +
          playlistname +
          '", "userid": "' +
          userid +
          '"}');
  // print(response.body);
}

removePostLike(String playlistname, String userid) async {
  var url = Uri.parse(Api.url + '/api/playlist/');
  var response = await http.delete(url,
      headers: {"content-type": "application/json"},
      body: '{"playlistname": "' +
          playlistname +
          '", "userid": "' +
          userid +
          '"}');
  // print(response.body);
}

updateSongPostLike(String userid, String playlistname, String musicid,
    String musicname, String musicsinger, String musicalbum) async {
  var url = Uri.parse(Api.url + '/api/music/');
  var response = await http.post(url,
      headers: {"content-type": "application/json"},
      body: '{"playlistnameuserid": "' +
          userid +
          '", "playlistname": "' +
          playlistname +
          '", "musicid": "' +
          musicid +
          '", "musicname": "' +
          musicname +
          '", "musicsinger": "' +
          musicsinger +
          '", "musicalbum": "' +
          musicalbum +
          '"}');
  // print(response.body);
}

removeSongPostLike(String playlistname, String userid) async {
  var url = Uri.parse(Api.url + '/api/music/');
  var response = await http.delete(url,
      headers: {"content-type": "application/json"},
      body: '{"playlistname": "' +
          playlistname +
          '", "userid": "' +
          userid +
          '"}');
  // print(response.body);
}

int songListLikeMode = 0;
Future _readShared() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  myid = preferences.get('id');
  // print(myid);
}

class songListDetail extends StatefulWidget {
  final String playlistname;
  final String playlistimage;
  songListDetail({Key key, this.playlistname, this.playlistimage})
      : super(key: key);

  @override
  State<songListDetail> createState() => _songListDetailState();
}

class _songListDetailState extends State<songListDetail> {
  List<Widget> widgetList = [];
  Widget content;

  void initState() {
    //初始化函数、带监听滑动功能
    _readShared();
    getLike();

    getInfor();

    super.initState();
  }

  getLike() async {
    var url = Api.url + '/api/playlist/ret/';
    Map<String, dynamic> map1 = Map();
    map1['playlistname'] = widget.playlistname;
    map1['userid'] = myid;
    var dio = Dio();
    var response =
        await dio.get(url, queryParameters: map1).timeout(Duration(seconds: 3));
    // print('Response: $response');
    Map<String, dynamic> data = response.data;
    songListLikeMode = data["ret"];
    int like = data["ret"];

    print("当前状态" + like.toString());
  }

  initSongList() async {
    a.clear();
    print('111111');
    print(formlist);
    for (var item in formlist) {
      List temp = await GetMusic.getSongDetails(item['musicid'].toString());
      a.add(temp[0]);
    }
  }

  getInfor() async {
    var url = Api.url + '/api/playlist/';
    Map<String, dynamic> map = Map();
    map['playlistname'] = widget.playlistname;
    var dio = Dio();
    var response =
        await dio.get(url, queryParameters: map).timeout(Duration(seconds: 3));
    Map<String, dynamic> data = response.data;

    setState(() {
      formlist.clear();
      formlist = data["data"];
      print(formlist);
    });

    int count = -1;

    tiles.clear();
    for (var item in formlist) {
      count++;
      tiles.add(InkWell(
        onTap: () {
          PlayerPage.gotoPlayer(context, list: a, index: item['sub']);
        },
        child: songListItem(
          musicname: item['musicname'],
          musicalbum: item['musicalbum'],
          musicid: item['musicid'].toString(),
          musicsinger: item['musicsinger'],
        ),
      ));
    }
    initSongList();
  }

  @override
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
            '歌单详情',
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
                child: Image.network(widget.playlistimage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity),
              ),
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
                            '  编辑精选歌单，为你挑选',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          )),
                          IconButton(
                              color: songListLikeMode == 1
                                  ? Colors.red[700]
                                  : Colors.black,
                              icon: songListLikeMode == 1
                                  ? Icon(MyIcons.followFont, size: 28)
                                  : Icon(MyIcons.followFont),
                              onPressed: () {
                                showListLikeDialog(context);
                                print("click");
                              })
                        ])),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: SizedBox(
                        width: 500,
                        height: 1000,
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: tiles.length,
                            itemBuilder: (BuildContext context, int index) {
                              return tiles[index];
                            }),
                      ),
                    ),
                  ]))
            ],
          ),
        )));
  }

  showListLikeDialog(BuildContext context) {
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
        if (songListLikeMode == 0) {
          updatePostLike(widget.playlistname, myid);
          print("insert");
        } else {
          removePostLike(widget.playlistname, myid);
          print('delect');
        }

        setState(() {
          songListLikeMode = 1 - songListLikeMode;
        });
        Navigator.of(context).pop();
      },
    );

    //设置对话框
    AlertDialog alert = AlertDialog(
        title: Text("添加歌单提示框"),
        content: Text("确定添加到我的歌单吗？"),
        actions: [continueButton, cancelButton]);

    AlertDialog alert2 = AlertDialog(
        title: Text("移除歌单提示框"),
        content: Text("确定移除歌单吗？"),
        actions: [continueButton, cancelButton]);

    //显示对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (songListLikeMode == 0)
          return alert;
        else
          return alert2;
      },
    );
  }
}

class songListItem extends StatefulWidget {
  songListItem({
    Key key,
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
  @override
  State<songListItem> createState() => _songListItemState();
}

class _songListItemState extends State<songListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Colors.white),
      height: 60,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
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
          print("insertSong");
        else
          // deleteFollow(widget.uid, int.parse(UID));
          print('delectSong');
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

// Widget buildGrid(BuildContext context) {
//   List<Widget> tiles = [];
//   Widget content;
//   int count = -1;
//   for (var item in formlist) {
//     count++;
//     tiles.add(InkWell(
//       onTap: () async {
//         print("click me");
//         print(item['musicid'].toString());
//         print(item['musicname'].toString());
//         // List a=[];
//         // print(GetMusic.getSongDetails(item['musicid'].toString()));
//         // a=await GetMusic.getSongDetails(item['musicid'].toString());
//         // print(a);

//         // print('111111111'+a.length.toString());
//         PlayerPage.gotoPlayer(context, list: a, index: count);
//       },
//       child: songListItem(
//         musicname: item['musicname'],
//         musicalbum: item['musicalbum'],
//         musicid: item['musicid'].toString(),
//         musicsinger: item['musicsinger'],
//       ),
//     ));
//   }
//   content = new Column(
//     children: tiles,
//   );
//   return content;
// }
