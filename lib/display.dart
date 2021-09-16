import 'package:flutter/material.dart';
import './dbhelper.dart';

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
        child: length == 0
            ? Center(
                child: Text(
                  "nothing add yet",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: (BuildContext buildContext, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(_listRow[index][DatabaseHelper.colTitle]),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage("assets/check.png"),
                          ),
                          subtitle:
                              Text(_listRow[index][DatabaseHelper.colTime]),
                          // ignore: deprecated_member_use
                          trailing: PopupMenuButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.black,
                              // size: 40,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 25,
                                      // color:
                                      //     Color.fromRGBO(158, 158, 158, 1),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Edit",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "RubicB",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (item) {
                              switch (item) {
                                case 1:
                                  {
                                    Map<String, dynamic> update = {
                                      // "colId": _listRow[index]
                                      //     [DatabaseHelper.colId],
                                      DatabaseHelper.colTitle: "test test",
                                      // _listRow[index]
                                      //     [DatabaseHelper.colTitle],
                                      DatabaseHelper.colDesc: "desc desc",
                                      DatabaseHelper.colTime: _listRow[index]
                                          [DatabaseHelper.colTime],
                                    };

                                    DatabaseHelper.instacne.update(update,
                                        _listRow[index][DatabaseHelper.colId]);
                                    setState(() {
                                      preper();
                                    });
                                  }
                                  break;
                              }
                            },
                          ),
                          // FlatButton.icon(
                          //     onPressed: () {},
                          //     icon: Icon(Icons.more_vert),
                          //     label: Text("More")),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                            child: Text(
                              _listRow[index][DatabaseHelper.colDesc],
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ignore: deprecated_member_use
                            FlatButton.icon(
                              color: Colors.amber[200],
                              splashColor: Colors.red[200],
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.red[500],
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () {
                                setState(() {
                                  DatabaseHelper.instacne.delete(
                                      _listRow[index][DatabaseHelper.colId]);
                                  length -= 1;
                                });
                              },
                              icon: Icon(
                                Icons.archive,
                                color: Colors.red,
                              ),
                              label: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            // ignore: deprecated_member_use
                            FlatButton.icon(
                              color: Colors.amber[200],
                              splashColor: Colors.green[200],
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.green[500],
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(50)),
                              onPressed: () {},
                              icon: Icon(
                                Icons.done_all,
                                color: Colors.green,
                              ),
                              label: Text(
                                "Done",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // elevation: 6,
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
