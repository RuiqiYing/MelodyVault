import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_studio/common/api.dart';
import 'package:music_studio/mainPages/homePage/rank_song_list.dart';
import 'package:music_studio/mainPages/homePage/song_list.dart';
import 'package:music_studio/mainPages/homePage/editorial_selection_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int listLength = 0;
List formlist = [];

class editorialSelection extends StatefulWidget {
  // editorialSelection({Key? key}) : super(key: key);

  @override
  _editorialSelectionState createState() => _editorialSelectionState();
}

class _editorialSelectionState extends State<editorialSelection> {
  List<Widget> widgetList = [];
  @override
  void initState() {
    //初始化函数、带监听滑动功能
    getInfor();
    super.initState();
    
  }

  getInfor() async {
    var url = Uri.parse(Api.url + '/api/playlist/rank/');
    var response = await http.post(
      url,
      headers: {"content-type": "application/json"},
    );
    var data = jsonDecode(Utf8Codec().decode(response.bodyBytes));
    setState(() {
            formlist = data["data"];
             listLength = formlist.length;
        });
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(children: [
              Expanded(
                  child: Text(
                '   下一秒，与你的宝藏相遇',
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
            ])),
        Container(
          width: 500,
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              recommendItem(
                playlistname: formlist[0]['playlistname'],
                playlistimage: 'http://124.220.169.238:8000/media/' +
                    formlist[0]['playlistimage'],
                id: formlist[0]['id'].toString(),
              ),
              recommendItem(
                playlistname: formlist[1]['playlistname'],
                playlistimage: 'http://124.220.169.238:8000/media/' +
                    formlist[1]['playlistimage'],
                id: formlist[1]['id'].toString(),
              ),
              recommendItem(
                playlistname: formlist[2]['playlistname'],
                playlistimage: 'http://124.220.169.238:8000/media/' +
                    formlist[2]['playlistimage'],
                id: formlist[2]['id'].toString(),
              ),
              recommendItem(
                playlistname: formlist[3]['playlistname'],
                playlistimage: 'http://124.220.169.238:8000/media/' +
                    formlist[3]['playlistimage'],
                id: formlist[3]['id'].toString(),
              ),
            
            ],
          ),
        ),
      ],
    ));
  }
}

class recommendItem extends StatelessWidget {
  const recommendItem(
      {Key key,
      this.songListId,
      this.playlistname,
      this.playlistimage,
      this.id})
      : super(key: key);
  final String playlistname;
  final String songListId;
  final String playlistimage;
  final String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => songListDetail(
                      playlistname: playlistname,
                      playlistimage: playlistimage,
                    )));
      },
      child: Container(
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 5, 10.0, 0),
            constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
            child: Image.network(playlistimage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity),
          ),
          SizedBox(
            width: 10,
            height: 10,
          ),
          SizedBox(
            height: 65,
            child:Text(playlistname) ,)
          
        ]),
      ),
    );
  }
}