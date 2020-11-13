import 'package:dbsqflite2/display.dart';
import 'package:dbsqflite2/insert.dart';
import 'package:flutter/material.dart';
import './dbhelper.dart';
import './insert.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _queryRows;
  void preper() async {
    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instacne.queryAll();
    setState(() {
      _queryRows = queryRows;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void reSetIndex() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Display(),
    Insert(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Display'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Insert'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
