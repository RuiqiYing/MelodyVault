import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:music_studio/common/api.dart';


var _phone = new TextEditingController();
var _name = new TextEditingController();
var _password = new TextEditingController();
var _passwordsure = new TextEditingController();
var flag;

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("lib/assets/loginPage/login.jpg"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: 75.0,
            leading: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: TextButton(
                onPressed: () {//清除数据
                  _phone.clear();
                  _name.clear();
                  _password.clear();
                  _passwordsure.clear();
                  Navigator.pushNamed(context, '/login');
                },
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(color: Colors.white)),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
                child: Text("<返回",textAlign: TextAlign.center,),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text("注册"),
          ),
          body: SingleChildScrollView(
            child: Layout(),
          )),
    );
  }
}

class Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 100),
          Text(
            "注册新用户",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
              child: Theme(
                data: ThemeData(
                    primaryColor: Colors.white,
                    hintColor: Colors.white), //点击文本框时边框颜色 and 提示字颜色
                child: TextField(
                  controller: _phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11)
                  ], //只允许输入数字
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "手机号",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), //初始文本框为圆角边框
                      borderSide: BorderSide(
                          width: 2, color: Colors.white), //初始时文本框边框颜色
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)), //输入时文本框为圆角边框
                  ),
                ),
              )),
              Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
              child: Theme(
                data: ThemeData(
                    primaryColor: Colors.white,
                    hintColor: Colors.white), //点击文本框时边框颜色 and 提示字颜色
                child: TextField(
                  controller: _name,
                  // keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "用户名",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), //初始文本框为圆角边框
                      borderSide: BorderSide(
                          width: 2, color: Colors.white), //初始时文本框边框颜色
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)), //输入时文本框为圆角边框
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.white, hintColor: Colors.white),
              child: TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                controller: _password,
                decoration: InputDecoration(
                  labelText: "密码",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.white, hintColor: Colors.white),
              child: TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                controller: _passwordsure,
                decoration: InputDecoration(
                  labelText: "确认密码",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: InkWell(
              onTap: () {
                var phonenumber = _phone.text;
                var username = _name.text;
                var passwordnumber = _password.text;
                var passwordsurenumber = _passwordsure.text;
                // print(flag);
                if (passwordnumber == passwordsurenumber &&
                    passwordsurenumber.isNotEmpty &&
                    passwordnumber.isNotEmpty &&
                    phonenumber.isNotEmpty && username.isNotEmpty) {
                  _insert(username,phonenumber, passwordnumber, context);
                } else if (phonenumber.isEmpty)
                  Fluttertoast.showToast(msg: "请输入手机号!");
                  else if(username.isEmpty) Fluttertoast.showToast(msg: "请输入用户名!");
                else if (passwordnumber != passwordsurenumber)
                  Fluttertoast.showToast(msg: "密码不一致!");
                else if (passwordnumber.isEmpty)
                  Fluttertoast.showToast(msg: "请输入密码!");

              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  "注册",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

_insert(String username, String userid,String password, BuildContext context) async {
  var url = Api.url + '/api/user/';

try{
      FormData formData = FormData.fromMap({
        'username':username,
        'password':password,
        'userid':userid
      });
      var dio = Dio();
      var response = await dio.post(url,data: formData);
      print('Response: $response');
    Fluttertoast.showToast(msg: '注册成功!');
    _phone.clear();
    _name.clear();
    _password.clear();
    _passwordsure.clear();
    Navigator.pushNamed(context, '/login');
    }catch(e){
      print(e);
      return null;
    }

  // var url = Uri.parse(Api.url + '/api/user/');
  // String id = "100";
  // // var url_check = Uri.parse(Api.url + '/api/user/username=' + username);
  // // var response_check = await http.post(url_check);
  // // if (response_check.body == '1')
  // //   Fluttertoast.showToast(msg: '该手机号已注册！');
  // // else {
  //   var response = await http.post(url,
  //       headers: {"content-type": "application/x-www-form-urlencoded"},
  //       body: '{"username": "$username", "password": "' +
  //           Api.md5(password) +
  //           '","userid": "$id"}');
  //   print('Response body: ${response.body}');
  //   Fluttertoast.showToast(msg: '注册成功!');
  //   _phone.clear();
  //   _password.clear();
  //   _passwordsure.clear();
  //   Navigator.pushNamed(context, '/login');
  }
// }
