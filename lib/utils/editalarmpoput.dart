import 'package:flutter/material.dart';
import 'package:getmeup/utils/hiveutils/alarm_service.dart';
import 'package:getmeup/utils/hiveutils/alarmmodel.dart';
import 'package:getmeup/utils/navigation_tile_widget.dart';
import 'package:hive_flutter/adapters.dart';

class EditAlarmPopout extends StatefulWidget {
  final Alarm alarm;
  final int index; // index inside Hive box

  const EditAlarmPopout({super.key, required this.alarm, required this.index});

  @override
  State<EditAlarmPopout> createState() => _EditAlarmPopoutState();
}

class _EditAlarmPopoutState extends State<EditAlarmPopout> {
  final TextEditingController _timeController = TextEditingController();

  Box<Alarm> get alarmBox => Hive.box<Alarm>("alarms");

  @override
  void initState() {
    super.initState();
    _timeController.text = widget.alarm.time;
  }

  /// -------------------------------------------------------------------------
  /// Add journey
  /// -------------------------------------------------------------------------
  Future<void> _createNewJourney() async {
    final alarm = alarmBox.getAt(widget.index)!;

    // Clone map to avoid modifying Hive object reference directly
    final newMap = Map<String, dynamic>.from(alarm.modeMap);

    newMap[newMap.length.toString()] = ["BH3 7LZ, UK", "BH8 9PY, UK", "Car"];

    // Save updated alarm
    alarmBox.putAt(
      widget.index,
      Alarm(
        time: alarm.time,
        isEnabled: alarm.isEnabled,
        repeatDays: alarm.repeatDays,
        alarmName: alarm.alarmName,
        modeMap: newMap,
        arrivalTime: alarm.arrivalTime,
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// Delete a journey
  /// -------------------------------------------------------------------------
  Future<void> _deleteJourney(String key) async {
    final alarm = alarmBox.getAt(widget.index)!;

    final newMap = Map<String, dynamic>.from(alarm.modeMap);
    newMap.remove(key);

    // Reindex keys so they are 0,1,2,3…
    final reindexed = <String, dynamic>{};
    int i = 0;
    newMap.forEach((_, value) {
      reindexed[i.toString()] = value;
      i++;
    });

    alarmBox.putAt(
      widget.index,
      Alarm(
        time: alarm.time,
        isEnabled: alarm.isEnabled,
        repeatDays: alarm.repeatDays,
        alarmName: alarm.alarmName,
        modeMap: reindexed,
        arrivalTime: alarm.arrivalTime,
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// Time Picker
  /// -------------------------------------------------------------------------
  Future<void> _selectTime() async {
    final alarm = alarmBox.getAt(widget.index)!;
    final service = AlarmService();

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    // Update ARRIVAL time only
    final newArrivalTime = picked.format(context);

    // Save arrival time FIRST
    alarmBox.putAt(
      widget.index,
      Alarm(
        time: alarm.time, // keep wake-up time
        isEnabled: alarm.isEnabled,
        repeatDays: alarm.repeatDays,
        alarmName: alarm.alarmName,
        modeMap: alarm.modeMap,
        arrivalTime: newArrivalTime, // update user-selected arrival time
      ),
    );

    // THEN recalculate wake-up time
    if (alarm.modeMap.isNotEmpty) {
      await service.calculateNewTime(widget.index);
    }

    // Update UI with NEW wake-up time from Hive
    final updated = alarmBox.getAt(widget.index)!;
    _timeController.text = updated.arrivalTime;
  }

  /// -------------------------------------------------------------------------
  /// UI
  /// -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 515,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ValueListenableBuilder(
          valueListenable: alarmBox.listenable(keys: [widget.index]),
          builder: (context, _, __) {
            final alarm = alarmBox.getAt(widget.index)!;
            final journeys = alarm.modeMap;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER ----------------------------------------------------
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          alarm.alarmName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          alarm.time,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // BODY ------------------------------------------------------
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: _createNewJourney,
                          label: const Icon(Icons.add),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),

                      // JOURNEY LIST --------------------------------------
                      SizedBox(
                        height: 210,
                        child: ListView.builder(
                          itemCount: journeys.length,
                          itemBuilder: (context, index) {
                            final key = index.toString();
                            final journey = journeys[key];

                            return Dismissible(
                              key: ValueKey("journey_$key"),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) => _deleteJourney(key),
                              child: NavigationTileWidget(
                                startLocation: journey[0],
                                endLocation: journey[1],
                                mode: journey[2],
                              ),
                            );
                          },
                        ),
                      ),

                      // TIME PICKER ---------------------------------------
                      TextField(
                        controller: _timeController,
                        readOnly: true,
                        onTap: _selectTime,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Time of Arrival",
                          suffixIcon: const Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                          filled: true,
                          fillColor: Colors.grey[800],
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
