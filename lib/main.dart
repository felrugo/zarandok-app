// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zarandok_app_2/booklet.dart';
import 'package:zarandok_app_2/models.dart';
import 'package:zarandok_app_2/settings.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

void main() => runApp(ZarandokApp());

/// Entrypoint of the App
class ZarandokApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ZarandokAppState();
  }
}

/// [State] for [ZarandokApp]
/// Shows a loading screen until the bundle is loaded
class ZarandokAppState extends State<ZarandokApp> {
  ZarandokAppBundle? bundle;

  /// Builds the full app
  Widget buildAppReady(BuildContext context) {
    var app = MaterialApp(
        title: 'ZarandokApp',
        scrollBehavior: AppScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BookletView());
    var settings = IculoSettingsModel();
    return ZarandokAppBundleProvider(bundle!,
        child: IculoSettingsProvider(child: app, settingsModel: settings));
  }

  /// Builds a loading screen
  Widget buildLoadingScreen(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (bundle != null) {
      // The bundle is loaded, load the full app
      return buildAppReady(context);
    } else {
      // Need to load bundle
      loadBundle().then((value) {
        setState(() {
          bundle = value;
        });
      });
      return buildLoadingScreen(context);
    }
  }
}
