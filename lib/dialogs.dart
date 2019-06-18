// Libs
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:intl/intl.dart';

// Dialog returns
enum DialogAction { yes, abort }

class Dialogs { 
  // Local notifications init
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static final notifications = FlutterLocalNotificationsPlugin();

  // Date Time Format
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd-HH-mm');
  
  // Variable to store user input
  static String taskName;
  static String taskBody;

  static Future yesAbortDialog(
      BuildContext context,
      String title,
      String body,
      var tasks,
      ) async {
    var localTasks = [];
    localTasks = tasks;
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Task Name', hintText: 'ex. Do homework'),
                onChanged: (input) {
                  taskName = input;
                },
              ),
              new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Task Body', hintText: 'ex. Come on men'),
                onChanged: (input) {
                  taskBody = input;
                },
              ),
            ],
          ),
          
          actions: <Widget>[
            RaisedButton(
              onPressed: () async{
                // Getting time and date of user
                final timeSelected = await timePicker(context);
                final dateSelected = await datePicker(context);
                // Verifing
                if (timeSelected == null) return;
                if (dateSelected == null) return;

                var selectedDateAndTime = DateTime(
                  dateSelected.year,
                  dateSelected.month,
                  dateSelected.day,
                  timeSelected.hour,
                  timeSelected.minute,
                );

                // Adding task to local tasks var
                if (taskName != null) localTasks.add(taskName);//else return;

                //print(selectedDateAndTime);
                await scheduleNotification(notifications, scheduledDate: selectedDateAndTime, title: taskName, body: taskBody);
              },
              child: const Text(
                'Agendar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (action != null){
      return localTasks; 
    }
    //return (action != null) ? action : DialogAction.abort;
  }

  // Time Picker ----------------------------------------------------------------------
  static Future<TimeOfDay> timePicker(BuildContext context){
    final now = DateTime.now();
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }

  // Date Picker ----------------------------------------------------------------------
  static Future<DateTime> datePicker(BuildContext context) => showDatePicker(
    context: context,
    initialDate: DateTime.now().add(Duration(seconds: 1)),
    firstDate: DateTime.now(),
    lastDate: DateTime(2077),
  );


// Plataform Configuration ------------------------------------------------------------
static NotificationDetails get plataformConfig {
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

// Schedule Notificaton -------------------------------------------------------------
  static Future scheduleNotification(
    FlutterLocalNotificationsPlugin notifications, {
    @required DateTime scheduledDate,
    @required String title,
    @required String body,
    int id = 0,
  }) =>
      showScheduledNotification(notifications,
          title: title, body: body, id: id, type: plataformConfig, scheduledDate: scheduledDate);

  static Future showScheduledNotification(
    FlutterLocalNotificationsPlugin notifications, {
    @required DateTime scheduledDate,
    @required String title,
    @required String body,
    @required NotificationDetails type,
    int id = 1,
  }) =>
  notifications.schedule(id, title, body, scheduledDate, type);  

}