
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:intl/intl.dart';

enum DialogAction { yes, abort }

class Dialogs { 
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static final notifications = FlutterLocalNotificationsPlugin();

  DateTime selectedDate = DateTime.now();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd-HH-mm');
  
  static Future<DialogAction> yesAbortDialog(
      BuildContext context,
      String title,
      String body,
      ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
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

                //print(selectedDateAndTime);
                await scheduleNotification(notifications, scheduledDate: selectedDateAndTime, title: 'dialog mensage', body: 'teste body hello men');
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
    return (action != null) ? action : DialogAction.abort;
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