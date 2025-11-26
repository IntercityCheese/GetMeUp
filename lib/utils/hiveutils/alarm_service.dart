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

  void calculateNewTime(int index) async {
    final alarm = box.getAt(index);

    double journeyTime = 0;

    final geocoder = GeocodingService(
      "pk.eyJ1IjoiYmlnYWxmMTIzNCIsImEiOiJjbWlldGtieXAwNmRnM2RyMTM2MTYxY3kyIn0.WXE5ObH-g8765iNvqpFL9g",
    );

    final routing = driveAPIService();

    for (int journey = 0; journey < alarm!.modeMap.length; journey++) {
      if (alarm.modeMap[journey][2] == "Car") {
        // Geocode start location
        List<double>? startCoords = await geocoder.forwardGeocode(
          alarm.modeMap[journey.toString()][0],
        );

        // Geocode end location
        List<double>? endCoords = await geocoder.forwardGeocode(
          alarm.modeMap[journey.toString()][1],
        );

        if (startCoords == null || endCoords == null) {
          Fluttertoast.showToast(msg: "Could not find one of the addresses");
          return;
        }

        // Convert lists to "lon,lat" strings for Mapbox
        final startConverted = "${startCoords[0]},${startCoords[1]}";
        final endConverted = "${endCoords[0]},${endCoords[1]}";

        // Call your existing routing API
        double? subJourneyTime = await routing.getTravelTime(
          startConverted,
          endConverted,
        );

        journeyTime += subJourneyTime!;
      }
    }
    // now perform subtraction on arrival time
    // make sure to add precommute time period to alarmmodel
    int minutes = timeToMinutes(alarm.arrivalTime);
    minutes -= journeyTime as int;
    minutes = minutes % (24 * 60); // wrap around 24h if needed
    int h = minutes ~/ 60;
    int m = minutes % 60;
    final wakeUpTime =
        "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";

    // then
    final newAlarm = Alarm(
      time: wakeUpTime,
      isEnabled: alarm.isEnabled,
      repeatDays: alarm.repeatDays,
      alarmName: alarm.alarmName,
      modeMap: alarm.modeMap,
      arrivalTime: alarm.arrivalTime,
    );

    box.putAt(index, newAlarm);
  }
}
