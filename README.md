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
    return ChangeNotifierProvider(
      create: (context) => ListProductProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
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
import 'Provider/MyProvider.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);
  
  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int id = 0;
  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
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
              ));
            },
            child: ListTile(
              title: Text(tmp.getShoppingList[index].name),
              leading: CircleAvatar(
                child: Text("${tmp.getShoppingList[index].sum}"),
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
                            .buildDialog(context, tmp.getShoppingList[index], false);
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
                  list.name = txtName.text != "" ? txtName.text : "Empty";
                  list.sum = txtSum.text != "" ? int.parse(txtSum.text) : 0;
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
### HASIL :
![image](https://user-images.githubusercontent.com/107875899/193975740-6a9fdd73-9acb-4848-98d1-01d2997f6260.png)
![image](https://user-images.githubusercontent.com/107875899/193975809-07051520-3c6e-41bb-a5be-1ff3ab065aa8.png)

Hasilnya, data belum dapat kita tampilkan pada tampilan front-end. Untuk itu kita akan mencoba menggunakan Sq(F)Lite untuk memproses data sehingga data dapat tersimpan secara permanen dan dapat diakses kembali meskipun aplikasi telah ditutup.

# Creating Database
1. Buat sebuah file dart baru bernama **dbhelper.dart**. File ini akan kita gunakan untuk menyimpan setiap perintah yang berkaitan dengan database. Di dalam file ini buat sebuah class baru bernama **DbHelper**. Pada proses pertama dalam operasi database Sqlite, anda diwajibkan untuk melakkan inisialisasi dan membuka database. Adapun insialisasi dan membuka database dapat menggunakan fungsi **openDatabase()**. Pada saat proses openDatabase() anda dapat mentriger sebuah event **onCreate()** untuk membentuk table yang terhubung dengan database anda. Atau anda dapat mecreate tabel secara terpisah.
```
import 'package:path/path.dart';
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
      join(await getDatabasesPath(), _db_name),
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
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
```
2. Pada file shopping_list_dialog.dart, tambahkan perintah untuk menambahkan data ke dalam database pada widget Elevated Button dengna menggunakan helper database. Pastikan anda memberikan akses database pada kelas shopping_list_dialog, melalui constructor sehingga shopping_list_dialog.dart dituliskan sebagai berikut.
![image](https://user-images.githubusercontent.com/107875899/193976780-edb387df-2f99-46a4-8fc6-749d3d76c686.png)
![image](https://user-images.githubusercontent.com/107875899/193976820-1102934d-3142-4915-a15a-ad4bc7d214bf.png)

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
![image](https://user-images.githubusercontent.com/107875899/193977124-27eaee56-ee94-42d2-9bce-b28ab5116277.png)

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
      print("Isi DB" + maps.toString());
      return List.generate(maps.length, (i) {
        return ShoppingList(maps[i]['id'], maps[i]['name'], maps[i]['sum']);
      });
    }
    return [];
  }
```
2. Pada screen.dart, anda dapat menghubungkan provider dengan fungsi getMyShoppingList() database, sehingga setiap kali terjadi perubahan data, provider dapat langsung menampilkan hasilnya pada screen anda.
![image](https://user-images.githubusercontent.com/107875899/193977860-7d2d5f16-b9fb-4a76-836d-b953d11f0afe.png)
![image](https://user-images.githubusercontent.com/107875899/193977889-3a490012-c7fd-4b35-909d-5e329a907d57.png)

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
                        _dbHelper
                            .getmyShopingList()
                            .then((value) => tmp.setShoppingList = value);
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
          _dbHelper
              .getmyShopingList()
              .then((value) => tmp.setShoppingList = value);
        },
        child: Icon(Icons.add),
      ),
    );
  }
```
3. Tambahkan pula pembagian fungsi ini pada saat pertama kali widget di build, sehingga data akan langsung ditampilkan kepada anda, setiap kali aplikasi dibuka.
![image](https://user-images.githubusercontent.com/107875899/193978058-6d4eb2bb-10e1-4747-91c1-898df95f566b.png)

```
class _ScreenState extends State<Screen> {
  int id = 0;
  DBHelper _dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dbHelper.getmyShopingList().then((value) => tmp.setShoppingList = value);
    return Scaffold(
```
### HASIL :
Saat ini, anda telah berhasil menjalankan perintah untuk melakukan operasi di dalam database baca dan tulis. Anda dapat melihat data anda akan tersimpan secara permanen di dalam aplikasi anda, walapupn anda telah menutup aplikasi dan membukanya kembali.
![image](https://user-images.githubusercontent.com/107875899/193980204-df6773f4-b713-420a-9b67-86a4f2ba8e7e.png)
![image](https://user-images.githubusercontent.com/107875899/193980270-3d6b3bbd-3f71-45a0-a7f2-ea2c14df3764.png)
![image](https://user-images.githubusercontent.com/107875899/193980326-6de21bd7-7ffb-4353-88be-4235196147bb.png)


# Delete Data
1. Pada dbhelper.dart, tambahkan sebuah fungsi untuk melakukan penghapusan data dari database.
```
  Future<void> deleteShoppingList(int id) async {
    await _database?.delete(
      'shopping_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
```
2. Data akan dihapus ketika disapu ke kanan atau kiri dari layar aplikasi. Pada screen.dart di bagian onDissmissed tambahkan perintah berikut untuk menghapus data dari database ketika aksi ini dilakukan.
![image](https://user-images.githubusercontent.com/107875899/193980454-9ade122e-1268-4ad8-8f36-076933e7c620.png)

```
                  onDismissed: (direction) {
                    String tmpName = tmp.getShoppingList[index].name;
                    int tmpId = tmp.getShoppingList[index].id;
                    setState(() {
                      tmp.deleteById(tmp.getShoppingList[index]);
                    });
                    _dbHelper.deleteShoppingList(tmpId);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(""$tmpName deleted"),
                    ));
                  },
```
# Close Database
3. Pada dbhelper.dart, tambahkan sebuah fungsi untuk menutup koneksi ke dalam database.
```
  Future<void> closeDB() async {
    await _database?.close();
  }
```
4. Pastikan anda menambahkan proses untuk menutup database ketika aplikasi selesai dilakukan dengan cara menambahkan fungsi closeDB() pada lifecycle dispose() aplikasi anda.
```
  @override
  void dispose() {
    _dbHelper.closeDB();
    super.dispose();
  }
```
# Latihan
1. Pada contoh diatas, masih terdapat kelemahan, dimana setiap aplikasi dibuka kembali, pengimputan data akan dimulai kembali dari urutan pertama. Ini disebabkan oleh id tidak tersimpan secara permanen. Lakukan penyimpanan sharedPreference atau pembacaan id terakhir untuk menangani masalah tersebut.
![image](https://user-images.githubusercontent.com/107875899/193972709-745761e9-f6c1-4ba6-b8b9-c257015c7319.png)

2. Tambahkan proses untuk menghapus seluruh isi table database, ketika action pada appBar di klik.
![image](https://user-images.githubusercontent.com/107875899/193972800-9947689c-2065-40e8-8154-a904e3c6540e.png)

3. Tambahkan sebuah aktifitas berupa history, dimana setiap kali penghapusan di lakukan, akan tersimpan dalam aktifitas history, termasuk dengan tanggal dan jam dilakukannya penghapusan data.
