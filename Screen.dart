import 'dart:math';

import 'package:backend/M03/ItemsScreen.dart';
import 'package:backend/M03/dbhelper.dart';
import 'package:backend/M03/shopping_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:backend/M03/ItemsScreen.dart';
import 'package:backend/M03/ShoppingList.dart';
import 'package:backend/M03/shopping_list_dialog.dart';
import 'package:provider/provider.dart';
import 'MyProvider.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int id = 0;
  DBHelper _dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dbHelper.getmyShopingList().then((value) => tmp.setShoppingList = value);
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
              tmp.getShoppingList != null ? tmp.getShoppingList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(tmp.getShoppingList[index].id.toString()),
                onDismissed: (direction) {
                  String tmpName = tmp.getShoppingList[index].name;
                  int tmpId = tmp.getShoppingList[index].id;
                  setState(() {
                    tmp.deleteById(tmp.getShoppingList[index]);
                  });
                  _dbHelper.deleteShoppingList(tmpId);
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
                              return ShoppingListDialog(_dbHelper).buildDialog(
                                  context, tmp.getShoppingList[index], false);
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
              });
          _dbHelper
              .getmyShopingList()
              .then((value) => tmp.setShoppingList = value);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _dbHelper.closeDB();
    super.dispose();
  }
}
