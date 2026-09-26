// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iculo/model.dart';
import 'package:iculo/utils/iculo_youtube_scaffold.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:zarandok_app_2/models.dart';

/// [YoutubeViewMode] for the karaoke and song mode
enum YoutubeViewMode {
  KaraokeMode,
  SongMode
}

/// View for the youtube player. Depends on the bug fixes of the [YoutubePlayerScaffold]
/// contained in the Iculo library as [IculoYoutubePlayerScaffold].
/// Due to deprecation, [YoutubePlayer] should be prefered in the next releases
/// Revision needed
class YoutubeView extends StatefulWidget {
  final IculoSong? initialSong;
  final YoutubeViewMode? initialMode;

  const YoutubeView({this.initialSong, this.initialMode, super.key});

  @override
  State<StatefulWidget> createState() {
    return YoutubeViewState();
  }

}

/// [State] for the [YoutubeView].
/// Contains minor workarounds due to Youtube policies
/// Visualised differently based on screen orientation.
class YoutubeViewState extends State<YoutubeView> {

  late YoutubePlayerController youtubePlayerController;
  late IculoSong currentSong;
  late YoutubeViewMode mode;

  /// [ZarandokAppBundle] provided from the [BuildContext]
  late ZarandokAppBundle bundle;

  bool fullscreenMode = false;

  @override
  void initState() {
    super.initState();

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bundle = ZarandokAppBundle.of(context);

    currentSong = widget.initialSong ?? bundle.first;
    mode = widget.initialMode ?? YoutubeViewMode.SongMode;

    String? vId;
    switch(mode) {
      case YoutubeViewMode.KaraokeMode:
        vId = YoutubePlayerController.convertUrlToId(currentSong.youtubeKaraoke??"");
        break;
      case YoutubeViewMode.SongMode:
        vId = YoutubePlayerController.convertUrlToId(currentSong.youtubeSong??"");
        break;
    }

    YoutubePlayerParams params = YoutubePlayerParams(
      showFullscreenButton: true,
      origin: "https://www.youtube-nocookie.com"
    );

    youtubePlayerController = YoutubePlayerController(params: params);

    if(vId != null) {
      youtubePlayerController.loadVideoById(videoId: vId);
    }
  }

  /// Gets the youtube url based on [mode]
  String? getYoutubeUrlByMode(IculoSong song) {
    switch(mode) {
      case YoutubeViewMode.KaraokeMode:
        return song.youtubeKaraoke;
      case YoutubeViewMode.SongMode:
        return song.youtubeSong;
    }
  }

  Widget buildFurtherVideosList(BuildContext context) {
    List<IculoSong> songsWithVideos = bundle.songs
        .where((element) {
          return getYoutubeUrlByMode(element) != null;
        }).toList();

    return ListView.separated(itemBuilder: (ctx, i) {
      IculoSong song = songsWithVideos[i];
      var lead = null;
      if(song.isSame(currentSong)) { // The song of the list item is currently playing
        lead = Icon(Icons.play_arrow);
      }
      return Card(child: ListTile(
        leading: lead,
        title: Text("${song.num}. ${song.title}"),
        onTap: () {
          setState(() {
            currentSong = song;
            youtubePlayerController.loadVideoById(videoId: YoutubePlayerController.convertUrlToId(getYoutubeUrlByMode(song)??"")??"");
          });
      },));
    }, separatorBuilder: (BuildContext context, int index) { return SizedBox.fromSize(size: Size(250, 10),); },
      itemCount: songsWithVideos.length, shrinkWrap: true,);
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

  Widget buildSelectChips(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      children: [
        ChoiceChip(label: Text("Dal"), selected: mode == YoutubeViewMode.SongMode, onSelected: currentSong.youtubeSong == null ? null : (v){
          setState(() {
            mode = YoutubeViewMode.SongMode;

            // probably need to reload youtubeplayer
            youtubePlayerController.loadVideoById(
                videoId: YoutubePlayerController.convertUrlToId(getYoutubeUrlByMode(currentSong)??"")??""
            );
          });
        },),
        ChoiceChip(label: Text("Karaoke"), selected: mode == YoutubeViewMode.KaraokeMode, onSelected: currentSong.youtubeKaraoke == null ? null : (v){
          setState(() {
            mode = YoutubeViewMode.KaraokeMode;

            // probably need to reload youtubeplayer
            youtubePlayerController.loadVideoById(
                videoId: YoutubePlayerController.convertUrlToId(getYoutubeUrlByMode(currentSong)??"")??""
            );
          });
        },),
      ],
    );
  }

  /// Build the horizontal variant of the widget
  Widget buildWide(BuildContext context, Widget player) {

    final pad = MediaQuery.of(context).padding;

    double sh = MediaQuery.of(context).size.height;
    double sw = MediaQuery.of(context).size.width - (pad.left+pad.right);


    final side = Container(width: 250.0, child: Column(children: [
      buildSelectChips(context),
      SizedBox.fromSize(size: Size(250, 20),),
      Expanded(child: buildFurtherVideosList(context))
    ])

    );

    return SafeArea(child: Row(children: [
      Container(child: player,constraints: BoxConstraints(maxWidth: sw-250, maxHeight: sh),),
      side,
      ],
    )
    );
  }

  /// Build the vertical variant of the widget
  Widget buildTall(BuildContext context, Widget player) {
    return Column(children: [
      player,
      Expanded(child:
      Column(children: [
        SizedBox.fromSize(size: Size(250, 10),),
        buildSelectChips(context),
        SizedBox.fromSize(size: Size(250, 10),),
        Expanded(child: buildFurtherVideosList(context))
      ],),)
      ],);
  }

  @override
  Widget build(BuildContext context) {

    var title = mode == YoutubeViewMode.SongMode ? "ZarandokApp Dal" : "ZarandokApp Karaoke";

    return OrientationBuilder(builder: (context, orientation) {
      return IculoYoutubePlayerScaffold(autoFullScreen: false,
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

  /// Workaround to decide the screen orientation and return the decided variant.
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