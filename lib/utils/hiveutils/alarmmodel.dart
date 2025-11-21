import 'package:hive/hive.dart';
part 'alarmmodel.g.dart';

@HiveType(typeId: 0)
class Alarm {
  @HiveField(0)
  String alarmName;

  @HiveField(1)
  String time;

  @HiveField(2)
  bool isEnabled;

  @HiveField(3)
  List<int> repeatDays;

  Alarm({
    required this.time,
    required this.isEnabled,
    required this.repeatDays,
    required this.alarmName,
  });
}
