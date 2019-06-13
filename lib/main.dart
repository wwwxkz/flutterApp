                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tasks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final notifications = FlutterLocalNotificationsPlugin();

  var tasks = [];

  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
}

  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
  );

  void removeTask(index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void addTask(task) {
    setState(() {
      tasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Tasks';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              onSubmitted: (String input) {
                setState(() {
                  tasks.add(input);
                });
              }
            ),
            RaisedButton(
              onPressed: () => showOngoingNotification(notifications,title: 'Title', body: 'Body'),
              child: Text('Click here')
            ),
            RaisedButton(
              onPressed: () async {await scheduleNotification(notifications,title: 'teste', body: 'tettete');},
              child: Text('Schedule notifications')
            ),
            RaisedButton(
              onPressed: () async {await periodicallyNotification(notifications,title: 'periodi', body: 'tpeortete');},
              child: Text('Periodically notifications')
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          removeTask(index);
                        },
                        child: Text(
                          "Remove",
                        ),
                      ),
                      title: Text('${tasks[index]}'));
                },
              ),
            ),
          ]
        ),
      ),
    );
  }

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: true,
  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}


// Normal Notificaton -------------------------------------------------------------

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
notifications.show(id, title, body, type);





// Schedule Notificaton -------------------------------------------------------------

var scheduledDate = DateTime.now().add(Duration(seconds: 5));

Future scheduleNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    showScheduledNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future showScheduledNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 1,
}) =>
notifications.schedule(id, title, body, scheduledDate, type);
//notifications.show(id, title, body, type);






// Periodically Notificaton -------------------------------------------------------------

Future periodicallyNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    showPeriodicallyNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future showPeriodicallyNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 1,
}) =>
notifications.periodicallyShow(id, title, body, RepeatInterval.EveryMinute, type);












}
