import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:zarandok_app_2/songdata.dart';
import 'package:zarandok_app_2/youtube_view.dart';

enum SortType {
  ST_TITLE,
  ST_NUM
}

const Map<SortType, String> SortTypeNames = {
  SortType.ST_TITLE: "Title",
  SortType.ST_NUM : "Number"
};

class TableOfContentsView extends StatefulWidget
{

  final List<SongData> data;

  TableOfContentsView(this.data);

  @override
  State<StatefulWidget> createState() {
    return TableOfContentsState(data);
  }

}

class TableOfContentsState extends State<TableOfContentsView>
{

  List<SongData> data;
  SortType sortType = SortType.ST_TITLE;

  TableOfContentsState(this.data)
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
      Navigator.pop(ctx, data[ix]);
    },);
  }

  void sortIt()
  {
    this.data.sort((a, b){
      switch(sortType) {
        case SortType.ST_TITLE:
          return a.title.compareTo(b.title);
          break;
        case SortType.ST_NUM:
          return a.num.compareTo(b.num);
          break;
      }
      return 0;
    });
  }

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
      body: Scrollbar(child: ListView.separated(itemBuilder: buildListItem, separatorBuilder: (ctx, ix)=>Divider(), itemCount: data.length)),
    );
  }

}