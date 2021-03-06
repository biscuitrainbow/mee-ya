import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class Notification {
  final int uuid;
  final Time time;

  Notification(this.uuid, this.time);

  static List<Notification> fromJsonArray(List<dynamic> json) {
    var notifications = json.map((notification) {
      DateFormat format = new DateFormat("hh:mm");
      var datetime = format.parse(notification['at']);
      var time = new Time(datetime.hour, datetime.minute, datetime.second);

      return Notification(
        notification['uuid'],
        time,
      );
    }).toList();

    return notifications;
  }

  @override
  String toString() {
    return 'Notification{uuid: $uuid, time: ${time.hour}:${time.minute}';
  }
}
