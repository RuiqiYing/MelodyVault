import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'model/Lyric.dart';
import 'utils/file_util.dart';
import 'utils/http_util.dart';


class GetMusic {
  static const URL_ROOT = 'https://musicstudio-music-api.vercel.app/';
  static const URL_TOP_SONGS = '$URL_ROOT/playlist/detail?id=';
  static const URL_SONG_DETAIL = '$URL_ROOT/song/detail?ids=';
  static const URL_GET_LYRIC = '$URL_ROOT/lyric?id=';
  static const URL_SEARCH = '$URL_ROOT/search?keywords=';
  static const URL_GET_TOPLIST =
      '$URL_ROOT/toplist/detail'; // 获取排行和摘要，或者/toplist

  static const URL_TOP_ARTISTS = '$URL_ROOT/toplist/artist';
  static const URL_ARTIST_DETAIL = '$URL_ROOT/artists?id=';

  static Future<List> search(String keywords) async {
    var data =
        await HttpUtil.getJsonData('$URL_SEARCH$keywords', useCache: false);
    List songList = data['result']['songs'];
    return songList;
  }
    // 获取歌词
  static Future<Lyric> getLyric(int songId) async {
    File cache = File(await FileUtil.getLyricLocalPath(songId));
    Map data;
    try {
      bool isCached = cache.existsSync();
      if (isCached) {
        // 歌词缓存过
        String strCached = await cache.readAsString();
        //print('get lyric from cache: $strCached');
        if (strCached.isNotEmpty) {
          data = jsonDecode(strCached);
        } else {
          cache.delete();
        }
      } 
      
      if(data == null) {
        String url = '$URL_GET_LYRIC$songId';
        data = await HttpUtil.getJsonData(url, checkCacheTimeout: false);
      } 
      
      if (data.containsKey('nolyric')) {
        // 无歌词
        return Lyric.empty();
      }
      String str = data['lrc']['lyric'];
      return Lyric(str);
    } catch (e) {
      print('$e');
      return null;
    }
  }
    static Future<List> getSongDetails(String ids) async {  //获取歌曲详细信息
    var data =
        await HttpUtil.getJsonData('$URL_SONG_DETAIL$ids', useCache: false);
    List songList = data['songs'];
    return songList;
  }
  static Future<Map> getSongDetail(String id) async {
    List songList = await getSongDetails(id);
    Map song;
    if (songList.length > 0) {
      song = songList[0];
    }
    return song;
  }
    static Future<List> getTopSongs(int listId) async {
    print('$URL_TOP_SONGS$listId');
    var data = await HttpUtil.getJsonData('$URL_TOP_SONGS$listId');
    List songList = data['playlist']['tracks'];
    return songList;
  }
    static Future<List> getArtistList() async {
      print(URL_TOP_ARTISTS);
    var data = await HttpUtil.getJsonData(URL_TOP_ARTISTS);
    print(data);
    List songList = data['list']['artists'];
    
    
    return songList;
  }
    static Future<Map> getArtistDetail(int id) async {
    Map detail = await HttpUtil.getJsonData('$URL_ARTIST_DETAIL$id');
    Map artist = detail['artist'];
    Map content = {
      'id': artist['id'],
      'name': artist['name'],
      'desc': artist['briefDesc'],
      'image': artist['picUrl'],
      'songs': detail['hotSongs'],
    };
    return content;
  }
}