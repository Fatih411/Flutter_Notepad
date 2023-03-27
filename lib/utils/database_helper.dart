import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notepadapp/models/kategoriModel.dart';
import 'package:flutter_notepadapp/models/notModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }
  DatabaseHelper._internal();
  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initalizeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database> _initalizeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "appDB.db");
    print("oluşan path:" + path);
    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets/Db", "notlar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("veri tabanı açıldı");
    }
    return await openDatabase(path, readOnly: false);
  }

  //kategoriler ile ilgili sorgular
  Future<List<Map<String, dynamic>>> allkategori() async {
    var db = await _getDatabase();
    var sonuc = await db.query("kategori");
    return sonuc;
  }

  Future<List<Kategori>> kategoriListGetir() async {
    var kategorileriIcerenMap = await allkategori();
    var kateogriListesi = <Kategori>[];
    for (var map in kategorileriIcerenMap) {
      kateogriListesi.add(Kategori.fromMap(map));
    }
    print("database kate list:" + kateogriListesi.length.toString());
    return kateogriListesi;
  }

  Future<int> KatoegoriAdd(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("kategori", kategori.toMap());
    return sonuc;
  }

  Future<int> KatoegoriUpdate(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.update("kategori", kategori.toMap(),
        where: 'KategoriID=?', whereArgs: [kategori.KategorID]);
    return sonuc;
  }

  Future<int> KatoegoriDelete(int kategoriID) async {
    var db = await _getDatabase();
    var sonuc = await db
        .delete("kategori", where: 'KategoriID = ?', whereArgs: [kategoriID]);
    return sonuc;
  }

  //notlar ile ilgili sorgular
  Future<List<Map<String, dynamic>>> allNotlar() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery(
        'SELECT * FROM "not" INNER JOIN kategori on kategori.KategoriID = "not".KategoriID order by NotID Desc;');
    return sonuc;
  }

  Future<List<Not>> notListesiniGetir() async {
    var notlarMapListesi = await allNotlar();
    var notListesi = <Not>[];
    for (var map in notlarMapListesi) {
      notListesi.add(Not.fromMap(map));
    }
    return notListesi;
  }

  Future<int> NotUpdate(Not notlar) async {
    var db = await _getDatabase();
    var sonuc = await db.update("not", notlar.toMap(),
        where: 'NotID = ?', whereArgs: [notlar.NotID]);
    return sonuc;
  }

  Future<int> NotDelete(int NotID) async {
    var db = await _getDatabase();
    var sonuc = await db.delete('not', where: 'NotID = ?', whereArgs: [NotID]);
    return sonuc;
  }

  Future<int> NotAdd(Not notlar) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("not", notlar.toMap());
    return sonuc;
  }

  String dateFormat(DateTime dateTime) {
    DateTime today = new DateTime.now();
    Duration oneday = new Duration(days: 1);
    Duration twoday = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String? month;
    switch (dateTime.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 7:
        month = "Eylül";
        break;
      case 7:
        month = "Ekim";
        break;
      case 7:
        month = "Kasım";
        break;
      case 7:
        month = "Aralık";
        break;
    }
    Duration difference = today.difference(dateTime);
    if (difference.compareTo(oneday) < 1) {
      return "Bugün";
    } else if (difference.compareTo(twoday) < 1) {
      return "Dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (dateTime.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
      }
    } else if (dateTime.year == today.year) {
      return "${dateTime.day} $month";
    } else {
      return "${dateTime.day} $month ${dateTime.year}";
    }
    return "";
  }
}
