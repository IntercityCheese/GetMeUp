import 'package:hive/hive.dart';
import 'alarmmodel.dart';

class AlarmService {
  final Box<Alarm> box = Hive.box<Alarm>('alarms');

  // Save an alarm
  void addAlarm(Alarm alarm) {
    box.add(alarm);
  }

  // Load an alarm
  List<Alarm> getAlarms() {
    return box.values.toList();
  }

  void updateAlarm(int index, Alarm alarm) {
    box.putAt(index, alarm);
  }

  void deleteAlarm(int index) {
    box.deleteAt(index);
  }
}
