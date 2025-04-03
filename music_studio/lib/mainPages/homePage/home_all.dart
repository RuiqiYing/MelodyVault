import 'package:flutter/material.dart';
import 'package:music_studio/mainPages/homePage/editorial_selection_part.dart';
import 'package:music_studio/mainPages/homePage/rotation_chart_part.dart';
import 'package:music_studio/mainPages/homePage/search_message_part.dart';
import 'package:music_studio/mainPages/homePage/song_list_part.dart';
import 'package:music_studio/mainPages/homePage/song_list_page.dart';
class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          '首页',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: homeAll(),
    );
  }
}

class homeAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(color: Colors.white),
        // child: rotationChart(),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverList(
              delegate: new SliverChildListDelegate(
                [
                  Container(
                    child: Column(
                      children: <Widget>[
                         SizedBox(
                          height: 20,
                        ),
                        searchMessage(),
                         SizedBox(
                          height:20,
                        ),
                        rotationChart(),
                        
                        SizedBox(
                          height: 20,
                        ),
                        editorialSelection(),
                        songList(),
                      ],
                    ),
                    alignment: Alignment.center,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
