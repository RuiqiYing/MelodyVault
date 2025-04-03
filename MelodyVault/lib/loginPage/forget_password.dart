import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:music_studio/common/api.dart';

class ForgetPassword extends StatelessWidget {
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
          "修改密码",
          style: TextStyle(fontSize: 20.0),
        ),
        centerTitle: true,
        leadingWidth: 75.0,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: TextButton(
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(100, 20))),
              onPressed: () {
                passwordsureController.clear(); //在跳转其他页面时清空本页面已经填入的数据
                newpasswordController.clear();
                phonenumController.clear();
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                "<返回",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ),
      ),
      body: SingleChildScrollView(
        //防止页面溢出
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
            SizedBox(height: 100), //空盒子用于控制距离
            Row(
              mainAxisAlignment: MainAxisAlignment.center, //居中
              children: [
                Text(
                  "重设你的信息",
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
            SurePassword(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            ChangeButton(),
            SizedBox(height: 20),
          ],
        ));
  }
}

TextEditingController passwordsureController = new TextEditingController();
TextEditingController newpasswordController = new TextEditingController();
TextEditingController phonenumController = new TextEditingController();

//输入手机号
class InputNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: 300.0,
        alignment: Alignment.center,
        child: TextField(
          inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11)
                  ], //只允许输入数字
          keyboardType: TextInputType.number,
          controller: phonenumController,
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
          controller: newpasswordController,
          maxLines: 1,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 2, color: Colors.white)),
            labelText: '新密码',
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

//确认密码
class SurePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: 300.0,
        alignment: Alignment.center,
        child: TextField(
          controller: passwordsureController,
          maxLines: 1,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 2, color: Colors.white)),
            labelText: '确认密码',
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


//修改密码按钮
class ChangeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (phonenumController.text.length == 11 &&
            newpasswordController.text.isNotEmpty &&
            passwordsureController.text.isNotEmpty ) {
          if (newpasswordController.text != passwordsureController.text)
            Fluttertoast.showToast(msg: '两次输入的密码不一致！');
        } else {
          if (phonenumController.text.isEmpty)
            Fluttertoast.showToast(msg: '请输入手机号！');
          else if (phonenumController.text.length != 11)
            Fluttertoast.showToast(msg: '请输入正确的手机号！');
          else if (newpasswordController.text.isEmpty)
            Fluttertoast.showToast(msg: '请输入新密码！');
          else if (passwordsureController.text.isEmpty)
            Fluttertoast.showToast(msg: '请确认新密码！');
        }
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
            '修改密码',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          )),
    );
  }
}

// //更新密码函数
_update(String username, String password, BuildContext context) async {
  var url = Uri.parse(Api.url + '/user/check?username=' + username);
  var response = await http.post(url);
  print('Response body: ${response.body}');
  if (response.body == '1') {
    url = Uri.parse(Api.url + '/user/update');
    response = await http.post(url,
        headers: {"content-type": "application/json"},
        body: '{"username": "$username", "password": "' +
            Api.md5(password) +
            '"}');
    print('Response body: ${response.body}');
    Fluttertoast.showToast(msg: '修改成功!');
  } else
    Fluttertoast.showToast(msg: '用户名不存在!');
}
