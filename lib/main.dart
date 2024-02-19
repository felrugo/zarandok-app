import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zarándok App',
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
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

  List<String> assetRoutes = [];
  List<SongData> pageDatas = [];

  VirtualPageController virtualPageController = VirtualPageController();
  ViewMode viewMode = ViewMode.VM_IMAGE;


  _MyHomePageState()
  {

        assetRoutes.clear();

        for(int i = 0; i < 232; i++)
          {
            assetRoutes.add("assets/zarandok_img_${i}.jpg");
          }

        rootBundle.loadString("assets/bundle.json").then((v){
          var data = jsonDecode(v);
          for(var s in data)
            {
              pageDatas.add(SongData.fromJson(s));
            }
        });
  }

  SongData getPageDataByPage(int page)
  {
    SongData ret = pageDatas.first;
    pageDatas.forEach((f){
      if(f.page == page)
        {
          ret = f;
        }
    });
    return ret;
  }

  void onSearch() {
    var delegate = SongSearchDelegate(pageDatas);
    showSearch(context: context, delegate: delegate).then((v){
      virtualPageController.jumpTo(v!);
    });
  }

  void openTableOfContent()
  {
    Navigator.push<SongData>(context, MaterialPageRoute(builder: (ctx){
      return TableOfContentsView(pageDatas);
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
      if (viewMode == ViewMode.VM_IMAGE) {
        setState(() {
          viewMode = ViewMode.VM_TEXT;
        });
      }
      else {
        setState(() {
          viewMode = ViewMode.VM_IMAGE;
        });
      }
    },));
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: showMenu ? AppBar(
        title: Text("Zarándok App"),
        actions: buildActions(),
      ) : null,
      drawer: createDrawer(),
      body: VirtualPageView(viewMode, virtualPageController, null),
    );
  }



}
