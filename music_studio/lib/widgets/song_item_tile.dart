import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_studio/player_page.dart';
import 'package:music_studio/utils/song_util.dart';

//歌单内容用这个组件

class SongItemTile extends StatelessWidget {
  final List songList;
  final int index;
  final Function onItemTap;
  const SongItemTile(this.songList, this.index, {Key key, this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map song = this.songList[index];
    String image = SongUtil.getSongImage(song);
    return Container(
        decoration: BoxDecoration(
          color: Color(0x08ffffff),
          /* border: Border(
            bottom: BorderSide(
                color: Color(0x11000000), width: 0.5, style: BorderStyle.solid),
          ), */
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: image.isEmpty
                ? Image.asset('assets/loginPage/login.jpg', fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) =>
                        Image.asset('assets/loginPage/login.jpg', fit: BoxFit.cover)),
          ),
          title: new Text(
            "${song['name']}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14.0),
          ),
          subtitle: new Text(
            SongUtil.getArtistNames(song),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.0),
          ),
          onTap: () {
            if (onItemTap != null) {
              this.onItemTap();
            }
            print('跳转至音乐播放界面');
            print(songList);
            // PlayerPage.gotoPlayer(context, list: songList, index: index);
            PlayerPage.gotoPlayer(context, list: songList, index: index);  //跳转到音乐播放界面
          },
        ));
  }
}