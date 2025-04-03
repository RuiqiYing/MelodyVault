import 'package:flutter/material.dart';
import 'package:music_studio/mainPages/communityPage/article_list.dart';
import 'package:music_studio/mainPages/communityPage/post_pard_part.dart';
import 'package:music_studio/mainPages/homePage/search_message_part.dart';

import 'addPostPart.dart';

class communityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          '社区',
          style: TextStyle(color: Colors.black),
        ),
      ),
         body: Container(
           child:Column(
             children: [
               Expanded(child:  articleListPart(),),
              
             ],
           )
          ,
         ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(builder: (
              BuildContext context,
            ) {
              return new addPostCard();
            }));
          },
          child: IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (
                  BuildContext context,
                ) {
                  return new addPostCard();
                }));
              }),
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 180, 210, 250),
        ),
      ),
    );
  }
}
