# Praktek-M03

Pada contoh ini, kita akan mencoba menyertakan Sq(F)Lite dalam poryek kita. Jadi, di file pubspec.yaml/pubspec assist Anda, tambahkan dependensi, sebagai berikut :
```
sqflite:
```
Selain itu kita juga akan melakukan manipulasi path untuk mendaatkan lokasi path dari database yang akan dipergunakan. Untuk itu tambahkan juga dependensi berikut di pubspec.yaml Anda :
```
path:
```
Untuk memudahkan anda dalam menentukan versi dari Sqflite dan path, anda dapat tidak mendeklarasikan versi yang digunakan, pubspec.yaml akan menentukan versi terbaik untuk kedua library tersebut dapat anda gunakan.
Untuk memudahkan anda dalam membaca data terbaru, anda juga dapat menggunakan provider dalam memudahkan anda membaca data terbaru. Untuk itu tambahkan juga dependensi berikut di pubspec.yaml Anda :
```
provider: ^6.0.3
```
Setelah itu, anda dapat membangun tampilan front-end sebagai berikut, dimulai dari class. Untuk memodelkan database
### ShoppingList.dart
```
class ShoppingList {
  int id;
  String name;
  int sum;
  
  ShoppingList(this.id, this.name, this.sum);
  
  Map<String, dynamic> toMap() {
    return {'id': id, 'name':name, 'sum':sum};
  }
  
  @override
  String toString() {
    return "id : $id\nname : $name\nsum : $sum";
  }
}
```
kita akan memerlukan metode toMap() yang akan mengembalikan tipe data Map dengan key String, dan value dinamis. Map untuk key dengan tipe data string ini akan digunakan untuk meentukan kolom pada sebuah tabel, sedangkan value akan digunakan sebagai data yang akan diisi ke dalam tabel. Untuk tipe data dalam table dibuat menjadi dinamis, karena di dalam table, nilai tersebut dapat memiliki tipe yang berbeda.
Untuk memudahkan anda dalam mengupdate tampilan ui, anda dapat menggunakan provider sebagai berikut:
### MyProvider.dart
```
import 'package:flutter/material.dart';
import 'package:my_sql_db/PraktekM03/model/ShoppingList.dart';

class ListProductProvider extends ChangeNotifier {
  List<ShoppingList> _shoppingList = [];
  List<ShoppingList> get getShoppingList => _shoppingList;
  set setShoppingList(value) {
    _shoppingList = value;
    notifyListeners();
  }
  
  void deleteById(ShoppingList) {
    _shoppingList.remove(ShoppingList);
    notifyListeners();
  }
}
```
Jangan lupa untuk mendaftarkan provider anda pada kelas main anda
### MyProvider.dart
```
import 'package:flutter/material.dart';
import 'package:my_sql_db/PraktekM03/Provider/MyProvider.dart';
import 'package:my_sql_db/PraktekM03/Screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyAppp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  //This widget is the root of your aplication.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(),
      create: (context) => ListProductProvider(),
      child: MaterialApp(
        title: 'Flutter Demo';
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Screen(),
      ),
    );
  }
}
```
Rancanglah Front-End dari aplikasi seperti berikut ini
### Screen.dart
```
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_sql_db/PraktekM03/ItemsScreen.dart';
import 'package:my_sql_db/PraktekM03/model/ShoppingList.dart';
import 'package:my_sql_db/PraktekM03/ui/shopping_list_dialog.dart';
import 'package:provider/provider.dart';
import 'Provider/myProvider.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(ket: key);
  
  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int id = 0;
  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    return Scaffold(
      appbar: AppBar(
        title: const Text("Shopping List"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'DeleteAll',
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount:
            tmp.getShoppingList != null ? tmp.getShoppingList.length: 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(tmp.getShoppingList[index].id.toString()),
            onDismissed: (direction) {
              String tmpName = tmp.getShoppingList[index].name;
              int tmpId = tmp.getShoppingList[index].id;
              setState(() {
                tmp.deleteById(tmp.getShoppingList[index]);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$tmpName deleted"),
              }};
            },
            child: ListTile(
              title: Text(tmp.getShoppingList[index].name),
              leading: CircleAvatar(
                child: Text("${tmp.getShoppingList[index]sum}"),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return ItemsScreen(tmp.getShoppingList[index]);
                }));
              },
              trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ShoppingListDialog()
                            .buildDialog(context, ShoppingList(++id, "", 0), true);
                      });
                  }),
             ));
        }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return ShoppingListDialog()
                    .buildDialog(context, ShoppingList(++id, "", 0), true);
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
  
  @override
  void dispose() {
    super.dispose();
  }
}
```
### ItemScreen.dart
```
import 'package:flutter/material.dart';
import 'package:my_sql_db/PraktekM03/model/ShoppingList.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  ItemsScreen(this.shoppingList);
  
  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  _ItemsScreenState(this.shoppingList);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(shoppingList.name)));
  }
}
```
### shopping_list_dialog.dart
```
import 'package:flutter/material.dart';
import 'package:my_sql_db/PraktekM03/model/ShoppingList.dart';

class ShoppingListDialog {
  ShoppingListDialog();
  
  final txtName = TextEditingController();
  final txtSum = TextEditingController();
  
  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    if (!isNew) {
      txtName.text = list.name;
      txtSum.text = list.sum.toString();
    } else {
      txtName.text = "";
      txtSum.text = "";
    }
    return AlertDialog(
        title: Text((isNew) ? 'New shopping list' : 'Edit shopping list'),
        shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        content: SingleChildScrollView(
          child: Column(children: <Widget>[
            TextField(
                controller: txtName,
                decoration: InputDecoration(hinText: 'Shopping List Name')),
            TextField(
              controller: txtSum,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Sum'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Save Shopping List'),
                onPressed: () {
                  list.name = txtName.text != "" ? txtName.text : "Empty";
                  list.sum = txtSum.text != "" ? int.parse(txtSum.text) : 0:
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
        ));
  }
}
```
shopping_list_dialog.dart merupakan custom wiget yang anda dapat bangun untuk memudahkan anda dalam melakukan pengimputan data melalui dialog.
### Hasil:



Hasilnya, data belum dapat kita tampilkan pada tampilan front-end. Untuk itu kita akan mencoba menggunakan Sq(F)Lite untuk memproses data sehingga data dapat tersimpan secara permanen dan dapat diakses kembali meskipun aplikasi telah ditutup.

# Creating Database
1. Buat sebuah file dart baru bernama **dbhelper.dart**. File ini akan kita gunakan untuk menyimpan setiap perintah yang berkaitan dengan database. Di dalam file ini buat sebuah class baru bernama **DbHelper**. Pada proses pertama dalam operasi database Sqlite, anda diwajibkan untuk melakkan inisialisasi dan membuka database. Adapun insialisasi dan membuka database dapat menggunakan fungsi **openDatabase()**. Pada saat proses openDatabase() anda dapat mentriger sebuah event **onCreate()** untuk membentuk table yang terhubung dengan database anda. Atau anda dapat mecreate tabel secara terpisah.
```
import 'package:path/path.dart':
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _database;
  final String _table_name = "shopping_list";
  final String _db_name = "shopinglist_database";
  final int _db_version = 1;
  
  DBHelper() {
    _openDB();
  }
  
  Future<void> _openDB() async {
    // penghapusan database digunakan, ketika anda sudah membuat database,
    // dan ternyata terjadi perubah pada table
    // await deleteDatabase(
    //     join(await getDatabasePath(), 'shopinglist_database.db'));
    _database ??= await openDatabase(
      join(await getDabasesPath(), _db_name),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_table_name (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER)',
        );
      },
      version: _db_version,
    );
  }
}
```
2. Sampai tahap ini, anda belum membuat database. Untuk memerintahkan program anda membentuk database, maka pada **screen.dart** inisiasikan sebuah variabel helper untuk mengakses class DBHelper. Ketika inisialisasi dilakukan, maka anda telah mengaktifkan sebuah database yang dapat anda gunakan. Pastikan setiap database yang terbuka harus ditutup pada **akhir program**.
```
class _ScreenState extends State<Screen> {
  int id = 0;
  DBHelper _dbHelper = DBHelper();
  @override
    Widget build(BuildContext context) {
```
# Insert Data
1. Pada dbhelper.dart, tambahkan sebuah fungsi untuk melakukan penambahan list data ke dalam database.
```
  Future<void> insertShoppingList(ShoppingList tmp) async {
    await _database?.insert(
      'shopping_list',
      tmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replacem
    );
  }
```
2. Pada file shopping_list_dialog.dart, tambahkan perintah untuk menambahkan data ke dalam database pada widget Elevated Button dengna menggunakan helper database. Pastikan anda memberikan akses database pada kelas shopping_list_dialog, melalui constructor sehingga shopping_list_dialog.dart dituliskan sebagai berikut.
```
import 'package:flutter/material.dart';
import 'package:my_sql_db/PraktekM03/DB/dbHelper.dart';
import 'package:my_sql_db/PraktekM03/model/ShoppingList.dart';

class ShoppingListDialog {
  DBHelper _dbHelper;
  ShoppingListDialog(this._dbHelper);
  
  final txtName = TextEditingController();
  final txtSum = TextEditingController();
  
  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    if (!isNew) {
      txtName.text = list.name;
      txtSum.text = list.sum.toString();
    } elses {
      txtName.text = "";
      txtSum.text = "";
    }
    return AlertDialog(
        title: Text((isNew) ? 'New shoppinglist' : 'Edit shopping list'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        content: SingleChildScrollView(
          child: Column(children: <widget>[
            TextField(
                controller: txtName,
                decoration: InputDecoration(hintText: 'Shopping List Name')),
            TextField(
              controller: txtSum,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Sum'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Save Shopping List'),
                onPressed: () {
                  list.name = txtName.text != ""? txtName.text : "Empty";
                  list.syn = txtSum.text != ""? int.parse(txtSum.text) : 0;
                  _dbHelper.insertShoppingList(list);
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
        ));
 }
}
```
3. Sebelum dapat menjalankan perintah insert ini, pastikan anda mengubah pemanggilan fungsi ShoppingListDialog() pada screen.dart menjad ShoppingListDialog(_dbHelper).
```
                  trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ShoppingListDialog(_dbHelper).buildDialog(
                                  context, tmp.getShoppingListp[index], false);
                            });
                      }),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return ShoppingListDialog(_dbHelper)
                    .buildDialog(context, ShoppingList(++id, "", 0), true);
              )};
        },
        child: Icon(Icons.add),
      ),
    );
  }
```
# Select/Read Data
1. Setelah berhasil memasukkan data, anda pasti ingin melihat hasilnya untuk muncul pada screen anda. Oleh karena itu, kita akan menggunakan bantuan provider dan dbhelper, untuk menampilkan data yang telah berhasil di tambahkan. Tambahkanlah sebuah fungsi untuk melakukan pembacaan data dari database.
```
  Future<List<ShoppingList>> getmyShopingList() async {
    if(_database != null) {
      final List<Map<String, dynamic>> maps =
          await _database!.query('shopping_list');
      print("Isi DB"
