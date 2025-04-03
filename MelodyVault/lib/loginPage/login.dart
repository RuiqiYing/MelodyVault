import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:music_studio/GetMusic.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/mainPages/minePage/mine_all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_studio/main.dart';

final TextEditingController phoneNumberController = new TextEditingController();
final TextEditingController passwordController = new TextEditingController();
String mineid;
List listData = [
  //我的歌单
];
setUserName(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('id', id);
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyScaff(),
      decoration: BoxDecoration(
        //设置背景图
        image: DecorationImage(
          image: AssetImage("lib/assets/loginPage/login.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class MyScaff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        
        //设置向导栏，包括登录和返回字样
        elevation: 0, //将向导栏的阴影设为0，确保全透明
        backgroundColor: Colors.transparent, //将向导栏设为透明颜色
        title: Text(
          "登录",
          style: TextStyle(fontSize: 20.0),
        ),
        centerTitle: true,
        // leadingWidth: 75.0,
        // leading: Padding(
        //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        //   child: Text(
        //     "<返回",
        //     textAlign: TextAlign.center,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: MyText(),
      ),
    );
  }
}

//设置字样
class MyText extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center, //容器居中
        child: Column(
          children: [
            //用children同时表示多个字样
            SizedBox(height: 120), //空盒子用于控制距离
            Row(
              mainAxisAlignment: MainAxisAlignment.center, //居中
              children: [
                Text(
                  "欢迎来到Music Studio",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            InputNumber(),
            SizedBox(
              height: 20,
            ),
            InputPassword(),
            SizedBox(
              height: 20,
            ),
            LoginButton(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, //将3个盒子合理规划位置
              children: [
                TextButton(
                    onPressed: () {
                      phoneNumberController.clear();
                      passwordController.clear();
                      Navigator.pushNamed(context, '/forget_password');
                    },
                    child: Text(
                      "忘记密码",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    )),
                Text(
                  "|",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      phoneNumberController.clear();
                      passwordController.clear();
                      Navigator.pushNamed(context, '/sign_up');
                    },
                    child: Text(
                      "注册新用户",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}

//输入手机号
class InputNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: 300.0, //控制容器的宽度

        alignment: Alignment.center,
        child: TextField(
          // ignore: deprecated_member_use
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          controller: phoneNumberController,
          //文本域定义，最大显示一行
          maxLines: 1,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 2, color: Colors.white)),
            labelText: '手机号',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

//输入密码
class InputPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: 300.0,
        alignment: Alignment.center,
        child: TextField(
          controller: passwordController,
          maxLines: 1,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 2, color: Colors.white)),
            labelText: '密码',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
          style: TextStyle(color: Colors.white),
          obscureText: true,
        ),
      ),
    );
  }
}

//登录按钮
class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String username = phoneNumberController.text;
        String password = passwordController.text;
        print('点击了登录！');
        print('用户名：' + phoneNumberController.text);
        print('密码：' + passwordController.text);
        // Navigator.pushNamed(context, '/bottom');
        _login(username, password, context);
      },
      child: Container(
          width: 300.0,
          padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.green,
          ),
          alignment: Alignment.center,
          child: Text(
            '登录',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          )),
    );
  }
}

_login(String username, String password, BuildContext context) async {
  //json
  // var url = Uri.parse(Api.url + '/api/sign/');
  // var response = await http.post(url,
  //     headers: {"content-type": "application/json"},
  //     body: '{"username": "$username", "password": "' +
  //         Api.md5(password) +
  //         '"}');
  // int id = jsonDecode(response.body)["id"];
  // print("iiiiiiiiiiiiiiiiiiiiiddddddddddddddddddd");
  // print(id);
  // print('Response body: ${response.body}');
    var url = Api.url + '/api/sign/';
try{
     Map<String,dynamic> map = Map();
     map['userid'] = username;
     map['password'] = password;
      var dio = Dio();
      var response = await dio.get(url,queryParameters: map).timeout(Duration(seconds: 3));
      print('Response: $response');
      Map<String,dynamic> data = response.data;
      print(data['ret']);
      if (data['ret'] == 0) {
    Fluttertoast.showToast(msg: '登录成功!');
     setUserName(username);
     String myid="111";
     SharedPreferences preferences = await SharedPreferences.getInstance();
     myid = preferences.get('id');
     mineid = myid;
     getData(myid);
     print("listdata:$listData");
    //  if(listData[0])
    Navigator.pushNamed(context, '/bottom');
    // Navigator.pushNamed(context, '/bottom',
    //     arguments: {'username': username, 'password': password});
      }
      else{
        Fluttertoast.showToast(msg: '用户名或密码错误!');
      }
    }catch(e){
      print(e);
      return null;
    }
  // if (response.body != '') {
  //   Navigator.pushNamed(context, '/main',
  //       arguments: {'username': username, 'password': password});

  //   setUserName(id ,username);
  // } else
  //   Fluttertoast.showToast(msg: '用户名或密码错误');
}

// _postParam() async {
//   //Param
//   var url = Uri.parse('/user/param?s=123');
//   var response = await http.post(url);
//   print('Response body: ${response.body}');
// }

// _postData() async {
//   //x-www-form-urlencoded
//   var url = Uri.parse('http://jd.itying.com/api/httpPost');
//   var response = await http.post(url, body: {"username": "张三", "age": "20"});
//   print('Response status: ${response.statusCode}');
//   print('Response body: ${response.body}');
//   print(response.body is String);
//   print(json.decode(response.body)['msg']);
// }
