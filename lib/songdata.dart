
/// Model class contains information for a song.
class SongData
{

  String title = "";
  int num = 0;
  int page = 0;
  List<String> lyrics = [];

  /// From JSON constructor
  SongData.fromJson(Map<String, dynamic> json)
  {
    this.title = json["title"];
    this.num = json["num"];
    this.page = json["page"];
    this.lyrics = [];
    if(json["lyrics"] is List<dynamic>)
      {
        List<dynamic> l = json["lyrics"];
        l.forEach((e){
          if(e is String)
            {
              lyrics.add(e as String);
            }
        });
      }
  }
}