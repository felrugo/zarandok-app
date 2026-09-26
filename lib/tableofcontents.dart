// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iculo/model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:zarandok_app_2/models.dart';
import 'package:zarandok_app_2/songdata.dart';
import 'package:zarandok_app_2/youtube_view.dart';

/// Enum to represent sorting type: Sort by Title [SortType.ST_TITLE] or sort by Number [SortType.ST_NUM]
enum SortType {
  ST_TITLE,
  ST_NUM
}

/// Map to convert [SortType] to its name
const Map<SortType, String> SortTypeNames = {
  SortType.ST_TITLE: "Title",
  SortType.ST_NUM : "Number"
};

/// Widget to list songs ordered by Title [SortType.ST_TITLE] or Number [SortType.ST_NUM]
class TableOfContentsView extends StatefulWidget
{

  final List<IculoSong> data;

  TableOfContentsView(this.data);

  @override
  State<StatefulWidget> createState() {
    return _TableOfContentsState(data);
  }

}

/// [State] for [TableOfContentsView].
class _TableOfContentsState extends State<TableOfContentsView>
{

  List<IculoSong> data;
  SortType sortType = SortType.ST_TITLE;

  _TableOfContentsState(this.data)
  {
    sortType = SortType.ST_TITLE;
    sortIt();
  }

  @override
  void initState() {
    super.initState();

  }

  Widget buildListItem(BuildContext ctx, int ix)
  {
    return buildSongListTile(data[ix], ctx, (){
      // Open the selected song
      Navigator.pop(ctx, data[ix]);
    },);
  }

  /// Sort [data] based in the current [sortType]
  void sortIt()
  {
    this.data.sort((a, b){
      var ta = a.title??"";
      var tb = b.title??"";

      var na = a.num??0;
      var nb = b.num??0;

      switch(sortType) {
        case SortType.ST_TITLE:
          return ta.compareTo(tb);

        case SortType.ST_NUM:
          return na.compareTo(nb);

      }

    });
  }

  /// Called when the sort button pressed, changes the sorting preference
  void onSort(BuildContext ctx)
  {
    setState(() {
      sortType = SortType.values[(sortType.index+1) % SortType.values.length];

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text("Sorted by ${SortTypeNames[sortType]}"),
        duration: Duration(seconds: 2),
      ));
      sortIt();
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tartalomjegyzék"), actions: <Widget>[
        Builder(builder: (ctx){
          return IconButton(icon: Icon(Icons.sort), onPressed: (){onSort(ctx);});
          },
        )
      ],),
      body: ListView.separated(itemBuilder: buildListItem, separatorBuilder: (ctx, ix)=>Divider(), itemCount: data.length), // Simple [ListView] for the songs
    );
  }

}