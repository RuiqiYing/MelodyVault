import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class commentUserCard extends StatelessWidget {
  commentUserCard({Key key, this.text, this.time, this.touxiang, this.username})
      : super(key: key);

  String text;
  String time;
  String touxiang;
  String username;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
            alignment: Alignment.center,
            height: 180,
            color: Colors.white,
            child: Scaffold(
                appBar: new AppBar(
                  elevation: 6.0,
                  shape: ContinuousRectangleBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      // bottomLeft: Radius.circular(30.0),
                      // bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  // backgroundColor: Color.fromARGB(255, 146, 180, 146),
                  backgroundColor: Color.fromARGB(255, 240, 240, 240),
                  leading: InkWell(
                      child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(touxiang),
                          // AssetImage("lib/assets/rotationChart/rotation1.jpg"),
                          child: Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              // width: 150,
                              height: 150)),
                      onTap: () {
                        // Navigator.push(context, new MaterialPageRoute(
                        //     builder: (BuildContext context) {
                        //   return new personInformationPage(id: uid);
                        // }));
                      }),
                  title: IntrinsicWidth(
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                        Text(username,
                            style: TextStyle(
                                color: Color(0xFF111111),
                                decorationStyle: TextDecorationStyle.double,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                textBaseline: TextBaseline.alphabetic,
                                fontSize: 13,
                                letterSpacing: 2,
                                wordSpacing: 10,
                                height: 1.5),
                            textAlign: TextAlign.start),
                      ])),
                ),
                body: Container(
                    padding: EdgeInsets.only(left: 10, top: 20, right: 10),
                    child: new Column(children: [
                      Text(text,
                          style: TextStyle(
                              color: Color(0xFF111111),
                              decorationStyle: TextDecorationStyle.double,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              textBaseline: TextBaseline.alphabetic,
                              fontSize: 13,
                              letterSpacing: 2,
                              wordSpacing: 10,
                              height: 1.2),
                          softWrap: true,
                          maxLines: 7,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: 10)
                    ])),
                bottomNavigationBar: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(time, style: TextStyle(fontSize: 10))))));
  }
}
