// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The [Impressum] is a simple [StatelessWidget] to present some paragraphs in clear text.
class Impressum extends StatelessWidget {

  /// Builds the text part of the widget
  Widget buildImpressumText(BuildContext context) {

    const texts_col = Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
      Text("A MEVISZ, a Evangélikus.hu, valamint az Evangélikus Egyház Gyülekezeti és Missziói Osztálya közreműködésével megszületett a ZarándokApp alaposan átdolgozott, frissített verziója. Az alkalmazás célja, hogy az éneklést könnyítsék, és közelebb hozzák mind a fiatalabb, mind az idősebb korosztályhoz, gyülekezeteinkben."),
      Text("Az akkordok a német (magyar) hagyományos írásmódot követik, hogy az E-hangár zenekarfejlesztő programunkkal egységes kottaképet alkotva akár kész, nyomtatható hangszereléseket adhassunk gyülekezeteink, iskoláink könnyűzenei formációi számára."),
      Text("A következő nagyobb frissítésben, a hagyományos kottaképen túl, az akkordokkal ellátott dalszövegek is külön meg fognak jelenni, ezzel segítve az akkordhangszeresek szolgálatát."),
      Text("Új funkcióként pedig akár lehetőséged van arra is, hogy lejátszhasd kedvenc éneked karaoke, illetve teljes értékű feldolgozását, amely a gyülekezeti alkalmakon, illetve a hitoktatásban is igazán hasznos lehet. Az új funkció tartalma, az ehhez szükséges felvételek elkészülésével fokozatosan válik a jövőben elérhetővé."),
      Text("A tartalomjegyzék és a keresés pedig tovább egyszerűsíti az énekfüzetben való tájékozódást."),
      Text("Ha a használat során akár zenei, akár technikai kérdésed merülne fel, keress minket bátran a konnyuzene@lutheran.hu címen!"),
      Text("Kellemes időtöltést kívánunk!"),
    ], spacing: 16.0, crossAxisAlignment: CrossAxisAlignment.start,);

    return DefaultTextStyle(child: Container(margin: EdgeInsets.symmetric(horizontal: 20.0), child: texts_col,), style: TextStyle(fontSize: 16.0, color: Colors.black, inherit: true),);
  }


  @override
  Widget build(BuildContext context) {

    // Header
    var title_row = Row(
      mainAxisAlignment: MainAxisAlignment.center, spacing: 10.0,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: SvgPicture.asset("assets/svgs/icons/app_icon_bg.svg", fit: BoxFit.cover, height: 64.0)),
        Text("ZarandokApp", style: TextStyle(fontSize: 42.0, fontFamily: "Roboto Slab"),)
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text("Impresszum")),
      body: Column(children: [
        title_row,
        Divider(),
        Expanded(child:
        LayoutBuilder(builder: (ctx, constraints) {
          return SingleChildScrollView(child: ConstrainedBox(constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: buildImpressumText(ctx),),);
        }),)
      ],),
    );
  }
  
}