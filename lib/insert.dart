import 'package:dbsqflite2/display.dart';
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
  DatabaseHelper _databaseHelper;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  maxLength: 8,
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'To_Do Title',
                  ),
                  onSubmitted: (value) => insertToDo(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  maxLength: 15,
                  controller: descController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'To_Do Description',
                  ),
                  onSubmitted: (value) => insertToDo(),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: GestureDetector(
                          child: Text(
                            _timepic,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          onTap: () {
                            _selectTime(context);
                          },
                        ),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: GestureDetector(
                          child: Text(
                            _datepick,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Text(
                  "Time Picked is \n\n $_timeANDdate",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green,
                ),
                child: FlatButton(
                  onPressed: () {
                    insertToDo();
                  },
                  child: Text('insert'),
                ),
              ),
            ],
          ),
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

  void insertToDo() async {
    if (titleController.value.text.length != 0 &&
        descController.value.text.length != 0) {
      var _todo = ToDoList(
        title: titleController.text.toString(),
        desc: titleController.text.toString(),
        time: time(),
      );
      // int id = await DatabaseHelper.instacne.insert(
      //   {
      //     DatabaseHelper.colTitle: titleController.text.toString(),
      //     DatabaseHelper.colDesc: descController.text.toString(),
      //     DatabaseHelper.colTime: time()
      //   }, // {"title" : "title", "desc": "description", "time": "time"}
      // );
      _databaseHelper.insert(_todo);
      if (_todo != null) {
        Fluttertoast.showToast(
          msg: "ADD Done :)",
          backgroundColor: Colors.green,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Adding Error :(",
          backgroundColor: Colors.red,
        );
      }
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => MyApp(),
      // ));

      loadAlarms();
      scheduleAlarm(
          scheduledNotificationDateTime: DateTime.parse(time()),
          toDoList: _todo);
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

  loadAlarms() {
    _alarms = _databaseHelper.getAlarms();
    if (mounted) setState(() {});
  }
}
