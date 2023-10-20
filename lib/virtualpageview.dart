import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zarandok_app_2/sheetmodeview.dart';
import 'package:zarandok_app_2/svgsheetmodeview.dart';
import 'package:zarandok_app_2/textmodeview.dart';
import 'package:zarandok_app_2/songdata.dart';


enum ViewMode { VM_IMAGE, VM_TEXT }

typedef void OnSongChangedCallback(SongData? song);

/// Controller for [VirtualPageView]
class VirtualPageController extends ChangeNotifier
{

  ViewMode _viewMode = ViewMode.VM_IMAGE;

  SongData? pageToJump;

  SongData? currentSong;

  set viewMode(ViewMode value)
  {
    _viewMode = value;
    notifyListeners();
  }
  ViewMode get viewMode
  {
    return _viewMode;
  }


  void jumpTo(SongData pageData)
  {
    pageToJump = pageData;
    notifyListeners();
  }
}

class VirtualPageView extends StatefulWidget
{

  VirtualPageController controller;
  OnSongChangedCallback callback;
  VirtualPageView(this.controller, this.callback);

  @override
  State<StatefulWidget> createState() {
    return VirtualPageViewState(controller, callback);
  }
}

class VirtualPageViewState extends State<VirtualPageView>
{

  ViewMode viewMode = ViewMode.VM_IMAGE;

  SongData? pageToJump;

  PageController pageController = PageController();

  List<String> assetRoutes = [];

  List<SongData> pageDatas = [];

  bool enaSnap = true;

  VirtualPageController controller;
  OnSongChangedCallback songChangedCallback;

  VirtualPageViewState(this.controller, this.songChangedCallback)
  {

    controller?.addListener(this.onControllerEvent);

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

    songChangedCallback(null);

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
  
  void onControllerEvent()
  {
    setState(() {
      
      if(viewMode != controller.viewMode) {
        viewMode = controller.viewMode;
        switch(viewMode) {
          
          case ViewMode.VM_IMAGE:
            var p = pageController.page?.toInt();
            pageController.jumpToPage(pageDatas[p??0].page);
            break;
          case ViewMode.VM_TEXT:
            enaSnap = true;
            var ix = getForPage(pageController.page?.toInt()??0);
            pageController.jumpToPage(ix);
            break;
        }
      }
      if(pageToJump != controller.pageToJump)
        {
          pageToJump = controller.pageToJump;
          switch(viewMode) {
            case ViewMode.VM_IMAGE:
            pageController.jumpToPage(pageToJump?.page??0);
              break;
            case ViewMode.VM_TEXT:
            pageController.jumpToPage((pageToJump?.num??1)-1);
              break;
          }
        }
    });
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
    songChangedCallback(data);
  }

  @override
  Widget build(BuildContext context) {

    return PageView.builder(
        controller: pageController,
        itemCount: assetRoutes.length,
        onPageChanged: onPageChanged,
        physics: enaSnap ? PageScrollPhysics() : NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, i){
          return viewMode == ViewMode.VM_IMAGE ? SvgSheetModeView(assetRoutes[i],
                  (v){
                    setState(() {
                      enaSnap = !v;
                    });
                  },
                  ) : TextModeView(pageDatas[i]);
        });

  }

}