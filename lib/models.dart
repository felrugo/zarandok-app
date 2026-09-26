// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader, rootBundle;
import 'package:iculo/model.dart';

/// An [IculoBundle] derivative to handle to handle the provider pattern.
class ZarandokAppBundle extends IculoBundle {

  /// Keeps the [fromMap] method from the base.
  ZarandokAppBundle.fromMap(Map<String, dynamic> data) : super.fromMap(data) {
    
  }

  /// Provider pattern.
  static of(BuildContext context) {
    var provider = ZarandokAppBundleProvider.of(context);
    return provider.bundle;
  }
}

/// Provider for the ZarandokApp bundle ([ZarandokAppBundle])
class ZarandokAppBundleProvider extends InheritedWidget {

  ZarandokAppBundle _bundle;

  ZarandokAppBundle get bundle {
    return _bundle;
  }

  ZarandokAppBundleProvider(this._bundle, {required super.child});

  static ZarandokAppBundleProvider? maybeOf(BuildContext context) {
    ZarandokAppBundleProvider? ret = context.dependOnInheritedWidgetOfExactType<ZarandokAppBundleProvider>();
    return ret;
  }

  static ZarandokAppBundleProvider of(BuildContext context) {
    final ZarandokAppBundleProvider? result = maybeOf(context);
    assert(result != null, 'No ZarandokAppBundleProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

/// An async function to load the [ZarandokAppBundle].
Future<ZarandokAppBundle> loadBundle() async {
  // Load Roboto
  var loader = FontLoader("RobotoSlab");
  loader.addFont(rootBundle.load("fonts/RobotoSlab-Regular.ttf"));
  await loader.load();
  String data = await rootBundle.loadString("assets/bundle.json");
  dynamic decoded = jsonDecode(data);
  ZarandokAppBundle ret = ZarandokAppBundle.fromMap(decoded);
  return ret;
}