

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';

class SvgSheetModeView extends StatelessWidget
{

  final String assetRoute;

  final ValueChanged<bool> onZoom;

  PhotoViewControllerValue? viewControllerValue = null;

  SvgSheetModeView(this.assetRoute, this.onZoom, {super.key});

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
    return Center(
        child: PhotoView.customChild(
          child: SvgPicture.asset("assets/svgs/12.svg"),
          backgroundDecoration: BoxDecoration(color: Colors.white),
          scaleStateChangedCallback: onScale,
          minScale: PhotoViewComputedScale.contained,
        )
    );
  }
  
}