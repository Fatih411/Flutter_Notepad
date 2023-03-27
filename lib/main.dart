import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_notepadapp/models/kategoriModel.dart';
import 'package:flutter_notepadapp/models/notModel.dart';
import 'package:flutter_notepadapp/screens/kategori_islemleri.dart';
import 'package:flutter_notepadapp/screens/not_detay.dart';
import 'package:flutter_notepadapp/utils/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: NotList(),
    );
  }
}

class NotList extends StatefulWidget {
  NotList({super.key});

  @override
  State<NotList> createState() => _NotListState();
}

class _NotListState extends State<NotList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: const Center(
          child: Text("Not Sepeti"),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.green.shade800,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    title: Text("Kategoriler"),
                    onTap: () {
                      _kategorilerSayfasinaGit(context);
                    },
                  ),
                ),
              ];
            },
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green.shade800,
            foregroundColor: Colors.white,
            heroTag: 'kategoriEkle',
            onPressed: () {
              kategoriEkleDialog(context);
            },
            tooltip: 'Kategori Ekle',
            child: Icon(Icons.import_contacts),
            mini: true,
          ),
          FloatingActionButton(
            backgroundColor: Colors.green.shade800,
            foregroundColor: Colors.white,
            heroTag: 'notEkle',
            onPressed: () => _detaySayfasinaGit(context),
            tooltip: 'Not Ekle',
            child: Icon(Icons.add),
          )
        ],
      ),
      body: Notlar(),
    );
  }

  kategoriEkleDialog(BuildContext context) {
    var formkey = GlobalKey<FormState>();
    String? newKategoriName;
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'Kategori Ekle',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (newValue) {
                    newKategoriName = newValue!;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: "Kategori Adı",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (girilenKategoriAdi) {
                    if (girilenKategoriAdi!.length < 3) {
                      return "En az 3 karakter giriniz";
                    }
                  },
                ),
              ),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        databaseHelper.KatoegoriAdd(
                                Kategori(KategorName: newKategoriName))
                            .then((KategoriId) {
                          if (KategoriId > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("kategori eklendi"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(Size.fromWidth(100)),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.orange)),
                    child: Text("Ekle")),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size.fromWidth(100)),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.indigo)),
                  child: Text("Vazgeç"),
                )
              ],
            )
          ],
        );
      },
    );
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                NotDetay(baslik: "Yeni Not"))).then((value) => setState(() {}));
  }

  _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => Kategoriler()))
        .then((value) => setState(
              () {},
            ));
  }
}

class Notlar extends StatefulWidget {
  const Notlar({super.key});

  @override
  State<Notlar> createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  late List<Not> tumnotlar;
  late DatabaseHelper databaseHelper;
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    tumnotlar = <Not>[];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapshot) {
        if (snapshot.hasData) {
          tumnotlar = snapshot.data!;
          sleep(Duration(milliseconds: 300));
          return ListView.builder(
            itemCount: tumnotlar.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: _oncelikIconuGoster(tumnotlar[index].NotOncelik),
                title: Text(tumnotlar[index].NotBaslik.toString()),
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Kategori ",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  tumnotlar[index].KategoriBaslik.toString(),
                                  style: TextStyle(fontSize: 22)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Oluşturulma Tarihi ",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  databaseHelper.dateFormat(DateTime.parse(
                                      tumnotlar[index].NotTarih.toString())),
                                  style: TextStyle(fontSize: 22)),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "İçerik : " +
                                  tumnotlar[index].NotIcerik.toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueGrey.shade400)),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _notSil(tumnotlar[index].NotID);
                              },
                              child: Text(
                                "Sil",
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      Size.fromWidth(100)),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.red)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _guncellemeSayfasinaGit(
                                    context, tumnotlar[index]);
                              },
                              child: Text("Güncelle",
                                  style: TextStyle(fontSize: 18)),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.indigo)),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        } else {
          return Center(
            child: Text("Yükleniyor..."),
          );
        }
      },
    );
  }

  _guncellemeSayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NotDetay(
                  baslik: "Notu Düzenle",
                  duzenlenecekNot: not,
                ))).then((value) => setState(() {}));
  }

  _oncelikIconuGoster(int? notOncelik) {
    if (notOncelik == 0) {
      return CircleAvatar(
        child: Text(
          "AZ",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.green,
      );
    } else if (notOncelik == 1) {
      return CircleAvatar(
        child:
            Text("Orta", style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.indigo,
      );
    } else {
      return CircleAvatar(
        child:
            Text("Acil", style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.redAccent.shade700,
      );
    }
  }

  void _notSil(int? notID) {
    databaseHelper.NotDelete(notID!).then((value) {
      if (value != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Not Silindi"),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {});
      }
    });
  }
}
