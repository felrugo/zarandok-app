

import 'package:flutter/material.dart';
import 'package:zarandok_app_2/songdata.dart';
import 'package:zarandok_app_2/strcomp.dart';

class SongSearchDelegate extends SearchDelegate<SongData>
{
  List<SongData> _songs;

  SongSearchDelegate(this._songs);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(icon: Icon(Icons.cancel), onPressed: (){ query = ""; },)
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    if(_songs == null) {
      return Container();
    }
    _songs.sort((a,b){
      try {
        if (int.parse(query) != null)
          return (int.parse(query) - a.num).abs().compareTo(
              (int.parse(query) - b.num).abs());
      }
      catch(e) {}
      return distance(query, b.title).compareTo(distance(query, a.title));
    });

    return ListView.separated(itemBuilder: (c, i){
      return buildSongListTile(_songs[i], c, () {
        close(context, _songs[i]);
      });
    },
      itemCount: 10,
      separatorBuilder: (c, i){
        return Divider();
      },);
  }


  @override
  Widget buildSuggestions(BuildContext context) {

    if(_songs == null) {
      return Container();
    }

    _songs.sort((a,b){

      try {
        if (int.parse(query) != null)
          return (int.parse(query) - a.num).abs().compareTo(
              (int.parse(query) - b.num).abs());
      }
      catch(e) {}
      return distance(query, b.title).compareTo(distance(query, a.title));
    });
    return ListView.separated(itemBuilder: (c, i){
      return buildSongListTile(_songs[i], c, () {
        close(context, _songs[i]);
      });
    },
    itemCount: 10,
    separatorBuilder: (c, i){
      return Divider();
    },);
  }

}