

import 'package:flutter/material.dart';
import 'package:zarandok_app_2/songdata.dart';

/// Widget to show the lyrics of a song.
class TextModeView extends StatelessWidget
{

  final SongData _pageData;

  TextModeView(this._pageData);

  /// Builds the lyrics text from the lyrics and song number.
  String _generateLyrics(List<String> lyrics, int num)
  {
    String ret = "$num. ének\n\n";
    for(var s in lyrics)
    {
      ret = ret + s + "\n\n";
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    if(_pageData != null && _pageData.lyrics.length > 0) {
      return SingleChildScrollView(child:
      Container(
        child: FittedBox(
          child: Text(_generateLyrics(_pageData.lyrics, _pageData.num)),
          fit: BoxFit.fitWidth,
        ),
      ));
    }
    else
    {
      return Center(
        child: Text("No Page Data for this page"),
      );
    }
  }
  
}