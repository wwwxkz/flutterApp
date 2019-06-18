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
      /*theme: ThemeData(
        primarySwatch: Colors.deepPurple[300],
      ),*/
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
          backgroundColor: Colors.deepPurple,
          title: Text(title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.grey[800], boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10,
                      )
                    ]),
                    child: ListTile(
                      title: Text('${tasks[index]}'),
                      leading: FlatButton(
                        color: Colors.deepPurple[500],
                        textColor: Colors.white,
                        onPressed: () {
                          removeTask(index);
                        },
                        child: Icon(Icons.remove),
                      ),
                    )
                  );
                },
              ),
            ),
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Calling Dialog in dialogs.dart 
            // And opening dialog to schedule and add a new task
            final action = await Dialogs.yesAbortDialog(context, 'New Task', 'My Body', tasks);
            setState(() {
              tasks = action;
            });
          },
          backgroundColor: Colors.deepPurple,
          tooltip: 'Add Task',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
