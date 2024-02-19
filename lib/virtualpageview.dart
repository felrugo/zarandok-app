import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zarandok_app_2/textmodeview.dart';
import 'package:zarandok_app_2/songdata.dart';


enum ViewMode { VM_IMAGE, VM_TEXT }

typedef OnSongChangedCallback = void Function(SongData? song);

/// Controller for [VirtualPageView]
class VirtualPageController extends ChangeNotifier
{

  SongData? _songData;

  SongData? get currentSong {
    return _songData;
  }

  void jumpTo(SongData pageData)
  {
    _songData = pageData;
    notifyListeners();
  }
}

class VirtualPageView extends StatefulWidget
{

  final VirtualPageController controller;
  final OnSongChangedCallback? songChangedCallback;

  final ViewMode viewMode;

  VirtualPageView(this.viewMode, this.controller, this.songChangedCallback, {super.key});

  @override
  State<StatefulWidget> createState() {
    return VirtualPageViewState();
  }
}

class VirtualPageViewState extends State<VirtualPageView>
{

  PageController pageController = PageController();

  TransformationController transformationController = TransformationController();

  List<String> assetRoutes = [];
  List<SongData> pageDatas = [];

  bool zoomed = false;

  late VirtualPageController controller;
  late OnSongChangedCallback? changedCallback;
  late ViewMode viewMode;

  VirtualPageViewState()
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
      pageDatas.sort((a,b) => a.num.compareTo(b.num));
    });

  }

  void onSongJump() {
    transformationController.value.setIdentity();
    zoomed = false;
    switch(viewMode) {
      case ViewMode.VM_IMAGE:
        pageController.jumpToPage(controller.currentSong?.page??0);
        break;
      case ViewMode.VM_TEXT:
        pageController.jumpToPage((controller.currentSong?.num??1)-1);
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    changedCallback = widget.songChangedCallback;
    viewMode = widget.viewMode;

    controller.addListener(onSongJump);

  }

  @override
  void didUpdateWidget(covariant VirtualPageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    controller = widget.controller;
    changedCallback = widget.songChangedCallback;
    viewMode = widget.viewMode;

    if(controller != oldWidget.controller) { // Reinit callback
      oldWidget.controller.removeListener(onSongJump);
      controller.addListener(onSongJump);
    }


    transformationController.value.setIdentity();
    zoomed = false;
    switch(viewMode) {
      case ViewMode.VM_IMAGE:
        pageController.jumpToPage(controller.currentSong?.page??0);
        break;
      case ViewMode.VM_TEXT:
        pageController.jumpToPage((controller.currentSong?.num??1)-1);
        break;
    }

  }

  int getForPage(int page)
  {
    var maped = pageDatas.map((e) => (e.page - page).abs());
    var m = maped.reduce(min);
    var filtered = List<SongData>.from(pageDatas);
    filtered.retainWhere((e) => (e.page - page).abs() == m);
    filtered.sort((a,b)=> a.num.compareTo(b.num));
    var ix = pageDatas.indexOf(filtered.first);
    return ix;
  }
  
  onPageChanged(int page)
  {
    SongData? data;
    if (viewMode == ViewMode.VM_IMAGE)
    {
      data = pageDatas.firstWhere((element){
        return page == element.page;
      }, orElse: ()=>pageDatas.first);
    }
    else
    {
      data = pageDatas.firstWhere((element){
        return page == element.num-1;
      }, orElse: ()=>pageDatas.first);
    }

    controller._songData = data;
  }


  @override
  Widget build(BuildContext context) {

    Widget inner = PageView.builder(
        controller: pageController,
        itemCount: assetRoutes.length,
        onPageChanged: onPageChanged,
        physics: !zoomed ? PageScrollPhysics() : NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, i){
          return viewMode == ViewMode.VM_IMAGE ?
          InteractiveViewer(
            constrained: true,
            scaleEnabled: true,
            panEnabled: zoomed,
            transformationController: transformationController,
            minScale: 1.0,
            maxScale: 10.0,
            onInteractionUpdate: (details) {
              double correctScale = transformationController.value.getMaxScaleOnAxis();
              setState(() {
                zoomed = ! ( correctScale <= (1.0 + 0.005) );
              });
            },
            child: Image.asset(assetRoutes[i]),
          )
              : TextModeView(pageDatas[i]);
        });

    return inner;

  }
}