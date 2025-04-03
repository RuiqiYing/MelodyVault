import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_studio/bottom.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/loginPage/login.dart';
import 'package:music_studio/mainPages/homePage/editorial_selection_detail.dart';
import 'package:music_studio/widgets/rename_dialog_content.dart';

import 'mineAll.dart';

class MySongSheet extends StatefulWidget {
  @override
  State<MySongSheet> createState() => _MySongSheetState();
}

class _MySongSheetState extends State<MySongSheet> {
  TextEditingController sheetname = TextEditingController();
  @override
  void initState() {
    super.initState();
    // print(listData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_circle,color: Colors.black),
              onPressed: () {
                    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return RenameDialog(
            contentWidget: RenameDialogContent(
              title: "请输入歌单名称",
              okBtnTap: () {
                createSheet(mineid, sheetname.text);
              },
              vc: sheetname,
              cancelBtnTap: () {},
            ),
          );
        });
              }),
        ],
        automaticallyImplyLeading: false, //隐藏返回按钮
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        elevation: 0, //将向导栏的阴影设为0，确保全透明
        backgroundColor: Colors.transparent, //将向导栏设为透明颜色
        title: Text(
          "我的歌单",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black54,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getData(mineid),
        builder: _buildFuture,)
    );
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
        children: listData.map((value) {
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
              onLongPress:(){
                showMyAlertDialog(context,value['name']);
              } ,
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
  
  removeSheet(String userid,String sheetname) async{
    var url = Api.url + '/api/playlist/del/';
    try{
      Map<String, dynamic> map = Map();
      map['userid'] = userid;
      map['playlistname'] = sheetname;
      
      var dio = Dio();
      var response = await dio.delete(url,data: map);
      print('Response: $response');
    Fluttertoast.showToast(msg: '删除成功!');
          setState(() {
          print("刷新页面！");
          print(listData);
        });

        
    }catch(e){
      print(e);
      return null;
    }
  }
  createSheet(String userid,String sheetname) async{
    var url = Api.url + '/api/playlist/creat/';
    try{
      FormData formData = FormData.fromMap({
        'userid':userid,
        'playlistname':sheetname,
      });
      var dio = Dio();
      var response = await dio.post(url,data: formData);
      print('Response: $response');
    Fluttertoast.showToast(msg: '创建成功!');
          setState(() {
          print("刷新页面！");
          print(listData);
        });

        
    }catch(e){
      print(e);
      return null;
    }

  }
    void showMyAlertDialog(BuildContext context,String sheet) {
//设置按钮
  Widget okButton = FlatButton(
    child: Text("确定"),
      onPressed: () {
        if(sheet == "默认歌单") {
          Fluttertoast.showToast(msg: "无法删除此歌单！");

        }
        else {
          removeSheet(mineid, sheet);
        }
        
        Navigator.pop(context);
      },
  );
  Widget cancelButton = FlatButton(
    child: Text("取消"),
    onPressed: () { 
      Navigator.pop(context);
    },
  );
 
  //设置对话框
  AlertDialog alert = AlertDialog(
    title: Text("确定删除这个歌单吗？"),
    actions: [
      okButton,
      cancelButton
    ],
  );
 
  //显示对话框
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  }
  
}
