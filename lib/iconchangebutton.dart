// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/material.dart';
import 'package:zarandok_app_2/tableofcontents.dart';

/// Widget used in the search and in the [TableOfContentsView] widget.
/// Used to draw an icon button that changes its icon when hovered.
class IconChangeButton extends StatefulWidget {
  final Widget icon;
  final Widget hoverIcon;
  final double? iconSize;
  final VoidCallback onPressed;

  /// Contructor for the [IconChangeButton]
  /// [icon] is the base icon it shows when not hovered. On hover it changes to [hoverIcon].
  /// It can react to click events by the [onPressed] callback.
  /// Also the icon size can be controlled by [iconSize]
  const IconChangeButton({super.key, required this.icon, required this.hoverIcon, required this.onPressed, this.iconSize = 20.0});


  @override
  State<StatefulWidget> createState() {
    return _IconChangeButtonState();
  }

}

class _IconChangeButtonState extends State<IconChangeButton> {

  bool pointerHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: IconButton(onPressed: widget.onPressed, icon: pointerHover ? widget.hoverIcon : widget.icon, hoverColor: const Color.fromARGB(0, 0, 0, 0)),
      onEnter: (event) {
        setState(() {
          pointerHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          pointerHover = false;
        });
      },
    );
  }

}