// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/material.dart';
import 'package:zarandok_app_2/models.dart';
import 'package:zarandok_app_2/songdata.dart';
import 'package:iculo/views/id_card.dart';

/// [FilterMode] to filter authors and translators
enum FilterMode {
  Author,
  Translator
}

/// Table of Authors widget to search for songs based on their authors or translators
class TableOfAuthors extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TableOfAuthorsState();
  }

}

/// [State] for the [TableOfAuthors] widget
class _TableOfAuthorsState extends State<TableOfAuthors> {

  /// Filter mode, Author by default
  late FilterMode filterMode;

  @override
  void initState() {
    super.initState();
    filterMode = FilterMode.Author;
  }


  @override
  Widget build(BuildContext context) {
    
    ZarandokAppBundle bundle = ZarandokAppBundle.of(context);
    var roleName = filterMode == FilterMode.Author ? "author" : "translator";
    var roleCats = bundle.collectPersonIdsByRole();
    var personIds = roleCats[roleName] ?? [];
    var peoples = personIds.map(bundle.mapPersonIdToPerson).toList();
    peoples.sort((a, b){return a.name.compareTo(b.name);});
    
    return Scaffold(
      appBar: AppBar(title: Text("Szerzők")),
      body: ListView.builder(itemBuilder: (ctx, ix) {

        var name = peoples[ix].name;
        var pid = peoples[ix].id;

        var songs = bundle.getSongsForPersonId(pid, role: roleName);

        return IdCard(
          name: name,
          body: Column(children: songs.map((e){
            return buildSongListTile(e, context, (){
              Navigator.pop(context, e);
            });
          }).toList(),),
        );

      }, itemCount: peoples.length,),
      bottomNavigationBar: NavigationBar(destinations: [
        NavigationDestination(icon: Icon(Icons.music_note), label: "Zeneszerzők"),
        NavigationDestination(icon: Icon(Icons.book), label: "Szövegírók / Fordítók")
      ],
        selectedIndex: FilterMode.values.indexOf(filterMode),
        onDestinationSelected: (ix){
          setState(() {
            filterMode = FilterMode.values[ix];
          });
        },
      ),
    );
  }
  
}