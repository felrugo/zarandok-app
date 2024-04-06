import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:zarandok_app_2/songdata.dart';

class YoutubeView extends StatefulWidget {
  final SongData? startUrl;

  const YoutubeView({this.startUrl, super.key});

  @override
  State<StatefulWidget> createState() {
    return YoutubeViewState();
  }

}

class YoutubeViewState extends State<YoutubeView> {

  late YoutubePlayerController youtubePlayerController;
  late SongData currentSong;

  List<String> videos = ["fD4rxj7-uO0", "IQvzX0Z3HE4", "4Larp44Ta7c", "U0R8FxDcnM4", "EK0xnviBY1s", "6ZevpFAT1ys"];

  @override
  void initState() {
    super.initState();
    currentSong = widget.startUrl ?? SongDatabase.getInstance().songs[0];

    String? vId;
    if(widget.startUrl != null) {
      vId = YoutubePlayerController.convertUrlToId(currentSong.youtubeUrl??"");
    }

    youtubePlayerController = YoutubePlayerController.fromVideoId(videoId: vId ?? videos[0]);
  }

  Widget buildWide(BuildContext context) {
    return Row(children: [
      Expanded(child: Column(children: [
        YoutubePlayer(controller: youtubePlayerController),
        Align(child: Text("${currentSong.num}. ${currentSong.title}", style: TextStyle(fontSize: 28.0),), alignment: Alignment.topLeft,),
      ]), flex: 2,),
      Expanded(child: ListView.separated(itemBuilder: (ctx, i) {
        return ListTile(leading: Text("Video $i"), onTap: () {
          youtubePlayerController.loadVideoById(videoId: videos[i]);
        },);
      }, separatorBuilder: (BuildContext context, int index) { return Divider(); }, itemCount: videos.length,)
      ),
    ],);
  }

  Widget buildTall(BuildContext context) {
    return Column(children: [
      YoutubePlayer(controller: youtubePlayerController),
      Text("${currentSong.num}. ${currentSong.title}", style: TextStyle(fontSize: 28.0)),
      Expanded(child: ListView.separated(itemBuilder: (ctx, i) {
        return ListTile(leading: Text("Video $i"), onTap: () {
          youtubePlayerController.loadVideoById(videoId: videos[i]);
        },);
      }, separatorBuilder: (BuildContext context, int index) { return Divider(); }, itemCount: videos.length,)
      )
    ],);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ZarandokApp Karaoke"),),
      body: OrientationBuilder(builder: decideOrientation,)
    );
  }

  Widget decideOrientation(BuildContext context, Orientation orientation) {
    var mediaData = MediaQuery.of(context);
    if(mediaData.size.width > mediaData.size.height) { // widescreen
      return buildWide(context);
    }
    else {
      return buildTall(context);
    }
  }
}