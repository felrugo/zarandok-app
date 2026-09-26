// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iculo/model.dart';
import 'package:iculo/views/multi_reel_gallery.dart';
import 'package:iculo/views/sectional_contributors_page.dart';
import 'package:zarandok_app_2/impressum.dart';
import 'package:zarandok_app_2/models.dart';
import 'package:zarandok_app_2/settings.dart';
import 'package:zarandok_app_2/songsearch.dart';
import 'package:zarandok_app_2/tableofauthors.dart';
import 'package:zarandok_app_2/tableofcontents.dart';

import 'iconchangebutton.dart';

/// Booklet view is the main screen of the application
/// Shows the paging sheets and a drawer menu with some actions
class BookletView extends StatefulWidget {
  BookletView({Key? key}) : super(key: key);

  @override
  _BookletViewState createState() => _BookletViewState();
}

/// [State] for the [BookletView]
class _BookletViewState extends State<BookletView> {

  bool showMenu = true;
  bool text_mode = false;
  late IculoMultiReelGalleryController galleryController;
  late ZarandokAppBundle bundle;

  late IculoSettingsModel settings;

  @override
  void initState() {
    super.initState();
  }

  void onSettingsChange() {
    setState(() {

    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bundle = ZarandokAppBundle.of(context);
    settings = IculoSettingsModel.of(context);
    settings.addListener(this.onSettingsChange);

    var defReel = bundle.getReelNames().first;
    galleryController = IculoMultiReelGalleryController.fromSong(song: bundle.first, initialReelName: defReel);
  }

  /// Called when someone clicks the search button
  void onSearch() {
    var delegate = SongSearchDelegate(bundle.songs ?? []);
    showSearch(context: context, delegate: delegate).then((v){
      if(v != null)
        galleryController.jumpTo(v);
    });
  }

  /// This function opens the table of contents
  /// If a song is selected in the ToC, it seeks to it with the [galleryController]
  void openTableOfContent()
  {
    Navigator.push<IculoSong>(context, MaterialPageRoute(builder: (ctx){
      return TableOfContentsView(bundle.songs ?? []);
    })).then((v){
      if (v != null) {
        galleryController.jumpTo(v);
      }
      Navigator.pop(context);
    });
  }

  /// This function opens the About page, based on [IculoSectionalContributorsPage]
  void openAbout() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx){
      return Scaffold(
        appBar: AppBar(title: Text("Rólunk"),),
        body: IculoSectionalContributorsPage(bundle: bundle, appName: "ZarandokApp", appIcon: SvgPicture.asset("assets/svgs/icons/app_icon_bg.svg", fit: BoxFit.cover, height: 40.0),),
      );
    }
    )).then((value) => Navigator.pop(context));
  }

  /// This function opens the impressum view, based on [Impressum]
  void openImpressum() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx){
      return Impressum();
    }
    )).then((value) => Navigator.pop(context));
  }

  /// This function opens the Table of Authors, [TableOfAuthors]
  void openTableOfAuthors() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx){
      return TableOfAuthors();
    }
    )).then((v) {
      if (v != null) {
        galleryController.jumpTo(v);
      }
      Navigator.pop(context);
    });
  }

  /// This function opens the Settings, [IculoSettings]
  void openSettings() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return IculoSettings();
    }));
  }

  /// This function builds the drawer menu
  /// Some options are commented out, being WIP
  Drawer createDrawer()
  {
    return Drawer(child: ListView(padding: EdgeInsets.zero,
      children: <Widget>[
        SvgPicture.asset("assets/svgs/extras/drawer_header.svg", width: 304.0,),
        ListTile(leading: SvgPicture.asset("assets/svgs/icons/contents_bg.svg", fit: BoxFit.cover, height: 30.0,),title: Text("Tartalomjegyzék"), onTap: openTableOfContent,),
        ListTile(leading: SvgPicture.asset("assets/svgs/icons/about_bg.svg", fit: BoxFit.cover, height: 30.0,),title: Text("Rólunk"), onTap: openAbout,),
        ListTile(leading: SvgPicture.asset("assets/svgs/icons/impressum_bg.svg", fit: BoxFit.cover, height: 30.0,),title: Text("Impresszum"), onTap: openImpressum,),
        //ListTile(leading: SvgPicture.asset("assets/svgs/icons/chord_table_bg.svg", fit: BoxFit.cover, height: 30.0,),title: Text("Akkordtáblázat")),
        ListTile(leading: SvgPicture.asset("assets/svgs/icons/authors_bg.svg", fit: BoxFit.cover, height: 30.0,),title: Text("Énekszerzők"), onTap: openTableOfAuthors,),
        //ListTile(leading: Icon(Icons.settings, size: 30.0),title: Text("Beállítások"), onTap: openSettings,),
      ],
    ),
    );
  }

  /// This function builds the actions of the main screen, like the text mode or search
  List<Widget> buildActions()
  {
    List<Widget> ret = [];
    ret.add(IconChangeButton(icon: SvgPicture.asset("assets/svgs/icons/search.svg", width: 30.0, height: 30.0,), onPressed: onSearch, hoverIcon: SvgPicture.asset("assets/svgs/icons/search_bg.svg", width: 30.0, height: 30.0,),));
    ret.add(IconChangeButton(icon: SvgPicture.asset("assets/svgs/icons/text_toggle.svg", width: 30.0, height: 30.0,), hoverIcon: SvgPicture.asset("assets/svgs/icons/text_toggle_bg.svg", width: 30.0, height: 30.0,), onPressed: () {
      text_mode = !text_mode;
      var reelName = "sheet";
      if (text_mode) {
        reelName = "text";
      }
      galleryController.setReel(reelName);
    },));
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showMenu ? AppBar(
        title: Row(children: [ClipRRect(borderRadius: BorderRadius.circular(5), child: SvgPicture.asset("assets/svgs/icons/app_icon_bg.svg", fit: BoxFit.cover, height: 30.0)), SizedBox(width: 10.0,), Text("ZarandokApp")],),
        actions: buildActions(),
      ) : null,
      drawer: createDrawer(),
      body: IculoMultiReelGallery(
        bundle: bundle,
        reelScrollDirection: settings.verticalScroll ? Axis.vertical : Axis.horizontal,
        controller: galleryController,
        prefixPages: [SvgPicture.asset("assets/svgs/extras/cover_ws.svg"),],
      ),
    );
  }

}
