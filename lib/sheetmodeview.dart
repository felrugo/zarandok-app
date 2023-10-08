

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SheetModeView extends StatelessWidget
{

  final String assetRoute;

  final ValueChanged<bool> onZoom;

  SheetModeView(this.assetRoute, this.onZoom);

  void onScale(PhotoViewScaleState value) {
    switch(value)
    {
      case PhotoViewScaleState.initial:
      // TODO: Handle this case.
        break;
      case PhotoViewScaleState.covering:
      // TODO: Handle this case.
        break;
      case PhotoViewScaleState.originalSize:
      // TODO: Handle this case.
        break;
      case PhotoViewScaleState.zoomedIn:
        onZoom(true);
        break;
      case PhotoViewScaleState.zoomedOut:
        onZoom(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: PhotoView(
      imageProvider: AssetImage(assetRoute),
      scaleStateChangedCallback: onScale,
      backgroundDecoration: BoxDecoration(color: Colors.white),
      minScale: PhotoViewComputedScale.contained,
    ));
  }
  
}