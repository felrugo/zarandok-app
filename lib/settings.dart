// Copyright(c) Szabó Bálint 2023-2026
// Usage controlled by the GPLv3 LICENSE file in the root of the repository

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarandok_app_2/models.dart';

/// Model for the Settings, stored in the SharedPrefs, currently WIP.
/// Has its provider [IculoSettingsProvider]
class IculoSettingsModel extends ChangeNotifier {


  bool _verticalScroll = false;
  SharedPreferences? prefs;

  IculoSettingsModel() {
    SharedPreferences.getInstance().then((v) {
      prefs = v;
      _verticalScroll = prefs?.getBool("verticalScroll") ?? false;
      notifyListeners();
    });
  }



  /// Gets wether vertical scrolling is enabled. False means horizontal scrolling is selected.
  bool get verticalScroll {
    return _verticalScroll;
  }

  /// Sets/enables vertical scrolling on the main screen
  set verticalScroll(bool v) {
    _verticalScroll = v;
    prefs?.setBool("verticalScroll", v);
    notifyListeners();
  }


  /// Provider method
  static IculoSettingsModel? maybeOf(BuildContext context) {
    var provider = IculoSettingsProvider.maybeOf(context);
    return provider?.settingsModel;
  }

  /// Provider method
  static IculoSettingsModel of(BuildContext context) {
    var provider = IculoSettingsProvider.of(context);
    return provider.settingsModel;
  }
}

/// Provider for the [IculoSettingsModel]
class IculoSettingsProvider extends InheritedWidget {

  final IculoSettingsModel settingsModel;


  IculoSettingsProvider({required super.child, required this.settingsModel});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static IculoSettingsProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<IculoSettingsProvider>();
  }

  static IculoSettingsProvider of(BuildContext context) {
    return maybeOf(context)!;
  }

}

/// View for the Settings, currently WIP
class IculoSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IculoSettingsState();
  }
}

/// [State] for the [IculoSettings] widget.
class IculoSettingsState extends State<IculoSettings> {

  IculoSettingsModel? settings;

  void settingsChanged() {
    setState(() {

    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    settings = IculoSettingsModel.of(context);
    settings?.addListener(this.settingsChanged);

  }

  @override
  void didUpdateWidget(covariant IculoSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // Remove listener on dispose
    settings?.removeListener(this.settingsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    var bundle = ZarandokAppBundle.of(context);
    var app_icon = SvgPicture.asset("assets/svgs/icons/app_icon_bg.svg", fit: BoxFit.cover, height: 100.0);

    return Scaffold(
      appBar: AppBar(title: Text("Beállítások"),),
      body: Column(children: [
        Container(height: 300.0, child: Center( child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
          ClipRRect(borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),child: app_icon, ),

          Text("ZarandokApp", style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),),
          Text(bundle.version),
          Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            // Licenses button
            TextButton(onPressed: () {
              showLicensePage(
                  context: context,
                  applicationName: "ZarandokApp",
                  applicationVersion: bundle.version,
                  applicationIcon: ClipRRect(borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),child: app_icon, )
              );
            }, child: Text("Liszenszek")),

            // Issues button
            TextButton(onPressed: () {
              launchUrl(Uri.parse("https://github.com/felrugo/zarandok-app/issues/new"));
            }, child: Text("Hibajelentés"), style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.red), overlayColor: WidgetStateProperty.all(Color.fromRGBO(255, 0, 0, 0.1))),),
          ]),
        ]),)),

      // Settings parameters goes here
      ListTile(leading: Icon(Icons.compare_arrows), title: Text("Vertikális lapozás"), subtitle: Text("A vertikális lapozás engedélyezése a főképernyőn"), onTap: (){
        if (settings != null) {
          settings?.verticalScroll = !(settings?.verticalScroll ?? false);
        }
      }, trailing: Checkbox(value: settings?.verticalScroll ?? false, onChanged: (v){
        if (settings != null) {
          settings?.verticalScroll = v ?? false;
        }
      }),)

      ],),
    );
  }

}