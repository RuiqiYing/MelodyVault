import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_studio/loginPage/login.dart';
import 'package:music_studio/mainPages/minePage/mine_all.dart';

class Footstep extends StatefulWidget {
  const Footstep({
    Key key,
  }) : super(key: key);

  _FootstepState createState() => _FootstepState();
}

class _FootstepState extends State<Footstep> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false, //隐藏返回按钮
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          elevation: 0, //将向导栏的阴影设为0，确保全透明
          backgroundColor: Colors.transparent, //将向导栏设为透明颜色
          title: Text(
            "音乐足迹",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
            ),
          ),
        ),
        body: FutureBuilder(
          future: getHistory(mineid),
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
        return _createListView(context, snapshot);
      default:
        return null;
    }
  }

  Widget _createListView(BuildContext context, AsyncSnapshot snapshot) {
    if (history.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "暂时没有音乐足迹!",
                style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,),
              ),
            ],
          )
        ],
      );
    } else {
      return ListView(
        children: history.map((value) {
          return Container(
            margin: EdgeInsets.all(10),
            decoration: new BoxDecoration(
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              //设置四周边框
              border: new Border.all(width: 1, color: Colors.grey),
            ),
            height: 100,
            child: GestureDetector(
              onDoubleTap: () => showSnackBar(value['perception']),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(value['listentime']),
                  Text(value['musicname']),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }
  }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showSnackBar(String message) {
    var snackBar = SnackBar(
        content: Text(message),
        backgroundColor: Colors.lightGreen,
        duration: Duration(milliseconds: 1000));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
