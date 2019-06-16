// Libs
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
// Local Packages
import 'package:myapp/dialogs.dart';

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
                onPressed: () async {
                  final action = await Dialogs.yesAbortDialog(context, 'My title', 'My Body');
                  print(action);
                },
                child: Text('Agendar')
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
}
