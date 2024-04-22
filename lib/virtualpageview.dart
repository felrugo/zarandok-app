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

class VirtualPageValue {
  SongData song;
  ViewMode viewMode;

  VirtualPageValue(this.song, this.viewMode);

  @override
  bool operator ==(Object other) {
    if(other is VirtualPageValue)
    {
      return song == other.song && viewMode == other.viewMode;
    }
    return false;
  }

}

/// Controller for [VirtualPageView]
class VirtualPageController extends ValueNotifier<VirtualPageValue>
{

  VirtualPageController.fromSong(SongData song) : super(VirtualPageValue(song, ViewMode.VM_IMAGE));

  SongData get currentSong {
    return value.song;
  }

  void jumpTo(SongData pageData)
  {
    value = VirtualPageValue(pageData, value.viewMode);
  }

  void toggleViewMode() {
    switch(value.viewMode) {
      case ViewMode.VM_IMAGE:
        value = VirtualPageValue(value.song, ViewMode.VM_TEXT);
      case ViewMode.VM_TEXT:
        value = VirtualPageValue(value.song, ViewMode.VM_IMAGE);
    }
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
  bool zoomed = false;

  late VirtualPageController controller;
  late OnSongChangedCallback? changedCallback;

  late SongDatabase database;

  late VirtualPageValue ctrlValue;

  ViewMode get viewMode {
    return ctrlValue.viewMode;
  }


  void onControllerChange() {
    if(controller.value == ctrlValue)
      return;
    else
      ctrlValue = controller.value;

    setState(() {
      transformationController.value.setIdentity();
      zoomed = false;

      switch(viewMode) {
        case ViewMode.VM_IMAGE:
          pageController.jumpToPage(controller.currentSong.page);
          break;
        case ViewMode.VM_TEXT:
          pageController.jumpToPage((controller.currentSong.num)-1);
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    controller = widget.controller;
    changedCallback = widget.songChangedCallback;
    ctrlValue = controller.value;

    controller.addListener(onControllerChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    database = SongDatabase.of(context);
  }

  @override
  void didUpdateWidget(covariant VirtualPageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    controller = widget.controller;
    changedCallback = widget.songChangedCallback;
    ctrlValue = controller.value;

    if(controller != oldWidget.controller) { // Reinit callback
      oldWidget.controller.removeListener(onControllerChange);
      controller.addListener(onControllerChange);
    }


    transformationController.value.setIdentity();
    zoomed = false;
    switch(viewMode) {
      case ViewMode.VM_IMAGE:
        pageController.jumpToPage(controller.currentSong.page);
        break;
      case ViewMode.VM_TEXT:
        pageController.jumpToPage((controller.currentSong.num)-1);
        break;
    }

  }

  
  onPageChanged(int page)
  {
    var pageDatas = database.songs;
    SongData? data;
    if (viewMode == ViewMode.VM_IMAGE)
    {
      data = database.getPageDataByPage(page);
    }
    else
    {
      data = pageDatas.firstWhere((element){
        return page == element.num-1;
      }, orElse: ()=>pageDatas.first);
    }

    ctrlValue = VirtualPageValue(data, viewMode);
    controller.value = ctrlValue;
  }


  @override
  Widget build(BuildContext context) {

    var pageDatas = database.songs;
    var assetRoutes = database.assetRoutes;

    switch(viewMode) {

      case ViewMode.VM_IMAGE:
        return PageView.builder(
            controller: pageController,
            itemCount: assetRoutes.length,
            onPageChanged: onPageChanged,
            physics: !zoomed ? PageScrollPhysics() : NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i){
              return InteractiveViewer(
                constrained: true,
                scaleEnabled: true,
                panEnabled: zoomed,
                transformationController: transformationController,
                minScale: 1.0,
                maxScale: 10.0,
                onInteractionUpdate: (details) {
                  double correctScale = transformationController.value.getMaxScaleOnAxis();
                  setState(() {
                    zoomed = ! ( correctScale <= (1.0 + 0.01) );
                  });
                },
                child: Image.asset(assetRoutes[i]),
              );
            });
      case ViewMode.VM_TEXT:
        return PageView.builder(
            controller: pageController,
            itemCount: pageDatas.length,
            onPageChanged: onPageChanged,
            physics: PageScrollPhysics(),
            itemBuilder: (ctx, i) {
               return TextModeView(pageDatas[i]);
            });
    }
  }
}