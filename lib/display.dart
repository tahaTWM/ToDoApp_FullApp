import './models/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './dbhelper.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class Display extends StatefulWidget {
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  List<Map<String, dynamic>> _listRow;
  int length = 0;
  String _time = "";
  int len = 10;

  @override
  void initState() {
    super.initState();
    preper();
    getAllCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (BuildContext buildContext, int index) {
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(_listRow[index][DatabaseHelper.colTitle]),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/check.png"),
                    ),
                    subtitle: Text(_listRow[index][DatabaseHelper.colTime]),
                    // ignore: deprecated_member_use
                    trailing: FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.more_vert),
                        label: Text("More")),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                      child: Text(
                        _listRow[index][DatabaseHelper.colDesc],
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton.icon(
                        splashColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.red,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50)),
                        // RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          setState(() {
                            DatabaseHelper.instacne
                                .delete(_listRow[index][DatabaseHelper.colId]);
                            length -= 1;
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        label: Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              elevation: 6,
            );
          },
          itemCount: length,
          padding: EdgeInsets.all(5),
        ),
      ),
    );
  }

  void preper() async {
    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instacne.queryAll();
    setState(() {
      _listRow = queryRows;
      _listRow = _listRow.reversed.toList();
    });
  }

  getAllCount() {
    var getcount = DatabaseHelper.instacne.getCount();
    getcount.then((value) {
      print(value);
      setState(() {
        length = value;
      });
    }).catchError((error) => print("error"));
  }

  String timeReturn() {
    var now = new DateTime.now();
    setState(() {
      _time = now.millisecond.toString();
    });
  }
}
