// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iculo/model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zarandok_app_2/download_manager.dart';
import 'package:zarandok_app_2/iconchangebutton.dart';
import 'package:zarandok_app_2/tableofcontents.dart';
import 'package:zarandok_app_2/youtube_view.dart';

import 'models.dart';

/// A big utility function to create a [ListTile] to show the song in search and in [TableOfContentsView].
/// Probably can have a better place in the future or be ousourced into the Iculo library
ListTile buildSongListTile(IculoSong song, BuildContext context, VoidCallback onTap) {

  List<Widget> trailing = []; // Song, Karaoke, Download sheet, Download chords


  if(song.youtubeSong != null) { // Add Song navigation if there is song url
    trailing.add(
        IconChangeButton(hoverIcon: SvgPicture.asset("assets/svgs/icons/play_song_bg.svg", height: 30, width: 30), onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return YoutubeView(initialSong: song, initialMode: YoutubeViewMode.SongMode,);
          }));
        }, icon: SvgPicture.asset("assets/svgs/icons/play_song.svg", fit: BoxFit.cover, height: 30.0, width: 30.0) // Use SVG
        )
    );
  }

  if(song.youtubeKaraoke != null) {
    trailing.add(
        IconChangeButton(hoverIcon: SvgPicture.asset("assets/svgs/icons/play_karaoke_bg.svg", height: 30, width: 30), onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return YoutubeView(initialSong: song, initialMode: YoutubeViewMode.KaraokeMode,);
          }));
        }, icon: SvgPicture.asset("assets/svgs/icons/play_karaoke.svg", fit: BoxFit.cover, height: 30.0, width: 30.0)
        )
    );
  }

  if(song.externalUrls.isNotEmpty) {


    trailing.add(
        IconChangeButton(hoverIcon: SvgPicture.asset(
            "assets/svgs/icons/dl_sheet_bg.svg", fit: BoxFit.cover,
            height: 30.0,
            width: 30.0),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return DownloadAssetSelector(song, trans: (name, url) {

                  void down_action() {
                    launchUrlString(url).then((v) {

                    });
                  }

                  if (name == "sheet_ws") {
                    return ListTile(leading: SvgPicture.asset(
                        "assets/svgs/icons/dl_sheet.svg", fit: BoxFit.cover,
                        height: 30.0,
                        width: 30.0),
                      title: Text("Kotta (mobilra optimizált)"),
                      onTap: down_action,
                    );
                  }
                  if (name == "text_ws") {
                    return ListTile(leading: SvgPicture.asset(
                        "assets/svgs/icons/dl_chords.svg", fit: BoxFit.cover,
                        height: 30.0,
                        width: 30.0),
                      title: Text("Szöveg és akkordok (mobilra optimizált)"),
                      onTap: down_action,
                    );
                  }

                  if (name == "sheet_a4") {
                    return ListTile(leading: SvgPicture.asset(
                        "assets/svgs/icons/dl_sheet.svg", fit: BoxFit.cover,
                        height: 30.0,
                        width: 30.0),
                      title: Text("Kotta (A4-es változat)"),
                      onTap: down_action,
                    );
                  }


                  return ListTile();
                },);
              }));
            },
            icon: SvgPicture.asset(
              "assets/svgs/icons/dl_sheet.svg", fit: BoxFit.cover,
              height: 30.0,)
        )
    );
  }

  return ListTile(
    title: Text(song.title??""),
    subtitle: Text("${song.num}. ének"),
    onTap: onTap,
    trailing: Row(mainAxisSize: MainAxisSize.min, children: trailing,
    ),
  );
}


