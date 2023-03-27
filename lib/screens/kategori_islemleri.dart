import 'package:flutter/material.dart';
import 'package:flutter_notepadapp/models/kategoriModel.dart';
import 'package:flutter_notepadapp/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({super.key});

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  late List<Kategori> tumkategoriler;
  late DatabaseHelper databaseHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
    tumkategoriler = <Kategori>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kategoriler")),
      body: FutureBuilder(
        future: databaseHelper.kategoriListGetir(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            tumkategoriler = snapshot.data!;
            return ListView.builder(
              itemCount: tumkategoriler.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => _katogeriGuncelle(tumkategoriler[index]),
                  title: Text(tumkategoriler[index].KategorName.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      databaseHelper.KatoegoriDelete(
                              tumkategoriler[index].KategorID!)
                          .then((value) {
                        if (value != 0) {
                          setState(() {
                            Navigator.pop(context);
                          });
                        }
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  _katogeriSil(int? kategorID) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Kategori Sil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Bu Kategoriyle ilgili tüm notlar silinecek"),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Vazgeç", style: TextStyle(fontSize: 18)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.indigo)),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Sil", style: TextStyle(fontSize: 18)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.green)),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _katogeriGuncelle(Kategori guncellenecekKategori) {
    kategoriGuncelleDialog(context, guncellenecekKategori);
  }

  kategoriGuncelleDialog(BuildContext context, Kategori guncellenecekKategori) {
    var formkey = GlobalKey<FormState>();
    String? updateKategoriName;
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
                  initialValue: guncellenecekKategori.KategorName,
                  onSaved: (newValue) {
                    updateKategoriName = newValue!;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: "Kategori Adı",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (girilenKategoriAdi) {
                    if (girilenKategoriAdi!.length < 2) {
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
                        databaseHelper.KatoegoriUpdate(Kategori.withID(
                                guncellenecekKategori.KategorID,
                                updateKategoriName))
                            .then((value) {
                          if (value != 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Kategori Güncellendi"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                            setState(() {});
                          }
                        });
                      }
                    },
                    style: ButtonStyle(
                        fixedSize:
                            MaterialStateProperty.all(Size.fromWidth(100)),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.orange)),
                    child: Text("Güncelle")),
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
}
