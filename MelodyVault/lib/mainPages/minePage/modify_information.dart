import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_studio/bottom.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/loginPage/login.dart';

import 'mineAll.dart';

class ModifyInformation extends StatefulWidget {
  @override
  State<ModifyInformation> createState() => _ModifyInformationState();
}

class _ModifyInformationState extends State<ModifyInformation> {

  final ImagePicker picker = new ImagePicker();
  var _imagePath;
  // File image;
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
      appBar: AppBar(
        automaticallyImplyLeading: false, //隐藏返回按钮
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: (){
            Navigator.of(context).pop();

            },
        ),
        title: Text(
          "修改个人信息",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black54,
          ),
        ),
        centerTitle: true,
        elevation: 0, //将向导栏的阴影设为0，确保全透明
        backgroundColor: Colors.transparent, //将向导栏设为透明颜色
      ),
      body: Container(
        // color: Colors.white,
        margin: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("用户名"),
                Container(
                  width: 250,             
                  child: TextField( 
                    controller: usernameController,
                    maxLines: 1,
                    maxLength: 8,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(width: 2, color: Colors.black)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      labelText: '请输入用户名',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("个人简介"),
                Container(
                  width: 250,
                  child: TextField(
                    maxLines: 3,
                    minLines: 1,
                    maxLength: 50,
                    controller: infoController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(width: 2, color: Colors.black)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      labelText: '请输入简介',
                    ),
                  ),
                ),
              ],
            ),
            _imageView(_imagePath),
            MaterialButton(
              child: Text("点击修改头像"),
              textColor: Colors.white,
              color: Colors.red,
              onPressed: (){
                _openGallery();
              }),
              MaterialButton(
              child: Text("确认修改"),
              textColor: Colors.white,
              color: Colors.red,
              onPressed: (){
                print(_imagePath);
                print(_imagePath.runtimeType.toString());
                _modify_Info(mineid, usernameController.text, infoController.text, _imagePath.toString());
                
              }),
              
          ],
        ),
      ),
    );
    
  }
  _openGallery() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    // var image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = File(image.path);
      print(_imagePath);
    });
  }
  
  _modify_Info(String userid,String username,String introduce,String userhead) async {
  var url = Api.url + "/api/user/";
    print("firstpath:$userhead");
    String path = userhead.substring(7);
    String path1 = path.substring(0, path.length - 1);
    print("nextpath:$path1");
try {
    FormData formData = FormData.fromMap({
        'userimage':await MultipartFile.fromFile(path1, filename: "23.jpg"),
        'username':username,
        'password':"",
        'information':"",
        'introduce':introduce,
        'userid':userid
      });
      var dio = Dio();
      var response = await dio.post(url,data: formData);
      // print("formData:"$formData);
      print('Response: $response');
    Map<String, dynamic> data = response.data;
    if (data['ret'] == 0) {
      print("修改成功！");
      Navigator.pushNamed(context, '/bottom');
      Fluttertoast.showToast(msg: "修改成功！");
    } else {
      print("修改失败！");
    }
  } catch (e) {
    print(e);
    return null;
  }
}
}
  Widget _imageView(imgPath) {
    if (imgPath == null) {
      return Center(
        child: Text("请选择图片"),
      );
    } else {
      return Container(
        width: 300.0,
        height: 300.0,
          child: ClipOval(child: Image.file(
            
        imgPath,
        fit: BoxFit.cover,
      ),),
      );
    }
  }


