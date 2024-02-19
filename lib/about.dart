import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Widget of the About page.
class AboutPage extends StatelessWidget
{

  final String _gitHubURL = "https://github.com/felrugo/zarandok-app";
  final String _meviszText = "A Magyarországi Evangélikus Ifjúsági Szövetség, röviden Mevisz, 1989-ben alakult. Ahogy a neve is mutatja, elsősorban evangélikus egyházi kötődéssel rendelkező fiatalokból áll a tagsága, bár ez egyáltalán nem elvárás a tagok felé. Célja, hogy olyan szociális, lelki és vallásos szolgálatot végezzen, amire az egyház lehetőségei nem terjednek ki. Jelenleg, három évtized elteltével, az úgynevezett Bárka szakcsoport a legjelentősebb. Ennek önkéntes tagjai olyan mozgásukban korlátozott emberekkel járnak együtt nyaralni, akiknek máshogy nem lenne erre lehetőségük. Ezek a közös nyári alkalmak körülbelül egyhetesek, és egy táborban 30-50 fő vesz részt. A Mevisznek van egy könnyűzenei szakcsoportja is. Munkájuk hatására született meg és került kiadásra két egyházi, ifjúsági énekeskönyv, az „Új Ének” és a „Zarándokének”. A Zarándokének online, ingyenes applikációját nyitotta meg a kedves olvasó. A Mevisz nevében kívánjunk, hogy használja örömmel, nyitott szívvel, jó hangulattal és kedves barátokkal! Hiszen azért születtek és lettek összegyűjtve ezek az énekek, hogy énekeljük őket. Dicsérjük Istent!";
  final String _version = "1.0.3";

  const AboutPage({super.key});

  /// Builds the Dialog for the content of the Mevisz.
  void _showMeviszText(BuildContext context)
  {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("A Meviszről"),
          content: SingleChildScrollView(child: Text(_meviszText),),
          actions: <Widget>[
            OutlinedButton(
              child: Text('Bezárás'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  /// Create a bowser tab and opens the url
  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rólunk")),
      body: ListView(itemExtent: 50.0, children: <Widget>[
        ListTile(title: Text("ZarándokApp"), subtitle: Text(_version), leading: FlutterLogo(),),
        Center(child: Text("Közreműködők",style: TextStyle(fontSize: 16.0),)),
        ListTile(title: Text("Takács László"), subtitle: Text("Project alapító és asszetek"), leading: FlutterLogo(),),
        ListTile(title: Text("Szabó Bálint"), subtitle: Text("Vezető fejlesztő"), leading: FlutterLogo(),),
        ListTile(title: Text("Grendorf Melinda"), subtitle: Text("Asszetek és tesztelés"), leading: FlutterLogo(),),
        ListTile(title: Text("Szász Levente"), subtitle: Text("Asszetek és tesztelés"), leading: FlutterLogo(),),
        ListTile(title: Text("Kadlecsik Bajnok Bátor"), subtitle: Text("Asszetek"), leading: FlutterLogo(),),
        Center(child: Text("Elérhetőségek",style: TextStyle(fontSize: 16.0),)),
        ListTile(title: Text("Github Project"), subtitle: Text("Forráskód"), leading: Image.asset("assets/github_logo.png"), onTap: (){ _launchURL(_gitHubURL); },),
        ListTile(title: Text("Mevisz"), subtitle: Text("Zarándokének"), leading: Image.asset("assets/mevlogo.png"), onTap: (){ _showMeviszText(context); },),
      ],)
    );
  }
  
}