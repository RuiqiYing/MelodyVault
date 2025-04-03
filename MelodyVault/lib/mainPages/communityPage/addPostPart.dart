import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_studio/mainPages/communityPage/add_comment_part.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:music_studio/common/api.dart';

String imagepicList;
dynamic test;
DateTime time;
List aList;
List<Widget> tiles;
// List pickPic=[];
String TEXT;
String myid='111';
List<String> imageUrl = [];
List<ImageSource> upImgFile=[];
Future _readShared() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  myid = preferences.get('id');
  print(myid);
}

class addPostCard extends StatefulWidget {
  //addPostCard({Key? key}) : super(key: key);

  @override
  State<addPostCard> createState() => _addPostCardState();
}

class _addPostCardState extends State<addPostCard> {
    List<String> tagTextList = [];
  List<Widget> tagCardList = [];
  List<Widget> imageList = [];
  String nowTag = "";
  File _image;
  String tmp = "1";
  
  @override
  void initState() {
    //初始化函数、带监听滑动功能
    super.initState();
    imageUrl.clear();
    _readShared();
  }
  Future choosePic(ImageSource source) async {
    // upImgFile.add(source);
    print(source);
    // print(upImgFile[0]);
    //参数类型为ImageSource
    //var image = await ImagePicker.pickImage(source: source); //过期方法暂时没有找到合适的替代方法
    ImagePicker imagePicker = ImagePicker();
    PickedFile image = await imagePicker.getImage(source: source);
    imageUrl.add(image.path);
    print(image.runtimeType.toString());
    //上传
    // var request = http.MultipartRequest(
    //     'POST', Uri.parse(Api.url + '/cs1902/post/uploadImage'));
    // request.files.add(await http.MultipartFile.fromPath('file', image.path));
    // http.StreamedResponse response = await request.send();
    // if (response.statusCode == 200) {
    //   tmp = await response.stream.bytesToString();
      print(tmp + "的imageurl");
      // if (tmp.length > 20) {
      //   Fluttertoast.showToast(
      //     msg: '添加图片成功',
      //     gravity: ToastGravity.BOTTOM,
      //   );
        setState(() {
          //将用户照片存储到_image
          _image = File(image.path);
          
          imageList.add(new Container(
              height: 50,
              width: 50,
              child: Image.file(_image),
              decoration: new BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2.0, 2.0), //阴影xy轴偏移量
                        blurRadius: 5.0, //阴影模糊程度
                        spreadRadius: 1.0 //阴影扩散程度
                        )
                  ],
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(150))));
          // imageUrl.add(tmp);
          print(tmp + "yesyesyes imageurl");
        });
      // } else {
      //   print("nonononononono imageurl");
      // }
    // } else {
    //   print(response.reasonPhrase);
    // }
  }
  addArticle(String now,String articlecontent,String  source1,String  source2,String source3) async {

 var url = Api.url + '/api/article/';
   print(source1);
   print(source2);
   print(source3);
       FormData formData = FormData.fromMap({
      "articletime": now,
      "articlecontent": articlecontent,
      "userid": myid,
      "articlepic1":await MultipartFile.fromFile(source1,filename: "upload"),
      "articlepic2":await MultipartFile.fromFile(source2,filename: "upload"),
      "articlepic3":await MultipartFile.fromFile(source3,filename: "upload"),
    });

    var dio = new Dio();
    var response = await dio.post(url, data:formData);
    String res = response.data.toString();
    // print('Response: $response');
    
   

    // var data = jsonDecode(Utf8Codec().decode(response.bodyBytes));
  
    setState(() {});
  }

  
  Widget build(BuildContext context) {
    getUID();
    return SizedBox(
        width: 450,
        height: 600,
        child: Container(
            width: 400,
            height: 500,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            child: SizedBox(
                width: 400,
                height: 300,
                child: Scaffold(
                    appBar: new AppBar(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      leading: IconButton(
                        icon: new Icon(Icons.chevron_left,
                            color: Colors.black, size: 30),
                        onPressed: () {
                          Navigator.of(context)..pop();
                        },
                      ),
                      centerTitle: true,
                      title: Text(
                        '发布动态',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        TextButton(
                          child:
                              Text("发布", style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            DateTime now = new DateTime.now();
                            // print(now);
                            // print('myid:'+myid);
                            // print(TEXT);
                            // IMGS.clear();
                            // for (int i = 0; i < imageUrl.length; ++i)
                            //   IMGS.add(imageUrl[i].toString());
                            addArticle(
                                now.toString().substring(0,19),TEXT,imageUrl[0],imageUrl[1],imageUrl[2]);
                            // setTag("");
                            // for (var i in imageUrl) {
                            //   print(i + "  im imageUrl");
                            // }
                            Navigator.pop(context);
                            // Navigator.of(context)
                            //     .push(MaterialPageRoute(builder: (context) {
                            //   return indexPage(now: 3);
                            // }
                            // ));
                            
                          },
                        )
                      ],
                    ),
                    resizeToAvoidBottomInset: false,
                    body: new Column(children: [
                     
                      SizedBox(height: 5),
                      Center(
                          child: SizedBox(
                              width: 330,
                              height: 120,
                              )),
                      SizedBox(height: 5),
                      SizedBox(
                          width: 330,
                          height: 200,
                          child: TextField(
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.blue,
                              cursorWidth: 5,
                              maxLines: 8,
                              decoration: InputDecoration(
                                  hintText: '请输入你想发布的内容...',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              onChanged: (a) {
                                TEXT = a;
                              })),
                      IconButton(
                          icon: Icon(Icons.photo),
                          iconSize: 80,
                          onPressed: () {
                            choosePic(ImageSource.gallery);
                          }),
                      Wrap(
                          spacing: 20, //主轴上子控件的间距
                          runSpacing: 5, //交叉轴上子控件之间的间距
                          children: imageList
                          )
                    ])))));
  }
}
