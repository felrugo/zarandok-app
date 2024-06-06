// Copyright(c) Szabó Bálint 2023-2024
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'dart:collection';
import 'dart:core';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zarandok_app_2/textmodeview.dart';
import 'package:zarandok_app_2/songdata.dart';

/// Enum for differentiate the Sheet and Chords view mode of the main PageView of the application.
enum ViewMode { Sheet, Chords }

/// Typedef for Song Change events. The argument must be the new song.
typedef OnSongChangedCallback = void Function(SongData? song);

/// Value class for the [VirtualPageController] caontaining the current song and view mode.
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

/// Controller for [VirtualPageView].
/// Supports logical navigation between the pages of the [VirtualPageView].
class VirtualPageController extends ValueNotifier<VirtualPageValue>
{
  /// Constructor for [VirtualPageController] with an initial song.
  VirtualPageController.fromSong(SongData song) : super(VirtualPageValue(song, ViewMode.Sheet));

  /// The current song of the [VirtualPageView].
  SongData get currentSong {
    return value.song;
  }

  /// Make the controlled [VirtualPageView] jump to the given song.
  void jumpTo(SongData pageData)
  {
    value = VirtualPageValue(pageData, value.viewMode);
  }

  /// Switches between the view modes.
  void toggleViewMode() {
    switch(value.viewMode) {
      case ViewMode.Sheet:
        value = VirtualPageValue(value.song, ViewMode.Chords);
      case ViewMode.Chords:
        value = VirtualPageValue(value.song, ViewMode.Sheet);
    }
  }

}

/// An extended [PageView] creating the main view of the application.
/// The main application of this widget is to enable switching between the
/// sheet and chords view mode but it also supports zooming and panning of the sheets
/// and altogether emulating the feeling of sliding the pages of the paper-based songbook
class VirtualPageView extends StatefulWidget
{
  /// [VirtualPageController] for the view
  final VirtualPageController controller;
  /// Callback to notify on song change
  final OnSongChangedCallback? songChangedCallback;

  /// Initial [ViewMode] for the view
  final ViewMode viewMode;

  /// Constructor with initial view mode and controller
  VirtualPageView(this.viewMode, this.controller, this.songChangedCallback, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _VirtualPageViewState();
  }
}

/// State of the [VirtualPageView] widget.
class _VirtualPageViewState extends State<VirtualPageView>
{
  /// Controller for the encapsulated [PageView].
  PageController pageController = PageController();

  /// Controller for the encapsulated [InteractiveViewer]
  TransformationController transformationController = TransformationController();

  /// Flag for the pageview to disable scroll when the InteractiVievewer is zoomed.
  bool zoomed = false;

  late VirtualPageController controller;
  late OnSongChangedCallback? changedCallback;

  late SongDatabase database;

  late VirtualPageValue ctrlValue;

  ViewMode get viewMode {
    return ctrlValue.viewMode;
  }

  /// Called when the controller value changed aka. the view need to jump to the page of the new song
  /// and adapt the requested viewmode
  void onControllerChange() {
    if(controller.value == ctrlValue) // No change -> return
      return;
    else
      ctrlValue = controller.value; // save new value

    setState(() {
      transformationController.value.setIdentity();
      zoomed = false; // Every page jump or viewmode change results in zooming out to full scale

      switch(viewMode) {
        case ViewMode.Sheet:
          pageController.jumpToPage(controller.currentSong.page);
          break;
        case ViewMode.Chords:
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
    database = SongDatabase.of(context); // refresh database, optional
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


    transformationController.value.setIdentity(); // execute zoom out
    zoomed = false;
    switch(viewMode) {
      case ViewMode.Sheet:
        pageController.jumpToPage(controller.currentSong.page);
        break;
      case ViewMode.Chords:
        pageController.jumpToPage((controller.currentSong.num)-1);
        break;
    }

  }

  /// Called when the [PageView] scrolls
  onPageChanged(int page)
  {
    var pageDatas = database.songs;
    SongData? data;
    if (viewMode == ViewMode.Sheet)
    {
      data = database.getPageDataByPage(page);
    }
    else
    {
      data = pageDatas.firstWhere((element){
        return page == element.num-1;
      }, orElse: ()=>pageDatas.first);
    }

    ctrlValue = VirtualPageValue(data, viewMode); // Update the value based on the destination song
    controller.value = ctrlValue; // Update the controller (Two-way binding). This will results in a call to
                                  // onControllerChange but will return due to equality.
  }

  Widget dynamicImage(int page) {
    var assetRoutes = database.assetRoutes;

    if(page < assetRoutes.length) {
      return Image.asset(assetRoutes[page]);
    }
    else if(page - assetRoutes.length < 9) {
      return SvgPicture.asset("assets/svgs/portrait/${page-assetRoutes.length+1}.svg");
    }
    return SizedBox();
  }


  @override
  Widget build(BuildContext context) {

    var pageDatas = database.songs;
    var assetRoutes = database.assetRoutes;

    switch(viewMode) {

      case ViewMode.Sheet:
        return PageView.builder(
            controller: pageController,
            itemCount: assetRoutes.length+9,
            onPageChanged: onPageChanged,
            physics: !zoomed ? PageScrollPhysics() : NeverScrollableScrollPhysics(), // Disable scroll when zoomed
            itemBuilder: (ctx, i){
              return InteractiveViewer(
                constrained: true,
                scaleEnabled: true,
                panEnabled: zoomed, // Only when zoomed
                transformationController: transformationController,
                minScale: 1.0,
                maxScale: 10.0,
                onInteractionUpdate: (details) {
                  double correctScale = transformationController.value.getMaxScaleOnAxis();
                  setState(() {
                    zoomed = ! ( correctScale <= (1.0 + 0.01) );
                  });
                },
                child: dynamicImage(i),
              );
            });
      case ViewMode.Chords:
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