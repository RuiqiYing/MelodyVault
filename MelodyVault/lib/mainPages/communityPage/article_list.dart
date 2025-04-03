import 'package:flutter/material.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/mainPages/communityPage/post_card_part.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int listLength = 0;
List formlist = [];

class articleListPart extends StatefulWidget {
  //articleListPart({Key? key}) : super(key: key);

  @override
  State<articleListPart> createState() => _articleListPartState();
}

class _articleListPartState extends State<articleListPart> {
  List<Widget> widgetList = [];
  @override
  void initState() {
    //初始化函数、带监听滑动功能
    super.initState();
    getInfor();
  }

  getInfor() async {
    var url = Uri.parse(Api.url + '/api/article/all/');
    var response = await http.post(
      url,
      headers: {"content-type": "application/json"},
    );
    var data = jsonDecode(Utf8Codec().decode(response.bodyBytes));
    formlist=formlist = data["data"];
    print(formlist[0]['articleid']);
    listLength = formlist.length;
    setState(() {});
    // formlist.reversed;
    print(formlist.reversed);
    for (var item in formlist.reversed) {
      List<String> tmp = [];
      tmp.add('http://124.220.169.238:8000/media/' + item['articlepic1']);
      tmp.add('http://124.220.169.238:8000/media/' + item['articlepic2']);
      tmp.add('http://124.220.169.238:8000/media/' + item['articlepic3']);
      String time=item['articletime'].toString().substring(5,10)+' '+item['articletime'].toString().substring(11,16);
      widgetList.add(new postCardPage(
        userid_id:item['userid_id'].toString(),
        articletime: time,
        articlecontent: item['articlecontent'].toString(),
        articlelike: item['articlelike'],
        articlecomment: item['articlecomment'],
        username: item['articleuserdata']['username'],
        userimage: 'http://124.220.169.238:8000/media/'+item['articleuserdata']['userimage'],
        imageList: tmp,
        articleid: item['articleid'],
      ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: widgetList.length,
          itemBuilder: (BuildContext context, int index) {
            return widgetList[index];
          }),
    );
  }
}
