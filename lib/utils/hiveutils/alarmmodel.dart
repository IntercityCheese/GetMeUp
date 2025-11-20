import 'package:hive/hive.dart';
part 'alarmmodel.g.dart';

@HiveType(typeId: 0)
class Alarm {
  @HiveField(0)
  String time;

  @HiveField(1)
  bool isEnabled;

  @HiveField(2)
  List<int> repeatDays;

  Alarm({
    required this.time,
    required this.isEnabled,
    required this.repeatDays,
  });
}
