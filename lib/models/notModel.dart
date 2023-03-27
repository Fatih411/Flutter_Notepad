// ignore_for_file: public_member_api_docs, sort_constructors_first
class Not {
  int? NotID;
  int? KategoriID;
  String? KategoriBaslik;
  String? NotBaslik;
  String? NotIcerik;
  String? NotTarih;
  int? NotOncelik;
  //verileri yazarken
  Not({
    this.KategoriID,
    this.NotBaslik,
    this.NotIcerik,
    this.NotTarih,
    this.NotOncelik,
  });
//verileri okurken
  Not.withID(
    this.NotID,
    this.KategoriID,
    this.NotBaslik,
    this.NotIcerik,
    this.NotTarih,
    this.NotOncelik,
  );
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['NotID'] = NotID;
    map['KategoriID'] = KategoriID;
    map['NotBaslik'] = NotBaslik;
    map['NotIcerik'] = NotIcerik;
    map['NotTarih'] = NotTarih;
    map['NotOncelik'] = NotOncelik;
    return map;
  }

  Not.fromMap(Map<String, dynamic> map) {
    this.NotID = map['NotID'];
    this.KategoriID = map['KategoriID'];
    this.KategoriBaslik = map['KategoriName'];
    this.NotBaslik = map['NotBaslik'];
    this.NotIcerik = map['NotIcerik'];
    this.NotTarih = map['NotTarih'];
    this.NotOncelik = map['NotOncelik'];
  }
  @override
  String toString() {
    return 'Not{NotID:$NotID,KategorID:$KategoriID,NotBaslik:$NotBaslik,NotIcerik:$NotIcerik,NotTarih:$NotIcerik,NotTarih:$NotTarih,NotOncelik:$NotOncelik}';
  }
}
