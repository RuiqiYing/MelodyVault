import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_studio/mainPages/homePage/search_result.dart';

final TextEditingController searchController = new TextEditingController();

String word = searchController.text;

class searchMessage extends StatelessWidget {
  Widget buildTextField(BuildContext context) {
    return Theme(
        data: ThemeData(primaryColor: Colors.grey),
        child: Container(
          child:TextField(
            controller: searchController,
            cursorColor: Color.fromARGB(255, 176, 210, 176),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 176, 210, 176))),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 176, 210, 176))),
                disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 176, 210, 176))),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 176, 210, 176))),
                icon:
                SizedBox(width: 10,
                  child: IconButton(
                    
    padding: new EdgeInsets.fromLTRB(0, 0, 0, 0),
                  icon: Icon(Icons.search),
                  onPressed: () {
                    word = searchController.text;
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return SearchResultPage(word);
        }));
                  },
                ), ),
                  
                
                hintText: "搜索",
                hintStyle: new TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(50, 0, 0, 0),
                    fontWeight: FontWeight.w700)))
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(new Radius.circular(5.0))),
            alignment: Alignment.center,
            height: 20,
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: buildTextField(context)));
  }
}

