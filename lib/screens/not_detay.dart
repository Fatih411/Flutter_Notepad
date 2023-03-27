import 'package:flutter/material.dart';
import 'package:flutter_notepadapp/main.dart';
import 'package:flutter_notepadapp/models/kategoriModel.dart';
import 'package:flutter_notepadapp/models/notModel.dart';
import 'package:flutter_notepadapp/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  String? baslik;
  Not? duzenlenecekNot;
  NotDetay({Key? key, this.baslik, this.duzenlenecekNot}) : super(key: key);

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formkey = GlobalKey<FormState>();
  late List<Kategori> tumkategoriler;
  late DatabaseHelper databaseHelper;
  int? kategoriID;
  int? secilenOncelik;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];

  late String notBaslik, notIcerik;

  @override
  void initState() {
    super.initState();
    tumkategoriler = <Kategori>[];
    databaseHelper = DatabaseHelper();
    databaseHelper.allkategori().then((kateIcerik) {
      for (var element in kateIcerik) {
        tumkategoriler.add(Kategori.fromMap(element));
      }
      if (widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot!.KategoriID;
        secilenOncelik = widget.duzenlenecekNot!.NotOncelik;
      } else {
        kategoriID = 1;
        secilenOncelik = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.baslik!),
          actions: [],
        ),
        body: tumkategoriler.length < 1
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Kategori :',
                              style: TextStyle(fontSize: 28),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 60),
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.green, width: 1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    items: _kategorItemleriOlustur(),
                                    value: kategoriID,
                                    onChanged: (secilenkategoriID) {
                                      setState(() {
                                        kategoriID = secilenkategoriID!;
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: widget.duzenlenecekNot != null
                                ? widget.duzenlenecekNot!.NotBaslik
                                : "",
                            validator: (text) {
                              if (text!.length < 2) {
                                return "En az 3 karakter olmalı";
                              }
                            },
                            onSaved: (newValue) {
                              notBaslik = newValue!;
                            },
                            decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                hintText: 'Not Başlığını Giriniz',
                                hintStyle: TextStyle(color: Colors.white),
                                labelText: 'Başlık',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: widget.duzenlenecekNot != null
                                ? widget.duzenlenecekNot!.NotIcerik
                                : "",
                            onSaved: (newValue) {
                              notIcerik = newValue!;
                            },
                            maxLines: 5,
                            decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                hintText: 'Not İçerik Giriniz',
                                hintStyle: TextStyle(color: Colors.white),
                                labelText: 'İçerik',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Öncelik :',
                              style: TextStyle(fontSize: 22),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 40),
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.green, width: 1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                items: _oncelik.map((oncelik) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      oncelik,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    value: _oncelik.indexOf(oncelik),
                                  );
                                }).toList(),
                                value: secilenOncelik,
                                onChanged: (int? secOnce) {
                                  setState(() {
                                    secilenOncelik = secOnce!;
                                  });
                                },
                              )),
                            ),
                          ],
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Vazgeç"),
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      Size.fromWidth(100)),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.orange)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();
                                  var suan = DateTime.now();
                                  if (widget.duzenlenecekNot == null) {
                                    databaseHelper.NotAdd(Not(
                                            KategoriID: kategoriID,
                                            NotBaslik: notBaslik,
                                            NotIcerik: notIcerik,
                                            NotTarih: suan.toString(),
                                            NotOncelik: secilenOncelik))
                                        .then((value) {
                                      if (value != 0) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    databaseHelper.NotUpdate(Not.withID(
                                            widget.duzenlenecekNot!.NotID,
                                            kategoriID,
                                            notBaslik,
                                            notIcerik,
                                            suan.toString(),
                                            secilenOncelik))
                                        .then((guncellenenID) => {
                                              if (guncellenenID != 0)
                                                {
                                                  Navigator.pop(context),
                                                }
                                            });
                                  }
                                }
                              },
                              child: Text("Kaydet"),
                              style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                      Size.fromWidth(100)),
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.indigo)),
                            )
                          ],
                        )
                      ],
                    )),
              ));
  }

  List<DropdownMenuItem<int>> _kategorItemleriOlustur() {
    return tumkategoriler
        .map((kategori) => DropdownMenuItem<int>(
            value: kategori.KategorID,
            child: Text(
              "${kategori.KategorName}",
              style: TextStyle(fontSize: 18),
            )))
        .toList();
  }
}
/* Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: tumkategoriler.length < 1
                  ? Center(child: Text("Bekle"))
                  : DropdownButton<int>(
                      items: _kategorItemleriOlustur(),
                      value: kategoriID,
                      onChanged: (secilenkategoriID) {
                        setState(() {
                          kategoriID = secilenkategoriID!;
                        });
                      }),
            ),
          ],
        ),
      ), */