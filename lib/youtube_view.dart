// Copyright(c) Szabó Bálint 2023-2024
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:zarandok_app_2/songdata.dart';
import 'package:zarandok_app_2/zarandokyoutubescaffold.dart';


enum YoutubeViewMode {
  KaraokeMode,
  SongMode
}


class YoutubeView extends StatefulWidget {
  final SongData? initialSong;
  final YoutubeViewMode? initialMode;

  const YoutubeView({this.initialSong, this.initialMode, super.key});

  @override
  State<StatefulWidget> createState() {
    return YoutubeViewState();
  }

}

class YoutubeViewState extends State<YoutubeView> {

  late YoutubePlayerController youtubePlayerController;
  late SongData currentSong;
  late YoutubeViewMode mode;

  late SongDatabase database;

  bool fullscreenMode = false;

  List<String> videos = ["fD4rxj7-uO0", "IQvzX0Z3HE4", "4Larp44Ta7c", "U0R8FxDcnM4", "EK0xnviBY1s", "6ZevpFAT1ys"];

  @override
  void initState() {
    super.initState();


  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    database = SongDatabase.of(context);

    currentSong = widget.initialSong ?? database.songs[0];
    mode = widget.initialMode ?? YoutubeViewMode.SongMode;

    String? vId;
    switch(mode) {
      case YoutubeViewMode.KaraokeMode:
        vId = YoutubePlayerController.convertUrlToId(currentSong.youtubeKaraokeUrl??"");
        break;
      case YoutubeViewMode.SongMode:
        vId = YoutubePlayerController.convertUrlToId(currentSong.youtubeSongUrl??"");
        break;
    }

    YoutubePlayerParams params = YoutubePlayerParams(showFullscreenButton: true);

    if(vId != null)
      youtubePlayerController = YoutubePlayerController.fromVideoId(videoId: vId, params: params);
    else
      youtubePlayerController = YoutubePlayerController();
  }

  String? getYoutubeUrlByMode(SongData song) {
    switch(mode) {
      case YoutubeViewMode.KaraokeMode:
        return song.youtubeKaraokeUrl;
      case YoutubeViewMode.SongMode:
        return song.youtubeSongUrl;
    }
  }

  Widget buildFurtherVideosList(BuildContext context) {
    List<SongData> songsWithVideos = database.songs
        .where((element) {
          return getYoutubeUrlByMode(element) != null;
        }).toList();

    return ListView.separated(itemBuilder: (ctx, i) {
      SongData song = songsWithVideos[i];
      var lead = null;
      if(song == currentSong) { // The song of the list item is currently playing
        lead = Icon(Icons.play_arrow);
      }
      return ListTile(
        leading: lead,
        title: Text("${song.num}. ${song.title}"),
        onTap: () {
          setState(() {
            currentSong = song;
            youtubePlayerController.loadVideoById(videoId: YoutubePlayerController.convertUrlToId(getYoutubeUrlByMode(song)??"")??"");
          });
      },);
    }, separatorBuilder: (BuildContext context, int index) { return Divider(); }, itemCount: songsWithVideos.length, shrinkWrap: true,);
  }

  Widget buildModeSwitch(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text("Karaoke"),
      Switch(value: mode==YoutubeViewMode.SongMode, onChanged: (value) {
        setState(() {
          switch(mode) {
            case YoutubeViewMode.KaraokeMode:
              mode=YoutubeViewMode.SongMode;
              break;
            case YoutubeViewMode.SongMode:
              mode=YoutubeViewMode.KaraokeMode;
              break;
          }

          // probably need to reload youtubeplayer
          youtubePlayerController.loadVideoById(
              videoId: YoutubePlayerController.convertUrlToId(getYoutubeUrlByMode(currentSong)??"")??""
          );

        });
      }),
      Text("Dal")
    ],);
  }

  Widget buildWide(BuildContext context, Widget player) {

    final pad = MediaQuery.of(context).padding;

    double sh = MediaQuery.of(context).size.height;
    double sw = MediaQuery.of(context).size.width - (pad.left+pad.right);


    final side = Container(width: 250.0, child: Card(child: Column(children: [
      Center(child:buildModeSwitch(context)),
      Divider(thickness: 4.0,),
      Expanded(child: buildFurtherVideosList(context))
    ])
    )
    );

    return SafeArea(child: Row(children: [
      Container(child: player,constraints: BoxConstraints(maxWidth: sw-250, maxHeight: sh),),
      side,
      ],
    )
    );
  }

  Widget buildTall(BuildContext context, Widget player) {
    return Column(children: [
      player,
      Expanded(child:
      Card(child: Column(children: [
        Center(child: buildModeSwitch(context)),
        Divider(thickness: 2.0,),
        Expanded(child: buildFurtherVideosList(context))
      ],),),)
      ],);
  }

  @override
  Widget build(BuildContext context) {

    var title = mode == YoutubeViewMode.SongMode ? "ZarandokApp Dal" : "ZarandokApp Karaoke";

    return OrientationBuilder(builder: (context, orientation) {
      return ZarandokAppYoutubePlayerScaffold(autoFullScreen: false,
          lockedOrientations: DeviceOrientation.values,
          builder: (context, player) {
            return Scaffold(
                appBar: AppBar(title: Text(title), scrolledUnderElevation: 0.0),
                body: decideOrientation(context, player, orientation)
            );
          }, controller: youtubePlayerController);
    });
  }

  @override
  void dispose() {
    youtubePlayerController.stopVideo().then((value) {
      //youtubePlayerController.close();
    });
    super.dispose();
  }

  Widget decideOrientation(BuildContext context, Widget player, Orientation orientation) {
    var mediaData = MediaQuery.of(context);
    if(mediaData.size.width > mediaData.size.height) { // widescreen
      return buildWide(context, player);
    }
    else {
      return buildTall(context, player);
    }
  }
}