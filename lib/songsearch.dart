// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/material.dart';
import 'package:iculo/model.dart';
import 'package:zarandok_app_2/models.dart';
import 'package:zarandok_app_2/songdata.dart';
import 'package:zarandok_app_2/strcomp.dart';

/// [SearchDelegate] for searching songs
class SongSearchDelegate extends SearchDelegate<IculoSong>
{

  List<IculoSong> _songs;

  /// Constructor, gets the list of [IculoSong]
  SongSearchDelegate(this._songs);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.cancel), onPressed: (){ query = ""; },) // Clear action, resets the query
    ];
  }

  List<IculoSong> combinedSearch(String prompt, {int limit = 10}) {
    _songs.sort((a, b) {
      try {
        int parsed = int.parse(query);
        var snuma = a.num ?? 0;
        var snumb = b.num ?? 0;
        return (parsed - snuma).abs().compareTo((parsed - snumb).abs());
      } catch (e) {}
      return distance(query, b.title ?? "").compareTo(distance(query, a.title ?? ""));
    });

    return _songs.take(limit).toList();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    
    var search_result = combinedSearch(query);
    
    return ListView.separated(itemBuilder: (c, i){
      return buildSongListTile(search_result[i], c, () {
        close(context, search_result[i]);
      });
    },
      itemCount: search_result.length,
      separatorBuilder: (c, i){
        return Divider();
      },);
  }


  @override
  Widget buildSuggestions(BuildContext context) {

    var search_result = combinedSearch(query);

    return ListView.separated(itemBuilder: (c, i){
      return buildSongListTile(search_result[i], c, () {
        close(context, search_result[i]);
      });
    },
    itemCount: search_result.length,
    separatorBuilder: (c, i){
      return Divider();
    },);
  }

}