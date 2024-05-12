// Copyright(c) Szabó Bálint 2023-2024
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zarandok_app_2/about.dart';
import 'package:zarandok_app_2/virtualpageview.dart';
import 'package:zarandok_app_2/songdata.dart';
import 'package:zarandok_app_2/songsearch.dart';
import 'package:zarandok_app_2/tableofcontents.dart';
import 'dart:convert';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

void main() => runApp(ZarandokApp());

class ZarandokApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ZarandokAppState();
  }
}

class ZarandokAppState extends State<ZarandokApp> {

  SongDatabase? database;

  @override
  Widget build(BuildContext context) {

    if(database != null) {
      var app = MaterialApp(
          title: 'ZarandokApp',
          scrollBehavior: AppScrollBehavior(),
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page')
      );
      return SongDatabaseProvider(database!, child: app);
    }
    else {

      SongDatabase.getInstance().then((value) {
        setState(() {
          database = value;
        });
      });

      return Center(child: CircularProgressIndicator(),);
    }
  }
  
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool showMenu = true;
  late VirtualPageController virtualPageController;
  late SongDatabase songDatabase;
  ViewMode viewMode = ViewMode.Sheet;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    songDatabase = SongDatabase.of(context);
    virtualPageController = VirtualPageController.fromSong(songDatabase.startOfBook);
  }

  void onSearch() {
    var delegate = SongSearchDelegate(songDatabase?.songs ?? []);
    showSearch(context: context, delegate: delegate).then((v){
      if(v != null)
        virtualPageController.jumpTo(v);
    });
  }

  void openTableOfContent()
  {
    Navigator.push<SongData>(context, MaterialPageRoute(builder: (ctx){
      return TableOfContentsView(songDatabase.songs ?? []);
    })).then((v){
      if (v != null) {
        virtualPageController.jumpTo(v);
      }
      Navigator.pop(context);
    });
  }

  void openAbout() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx){
      return AboutPage();
    }
    )).then((value) => Navigator.pop(context));
  }


  Drawer createDrawer()
  {
    return Drawer(child: ListView(padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text(""),
          padding: EdgeInsets.zero, margin: EdgeInsets.zero,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/zarandokheaderimg.png"), fit: BoxFit.cover)),
        ),
        ListTile(leading: Icon(Icons.list),title: Text("Tartalomjegyzék"), onTap: openTableOfContent,),
        ListTile(leading: Icon(Icons.info_outline),title: Text("Rólunk"), onTap: openAbout,),
      ],
      ),
    );
  }

  List<Widget> buildActions()
  {
    List<Widget> ret = [];
    ret.add(IconButton(icon: Icon(Icons.search), onPressed: onSearch));
    ret.add(IconButton(icon: Icon(Icons.text_fields), onPressed: () {
      virtualPageController.toggleViewMode();
    },));
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showMenu ? AppBar(
        title: Row(children: [ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.asset("assets/icon/icon.png", fit: BoxFit.cover, height: 30.0,)), SizedBox(width: 10.0,), Text("ZarandokApp")],),
        actions: buildActions(),
      ) : null,
      drawer: createDrawer(),
      body: VirtualPageView(viewMode, virtualPageController, null),
    );
  }



}
