import 'package:flutter/material.dart';
import 'package:music_studio/bottom.dart';
import 'package:music_studio/loginPage/forget_password.dart';
import 'package:music_studio/loginPage/sign_up.dart';
import 'package:music_studio/mainPages/minePage/footstep.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPage/sign_up.dart';
import 'loginPage/login.dart';
import 'mainPages/communityPage/community_all.dart';
import 'mainPages/homePage/home_all.dart';
import 'mainPages/minePage/mine_all.dart';
import 'mainPages/minePage/modify_information.dart';
import 'mainPages/minePage/my_collect.dart';
import 'mainPages/minePage/my_song_sheet.dart';
import 'model/music_controller.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
    runApp(_buildProvider());
  
}

class SpUtil {
  static SharedPreferences prefs;
  static Future<bool> getUserName() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(),
      routes: {
        // '/': (BuildContext context) => HomePage(),
        // '/image': (context) => ImageSelector(),
      },
    );
  }
}
_buildProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<MusicController>.value(value: MusicController()),
    ],
    child: Router(),
  );
}
class Router extends StatelessWidget {
  final routes = {
   '/login': (context) => Login(),
    '/home': (context) => homePage(),
    '/community': (context) => communityPage(),
    '/mine': (context) =>minePage(),
    '/bottom':(context) => Bottom(),
    '/sign_up':(context) => SignUp(),
    '/forget_password':(context) => ForgetPassword(),
    '/my_collect':(context) => MyCollect(),
    '/my_songsheet':(context) => MySongSheet(),
    '/modify':(context) => ModifyInformation(),
    '/history':(context) => Footstep(),
    

  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      // initialRoute: '/bottom',

      //routes: routes,
      onGenerateRoute: (RouteSettings settings) {
        //统一处理
        final String name = settings.name;
        final Function pageContentBuilder = this.routes[name];
        if (pageContentBuilder != null) {
          if (settings.arguments != null) {
            final Route route = MaterialPageRoute(
                builder: (context) =>
                    pageContentBuilder(context, arguments: settings.arguments));
            return route;
          } else {
            final Route route = MaterialPageRoute(
                builder: (context) => pageContentBuilder(context));
            return route;
          }
        }
        return null;
      },);
  }
  }

