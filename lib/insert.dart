// ignore_for_file: deprecated_member_use
import 'package:dbsqflite2/main.dart';
import 'package:dbsqflite2/models/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class Insert extends StatefulWidget {
  @override
  _InsertState createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  Future<List<ToDoList>> _alarms;

  @override
  void initState() {
    loadAlarms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              width: width > 400 ? 300 : 200,
              height: width > 400 ? 300 : 200,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                maxLength: 8,
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  labelText: 'ToDo Title',
                  hintText: 'title',
                  contentPadding: EdgeInsets.only(left: 25),
                ),
                onFieldSubmitted: (value) => insertToDo(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                maxLength: 15,
                controller: descController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding: EdgeInsets.only(left: 25),
                  labelText: 'ToDo Description',
                ),
                onFieldSubmitted: (value) => insertToDo(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    //time picker
                    FlatButton.icon(
                      onPressed: () {
                        _selectTime(context);
                      },
                      icon: Icon(Icons.timer),
                      label: Text("Time Picker"),
                    ),
                    Text(
                      _timepic,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                Column(
                  children: [
                    // date picker
                    FlatButton.icon(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(Icons.date_range),
                      label: Text("Date Picker"),
                    ),
                    Text(
                      _datepick,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                color: Colors.amber,
                onPressed: () => insertToDo(),
                child: Text(
                  "Insert Todo",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                elevation: 7,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            )
          ],
        ),
      ),
    );
  }

  var _timeANDdate = '' + '';

  var _timepic = '';
  String _hour, _minute, _time;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timepic = _time;
        _timepic = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  DateTime selectedDate = DateTime.now();
  var _datepick = '';
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _datepick = DateFormat.yMd().format(selectedDate);
      });
  }

  String time() {
    if (_timepic.length == 0 && _datepick.length == 0) {
      DateTime now = DateTime.now();
      var currentTime = DateFormat.jm().format(now);
      var currentDate = DateFormat.yMd().format(now);
      setState(() {
        _timepic = currentTime;
        _datepick = currentDate;
      });
      return currentTime + ' ' + currentDate;
    } else {
      return _timepic + ' ' + _datepick;
    }
    // print(_timepic.toString() + '' + _datepick.toString());
  }

  insertToDo() async {
    final _todo = ToDoList(
      title: titleController.text.toString(),
      desc: descController.text.toString(),
      time: time(),
      id: 12,
    );
    if (titleController.value.text.length != 0 &&
        descController.value.text.length != 0) {
      // int id = await DatabaseHelper.instacne.insert(
      //   {
      //     DatabaseHelper.colTitle: titleController.text.toString(),
      //     DatabaseHelper.colDesc: descController.text.toString(),
      //     DatabaseHelper.colTime: time()
      //   }, // {"title" : "title", "desc": "description", "time": "time"}
      // );
      var res = await DatabaseHelper.instacne.insert(
        ToDoList(
          title: titleController.text.toString(),
          desc: descController.text.toString(),
          time: time(),
        ),
      );

      if (res != null) {
        Fluttertoast.showToast(
          msg: "ADD Done :)",
          backgroundColor: Colors.green,
          toastLength: Toast.LENGTH_LONG,
        );
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MyApp(),
            ),
            (route) => false);
      } else {
        Fluttertoast.showToast(
          msg: "Adding Error :(",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
      }

      // loadAlarms();
      // scheduleAlarm(
      //     scheduledNotificationDateTime: DateTime.parse(time()),
      //     toDoList: _todo);
    } else {
      Fluttertoast.showToast(
          msg: "Inputs \'s Empty", backgroundColor: Colors.red);
    }
  }

  void scheduleAlarm(
      {DateTime scheduledNotificationDateTime, ToDoList toDoList}) async {
    print(scheduledNotificationDateTime);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif_title',
      'alarm_notif_Desc',
      'Channel for Alarm notification',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
      0,
      toDoList.title,
      toDoList.desc,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: "payload",
      androidAllowWhileIdle: true,
    );
  }

  loadAlarms() async {
    var _all = await DatabaseHelper.instacne.getAlls();
    _all.forEach((element) {
      print(element.toMap());
    });
  }
}
