// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/material.dart';
import 'package:iculo/model.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Transformation function to create a [ListTile] based on the id of the download and its url.
typedef ExternalUrlTransform = ListTile Function(String id_name, String url);

/// Download manager widget to be opened when someone selects download from the [buildSongListTile].
class DownloadAssetSelector extends StatelessWidget {

  /// The song for which the downloadable content is listed
  final IculoSong song;

  /// The [ListTile] transformation function, can be null for default
  final ExternalUrlTransform? trans;

  DownloadAssetSelector(this.song, {this.trans});

  @override
  Widget build(BuildContext context) {

    ExternalUrlTransform trans_func = trans ?? (name, url) {
      // Default transformation gives the id back
      return ListTile(title: Text(name), onTap: () {
        launchUrlString(url);
      },);
    };

    // Transformed tiles from the contents
    Iterable<ListTile> tiles = song.externalUrls.entries.map((e) { return trans_func(e.key, e.value); });

    // Some header
    var head = Padding(padding: EdgeInsetsGeometry.fromLTRB(0.0, 0.0, 0.0, 12.0), child: Column(children: [
      Text("${song.num}", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight(500)),),
      Text(song.title??"", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight(700))),
      Text("${tiles.length} letölthető tartalom"),
    ],));

    return Scaffold(
      appBar: AppBar(title: Text("Letöltéskezelő"),),
      body: Column(children: [head, Expanded(child: ListView(children: tiles.toList()))]),
    );
  }

}
