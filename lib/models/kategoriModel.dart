// ignore_for_file: public_member_api_docs, sort_constructors_first
class Kategori {
  int? KategorID;
  String? KategorName;

  Kategori({this.KategorName}); //db eklerken kullan
  Kategori.withID(this.KategorID, this.KategorName); //dbden okurken

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['KategoriID'] = KategorID;
    map['KategoriName'] = KategorName;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    this.KategorID = map['KategoriID'];
    this.KategorName = map['KategoriName'];
  }
  @override
  String toString() {
    return 'Kategori{KategorID:$KategorID, KategoriName:$KategorName}';
  }
}
