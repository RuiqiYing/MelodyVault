import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/loginPage/login.dart';
import 'package:music_studio/mainPages/communityPage/user_article.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController usernameController = TextEditingController();
TextEditingController infoController = TextEditingController();
String userhead =
    "http://img.chinau.com.cn/attachment//stampNew/20190424/2019042417080487564_t4.jpg";

String myname = '';
String myInfo = '暂无个人简介';

List history = [
  //音乐足迹
];
List collect = [
  //我收藏的歌单
];

class minePage extends StatefulWidget {
  const minePage({
    Key key,
  }) : super(key: key);

  _minePageState createState() => _minePageState();
}

class _minePageState extends State<minePage> {
  _minePageState();

  final double _appBarHeight = 120.0;
  final String _userHead = userhead;
  @override
  void initState() {
    super.initState();
    // getData(myid);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        appBar: AppBar(
          
          //AppBar下端黑线
          bottom: PreferredSize(
              child: Container(
                color: Colors.black38,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0, //将向导栏的阴影设为0，确保全透明
          backgroundColor: Colors.transparent, //将向导栏设为透明颜色
          title: Text(
            "我的",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
            ),
          ),
        ),
        body: FutureBuilder(
          future: getData(mineid),
          builder: _buildFuture,
        ));
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
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
        if (snapshot.hasError) return Text("error:${snapshot.error}");
        return _buildBody(context, snapshot);
      default:
        return null;
    }
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot snapshot) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          expandedHeight: _appBarHeight,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    print("已点击");
                    Navigator.pushNamed(context, '/modify');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 13,
                          ),
                          child: CircleAvatar(
                            radius: 35.0,
                            backgroundImage: NetworkImage(_userHead),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              // child: InkWell(
                              child: Text(
                                myname,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              //   onTap: () {
                              //     print("已点击");
                              //     Navigator.pushNamed(context, '/infor',
                              //         arguments: {
                              //           'username': arguments['username'],
                              //           'userHead': _userHead
                              //         });
                              //   },
                              // )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 0,
                              ),
                              child: Text(
                                myInfo,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 120),
                  child: Divider(
                    color: Colors.black12,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black26,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          MenuItem(
                            title: '我的收藏',
                            onPressed: () {
                              //路由跳转
                              Navigator.pushNamed(context, '/my_collect');
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(
                              color: Colors.black12,
                            ),
                          ),
                          MenuItem(
                            title: '我的歌单',
                            onPressed: () {
                              //路由跳转
                              Navigator.pushNamed(context, '/my_songsheet');
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black26,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          MenuItem(
                            title: '音乐足迹',
                            onPressed: () {
                              Navigator.pushNamed(context, '/history');
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(
                              color: Colors.black12,
                            ),
                          ),
                          MenuItem(
                            title: '我的帖子',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserArticlePage(
                                            userName: myname,
                                            userid: mineid,
                                            userImage: userhead,
                                          )));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ContactItem extends StatelessWidget {
  ContactItem({Key key, this.icon, this.title, this.onPressed})
      : super(key: key);
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 4.0,
            ),
            child: Icon(icon),
          ),
          Text(title,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.0,
                  letterSpacing: -1,
                  wordSpacing: -1)),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  MenuItem({Key key, this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                top: 12.0,
                right: 20.0,
                bottom: 10.0,
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                        letterSpacing: -1,
                        wordSpacing: -1),
                  )),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )
                ],
              )),
        ],
      ),
    );
  }
}

getData(String userid) async {
  listData = [];
  collect = [];
  var url = Api.url + '/api/user/';
  var urlImage = Api.url + '/media/';
  try {
    Map<String, dynamic> map = Map();
    map['userid'] = userid;
    var dio = Dio();
    var response = await dio.get(url, queryParameters: map);
    print('Response: $response');
    Map<String, dynamic> data = response.data;
    print(data['data']);
    print(data['data'][0]['username']);
    // print(data['data'][0]['usercreatedata'].length);
    if (data['ret'] == 0) {
      if (data['data'][0]['userimage'] != "null") {
        userhead = urlImage + data['data'][0]['userimage'];
      }
      print(userhead);
      myname = data['data'][0]['username'];
      myInfo = data['data'][0]['briefintroduction'];
      usernameController.text = myname;
      infoController.text = myInfo;
      for (int i = 0; i < data['data'][0]['usercreatedata'].length; i++) {
        if (i == 0) {
          listData.add({
            'name': "默认歌单",
            'imageurl': urlImage +
                data['data'][0]['usercreatedata'][i]['playlistimage'],
          });
        } else {
          listData.add({
            'name': data['data'][0]['usercreatedata'][i]['playlistname'],
            'imageurl': urlImage +
                data['data'][0]['usercreatedata'][i]['playlistimage'],
          });
        }
      }
      for (int i = 0; i < data['data'][0]['usercollectdata'].length; i++) {
        if (i == 0) {
          collect.add({
            'name': "默认收藏歌单",
            'imageurl': urlImage +
                data['data'][0]['usercollectdata'][i]['playlistimage'],
          });
        } else {
          collect.add({
            'name': data['data'][0]['usercollectdata'][i]['playlistname'],
            'imageurl': urlImage +
                data['data'][0]['usercollectdata'][i]['playlistimage'],
          });
        }
      }
      // print("listdata:$listData");

      print('获取歌单成功!');
    } else {
      print('获取歌单失败！');
    }
  } catch (e) {
    print(e);
    return null;
  }
}

getHistory(String userid) async {
  history = [];
  var url = Api.url + '/api/history/';
  // var urlImage = Api.url + '/media';
  try {
    Map<String, dynamic> map = Map();
    map['userid'] = userid;
    var dio = Dio();
    var response = await dio.get(url, queryParameters: map);
    print('Response: $response');
    Map<String, dynamic> data = response.data;
    print(data['data']);
    print(data['data'].length);
    if (data['ret'] == 0) {
      for (int i = 0; i <= data['data'].length - 1; i++) {
        history.add({
          'listentime': data['data'][i]['listentime'].substring(0, 10) +
              " " +
              data['data'][i]['listentime'].substring(11, 19),
          'perception': data['data'][i]['perception'],
          'musicname': data['data'][i]['musicname'],
        });
      }
      print("history:$history");

      print("获取历史记录成功！");
    } else {
      print("获取历史记录失败！");
    }
  } catch (e) {
    print(e);
    return null;
  }
}
