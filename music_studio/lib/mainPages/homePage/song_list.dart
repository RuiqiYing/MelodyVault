import 'package:flutter/material.dart';
import 'package:music_studio/mainPages/homePage/song_list_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:music_studio/common/api.dart';

List rankFormlist = [];

class songList extends StatefulWidget {
  //songList({Key? key}) : super(key: key);

  @override
  State<songList> createState() => _songListState();
}

class _songListState extends State<songList> {
  getInfor() async {
    var url = Uri.parse(Api.url + '/api/music/rank/');
    var response = await http.post(
      url,
      headers: {"content-type": "application/json"},
    );
    var data = jsonDecode(Utf8Codec().decode(response.bodyBytes));
    rankFormlist = data["data"];
    // print(rankFormlist);
    listLength = rankFormlist.length;
    // print(rankFormlist[0]['musicname']);

    setState(() {});
  }

  @override
  void initState() {
    //初始化函数、带监听滑动功能
    super.initState();
    getInfor();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 5, 10.0, 0),
            constraints: BoxConstraints(
              maxHeight: 150,
              maxWidth: 150,
            ),
            child: Image.network('http://124.220.169.238:8000/media/img/0ee51f988635d262fe1d097f9671d3ff.jpeg',
                fit: BoxFit.cover),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => songListPage()));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Row(
                    children: [
                      Text(
                        '   热歌榜',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        '·每周更新',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )),
                  Container(
                      //margin: EdgeInsets.fromLTRB(20.0, 0, 0.0, 5.0),
                      child: ListView(
                    shrinkWrap: true,
                    itemExtent: 35,
                    padding: const EdgeInsets.all(10.0),
                    children: <Widget>[
                      Text('1.' +
                          rankFormlist[0]['musicname'] +
                          '-' +
                          rankFormlist[0]['musicsinger']),
                      Text('2.' +
                          rankFormlist[1]['musicname'] +
                          '-' +
                          rankFormlist[1]['musicsinger']),
                      Text('3.' +
                          rankFormlist[2]['musicname'] +
                          '-' +
                          rankFormlist[2]['musicsinger']),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
