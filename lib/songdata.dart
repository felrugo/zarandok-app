import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zarandok_app_2/youtube_view.dart';
/// Model class contains information for a song.
class SongData
{

  String title = "";
  int num = 0;
  int page = 0;
  List<String> lyrics = [];

  /// From JSON constructor
  SongData.fromJson(Map<String, dynamic> json)
  {
    this.title = json["title"];
    this.num = json["num"];
    this.page = json["page"];
    this.lyrics = [];
    if(json["lyrics"] is List<dynamic>)
      {
        List<dynamic> l = json["lyrics"];
        l.forEach((e){
          if(e is String)
            {
              lyrics.add(e as String);
            }
        });
      }
  }
}

class SongDatabase {

  static SongDatabase? _instance = null;

  List<SongData> songs = [];
  List<String> assetRoutes = [];

  SongDatabase._() {
    for(int i = 0; i < 232; i++)
    {
      assetRoutes.add("assets/zarandok_img_${i}.jpg");
    }

    rootBundle.loadString("assets/bundle.json").then((v){
      var data = jsonDecode(v);
      for(var s in data)
      {
        songs.add(SongData.fromJson(s));
      }
    });
  }

  SongData getPageDataByPage(int page)
  {
    SongData ret = songs.first;
    for (var f in songs) {
      if(f.page == page)
      {
        ret = f;
      }
    }
    return ret;
  }

  static SongDatabase getInstance() {
    if(_instance == null) {
      _instance = SongDatabase._();
    }
    return _instance!;
  }

}

ListTile buildSongListTile(SongData song, BuildContext context, VoidCallback onTap) {
  return ListTile(
    title: Text(song.title),
    subtitle: Text("${song.num}. ének"),
    onTap: onTap,
    trailing: Row(children: [
      IconButton(onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return YoutubeView();
        }));
      }, icon: Icon(Icons.play_circle)),
      IconButton(onPressed: () {
        var url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
        canLaunchUrlString(url).then((value) {
          if(value) {
            launchUrlString(url);
          }
        });
      }, icon: Icon(Icons.print)),
    ],
      mainAxisSize: MainAxisSize.min,
    ),
  );
}