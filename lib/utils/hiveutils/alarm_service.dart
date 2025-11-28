import 'package:fluttertoast/fluttertoast.dart';
import 'package:getmeup/utils/navutils/drive_api_service.dart';
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

  int timeToMinutes(String t) {
    final parts = t.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  /// Calculates the new wake-up time based on journey times
  Future<void> calculateNewTime(int index) async {
    final alarm = box.getAt(index);
    if (alarm == null) return;

    double journeyTime = 0.0; // in minutes

    final geocoder = GeocodingService(DriveAPIService().accessToken);
    final routing = DriveAPIService();

    for (int journey = 0; journey < alarm.modeMap.length; journey++) {
      final item = alarm.modeMap[journey.toString()];
      if (item == null) continue;

      final type = item[2];
      if (type == "PreTime") {
        // ensure numeric
        journeyTime += (item[0] is num)
            ? item[0].toDouble()
            : double.tryParse(item[0].toString()) ?? 0;
      } else if (type == "Car") {
        final startCoords = await geocoder.forwardGeocode(item[0]);
        final endCoords = await geocoder.forwardGeocode(item[1]);

        if (startCoords == null || endCoords == null) {
          Fluttertoast.showToast(msg: "Could not find one of the addresses");
          return;
        }

        final startStr = "${startCoords[0]},${startCoords[1]}";
        final endStr = "${endCoords[0]},${endCoords[1]}";

        final subJourneyTime = await routing.getTravelTime(startStr, endStr);
        if (subJourneyTime == null) {
          Fluttertoast.showToast(
            msg: "Could not calculate travel time for journey",
          );
          return;
        }

        journeyTime += subJourneyTime;
        print(
          "Journey $journey: $startStr -> $endStr = $subJourneyTime minutes",
        );
      }
    }

    // Convert arrivalTime → minutes
    final arrivalMinutes = timeToMinutes(alarm.arrivalTime);

    // Subtract journey time
    int wakeUpMinutes = arrivalMinutes - journeyTime.round();
    wakeUpMinutes = wakeUpMinutes % (24 * 60); // wrap around 24h

    final h = wakeUpMinutes ~/ 60;
    final m = wakeUpMinutes % 60;
    final wakeUpTime =
        "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";

    // Save new alarm
    final newAlarm = Alarm(
      time: wakeUpTime,
      isEnabled: alarm.isEnabled,
      repeatDays: alarm.repeatDays,
      alarmName: alarm.alarmName,
      modeMap: alarm.modeMap,
      arrivalTime: alarm.arrivalTime,
    );

    await box.putAt(index, newAlarm);
  }
}
