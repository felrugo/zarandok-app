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
  List<String> lyrics = []; // Soon to be removed
  String? youtubeSongUrl;
  String? youtubeKaraokeUrl;
  String? pdfUrl;

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
    youtubeKaraokeUrl = json["youtubeKaraoke"];
    youtubeSongUrl = json["youtubeSong"];
    pdfUrl = json["sheet"];
  }
}

class SongDatabase {

  static SongDatabase? _instance = null;

  List<SongData> _songs = [];
  List<String> assetRoutes = [];

  List<SongData> get songs {
    List<SongData> ret = [];
    for (var element in _songs) {
      ret.add(element);
    }
    return ret;
  }

  SongData get startOfBook {
    return _songs[0];
  }

  SongDatabase._(String bundleStr) {
    for(int i = 0; i < 232; i++)
    {
      assetRoutes.add("assets/zarandok_img_${i}.jpg");
    }

    var data = jsonDecode(bundleStr);
    for(var s in data)
    {
      _songs.add(SongData.fromJson(s));
    }

    _songs.sort((a, b) {
      return a.num.compareTo(b.num);
    });

  }

  SongData getPageDataByPage(int page)
  {
    var ret = _songs.first;
    for (var f in _songs) {
      if(f.page > page)
      {
        return ret;
      }
      else {
        ret = f;
      }
    }
    return ret;
  }

  static Future<SongDatabase> getInstance() async {
    if(_instance == null) {
      var bundleStr = await rootBundle.loadString("assets/bundle.json");
      _instance = SongDatabase._(bundleStr);
    }
    return Future.value(_instance);
  }

  static SongDatabase of(BuildContext context) {
    var provider = SongDatabaseProvider.of(context);
    return provider.database;
  }

}

ListTile buildSongListTile(SongData song, BuildContext context, VoidCallback onTap) {

  List<Widget> trailing = [];
  if(song.youtubeKaraokeUrl != null) {
    trailing.add(
        IconButton(iconSize:30.0, onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return YoutubeView(initialSong: song, initialMode: YoutubeViewMode.KaraokeMode,);
          }));
        }, icon: Icon(Icons.play_circle,))
    );
  }

  if(song.youtubeSongUrl != null) {
    trailing.add(
        IconButton(iconSize:30.0, onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return YoutubeView(initialSong: song, initialMode: YoutubeViewMode.SongMode,);
          }));
        }, icon: Icon(Icons.play_arrow_outlined,))
    );
  }

  trailing.add(
      IconButton(iconSize: 30.0, onPressed: () {
        var url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
        canLaunchUrlString(url).then((value) {
          if(value) {
            launchUrlString(url);
          }
        });
      }, icon: Icon(Icons.print))
  );

  return ListTile(
    title: Text(song.title),
    subtitle: Text("${song.num}. ének"),
    onTap: onTap,
    trailing: Row(mainAxisSize: MainAxisSize.min, children: trailing,
    ),
  );
}


class SongDatabaseProvider extends InheritedWidget {

  SongDatabase _database;

  SongDatabase get database {
    return _database;
  }

  SongDatabaseProvider(this._database, {required super.child});

  static SongDatabaseProvider? maybeOf(BuildContext context) {
    SongDatabaseProvider? ret = context.dependOnInheritedWidgetOfExactType<SongDatabaseProvider>();
    return ret;
  }

  static SongDatabaseProvider of(BuildContext context) {
    final SongDatabaseProvider? result = maybeOf(context);
    assert(result != null, 'No SongDatabaseProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
  
}