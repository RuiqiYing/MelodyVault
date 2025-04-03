import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_studio/GetMusic.dart';
import 'package:music_studio/assets/myIcons.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/player_page.dart';

import 'editorialSelectionDetail.dart';

class SearchResultPage extends StatefulWidget {
  final String keyword;
  SearchResultPage(this.keyword, {Key key}) : super(key: key);
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List _songs = [];//搜索歌单
  List a = [];
  List searchSheet = [];//搜索歌曲
  initSongList() async {
    a.clear();
    if(_songs.isNotEmpty) {
      for (var item in _songs) {
      List temp = await GetMusic.getSongDetails(item['musicid'].toString());
      a.add(temp[0]);
    }
    }
    else{
      Fluttertoast.showToast(msg: "没有相关结果！");
    }
  }
  _getSongs(String keyword) async {
    var url = Api.url + '/api/search/';
    Map<String,dynamic> map = Map();
    map['search'] = keyword;
    var dio = Dio();
    await dio.get(url,queryParameters: map).then((result) {
      // 界面未加载，返回。
      if (!mounted) return;
      setState(() {
        _songs = result.data["data"];
        
      });
    }).catchError((e) {
      print('Failed: ${e.toString()}');
    });
    print(_songs);
    initSongList();
  }
    getSheet(String keyword) async{
      searchSheet.clear();
      var url = Api.url + '/api/search/playlist/';
      var urlImage = Api.url + '/media/';
      Map<String,dynamic> map = Map();
    map['search'] = keyword;
    var dio = Dio();
    var response = await dio.get(url,queryParameters: map);
    Map<String,dynamic> data = response.data;
          if (data['ret'] == 0) {
            for (int i = 0; i < data['data'].length; i++) {
          searchSheet.add({
            'name': data['data'][i]['playlistname'],
            'imageurl': urlImage +
                data['data'][i]['playlistimage'],
          });
        
      }
    // Fluttertoast.showToast(msg: '歌单搜索成功!');
     
      }


  }

  @override
  void initState() {
    super.initState();
    _getSongs(widget.keyword);
  }
      Widget _buildFuture (BuildContext context, AsyncSnapshot snapshot) {
    switch(snapshot.connectionState) {
      case ConnectionState.none:
      print("没有开始请求");
      return Text("尚未请求");
      case ConnectionState.active:
      return Text("ConnectionState.active");
      case ConnectionState.waiting:
      return Center(
        child: CircularProgressIndicator(),
      );
      case ConnectionState.done:
      print("done");
      if (snapshot.hasError)
      return  Text("error:${snapshot.error}");
      return _createListView(context, snapshot);
      default:
      return null;
    }
  }
    Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView(
        children: searchSheet.map((value) {
          return Container(
            height: 150,
            child: Card(
                // color: Colors.orange,
                child: GestureDetector(
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => songListDetail(
                            playlistname: value['name'],
                            playlistimage: value['imageurl'],
                          )));
              },
              // onLongPress:(){
              //   showMyAlertDialog(context,value['name']);
              // } ,
              child: Row(
                children: [
                  Expanded(
                    flex: 33,
                    child: Image.network(
                      value['imageurl'],
                    ),
                  ),
                  Expanded(
                    flex: 66,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Center(
                              child: Text(
                            value['name'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
          );
        }).toList(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child:Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey, 
              tabs: <Widget>[
                Tab(text: "歌曲"),
                Tab(text: "歌单"),
              ],),
          leading: IconButton(
            icon: new Icon(Icons.chevron_left, color: Colors.black, size: 30),
            onPressed: () {
              Navigator.of(context)..pop();
            },
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Text(
            widget.keyword,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: Container(
          color: Color(0xFFf4f4f4),
          child: buildResult(context),
        )),
        FutureBuilder(builder: _buildFuture,future: getSheet(widget.keyword),),
        ],)));
  }

  Widget buildResult(BuildContext context) {
    List<Widget> tiles = [];

    Widget content;
    int count = 0;
    for (var item in _songs) {
      count++;
      tiles.add(InkWell(
          onTap: () {
            print('我在这里');
            print(item['musicname'].toString());
            print('count:' + count.toString());
            PlayerPage.gotoPlayer(context, list: a, index: item['sub']);
          },
          child: SearchListItem(
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
}

class SearchListItem extends StatefulWidget {
  SearchListItem({
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
  int count;
  @override
  State<SearchListItem> createState() => _SearchListItemState();
}

class _SearchListItemState extends State<SearchListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(color: Colors.white),
      height: 60,
      child: Row(
        children: <Widget>[
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
          IconButton(
              color: widget.followMode == 1 ? Colors.red[700] : Colors.black,
              icon: widget.followMode == 1
                  ? Icon(MyIcons.followFont, size: 28)
                  : Icon(MyIcons.followFont),
              onPressed: () {
                showFollowDialog(context);
                print("click");
              })
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