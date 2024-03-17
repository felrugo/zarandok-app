import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeView extends StatefulWidget {
  const YoutubeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return YoutubeViewState();
  }

}

class YoutubeViewState extends State<YoutubeView> {

  late YoutubePlayerController youtubePlayerController;

  List<String> videos = ["fD4rxj7-uO0", "IQvzX0Z3HE4", "4Larp44Ta7c", "U0R8FxDcnM4", "EK0xnviBY1s", "6ZevpFAT1ys"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    youtubePlayerController = YoutubePlayerController.fromVideoId(videoId: "fD4rxj7-uO0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ZarandokApp Karaoke"),),
      body: Row(children: [
        Expanded(child: YoutubePlayer(controller: youtubePlayerController), flex: 2,),
        Expanded(child: ListView.separated(itemBuilder: (ctx, i) {
            return ListTile(leading: Text("Video $i"), onTap: () {
              youtubePlayerController.loadVideoById(videoId: videos[i]);
            },);
          }, separatorBuilder: (BuildContext context, int index) { return Divider(); }, itemCount: videos.length,)
        ),
      ],),
    );
  }
  
}