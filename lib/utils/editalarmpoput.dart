import 'package:flutter/material.dart';
import 'package:getmeup/utils/hiveutils/alarm_service.dart';
import 'package:getmeup/utils/hiveutils/alarmmodel.dart';
import 'package:getmeup/utils/navigation_tile_widget.dart';
import 'package:hive_flutter/adapters.dart';

class EditAlarmPopout extends StatefulWidget {
  final Alarm alarm;
  final int index;

  const EditAlarmPopout({super.key, required this.alarm, required this.index});

  @override
  State<EditAlarmPopout> createState() => _EditAlarmPopoutState();
}

class _EditAlarmPopoutState extends State<EditAlarmPopout> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController controller = TextEditingController();

  Box<Alarm> get alarmBox => Hive.box<Alarm>("alarms");

  @override
  void initState() {
    super.initState();
    _timeController.text = widget.alarm.arrivalTime;
  }

  Future<void> _createNewJourney() async {
    final alarm = alarmBox.getAt(widget.index);
    if (alarm == null) return;

    final updatedMap = Map<String, dynamic>.from(alarm.modeMap);
    final newKey = updatedMap.length.toString();

    updatedMap[newKey] = ["BH3 7LZ, UK", "BH8 9DG, UK", "Car"];

    alarmBox.putAt(
      widget.index,
      Alarm(
        time: alarm.time,
        isEnabled: alarm.isEnabled,
        repeatDays: alarm.repeatDays,
        alarmName: alarm.alarmName,
        modeMap: updatedMap,
        arrivalTime: alarm.arrivalTime,
      ),
    );
  }

  Future<void> _deleteJourney(String key) async {
    final alarm = alarmBox.getAt(widget.index);
    if (alarm == null) return;

    final updatedMap = Map<String, dynamic>.from(alarm.modeMap);
    updatedMap.remove(key);

    final reindexed = <String, dynamic>{};
    int i = 0;
    for (var entry in updatedMap.values) {
      reindexed[i.toString()] = entry;
      i++;
    }

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

  Future<void> _selectTime() async {
    final alarm = alarmBox.getAt(widget.index);
    if (alarm == null) return;

    final service = AlarmService();

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    final newArrivalTime = picked.format(context);

    alarmBox.putAt(
      widget.index,
      Alarm(
        time: alarm.time,
        isEnabled: alarm.isEnabled,
        repeatDays: alarm.repeatDays,
        alarmName: alarm.alarmName,
        modeMap: alarm.modeMap,
        arrivalTime: newArrivalTime,
      ),
    );

    if (alarm.modeMap.isNotEmpty) {
      await service.calculateNewTime(widget.index);
    }

    final updated = alarmBox.getAt(widget.index);
    if (updated != null) {
      _timeController.text = updated.arrivalTime;
    }
  }

  Future<void> _changeDestinationMode(
    int journeyIndex,
    int location,
    String title,
  ) async {
    final alarm = alarmBox.getAt(widget.index);
    if (alarm == null) return;

    final newName = await changeLocationDialog(title);
    if (newName == null) return;

    final updatedMap = Map<String, dynamic>.from(alarm.modeMap);

    final key = journeyIndex.toString();
    final journey = List.from(updatedMap[key]);
    journey[location] = newName;

    updatedMap[key] = journey;

    alarmBox.putAt(
      widget.index,
      Alarm(
        time: alarm.time,
        isEnabled: alarm.isEnabled,
        repeatDays: alarm.repeatDays,
        alarmName: alarm.alarmName,
        modeMap: updatedMap,
        arrivalTime: alarm.arrivalTime,
      ),
    );

    await _selectTime();
  }

  Future<String?> changeLocationDialog(String title) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: "Enter $title"),
          controller: controller,
        ),
        actions: [
          TextButton(onPressed: close, child: const Text("Cancel")),
          TextButton(onPressed: submit, child: const Text("OK")),
        ],
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }

  void close() {
    Navigator.of(context).pop();
    controller.clear();
  }

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
          valueListenable: alarmBox.listenable(),
          builder: (context, _, __) {
            final alarm = alarmBox.getAt(widget.index);
            if (alarm == null) return const SizedBox();

            final journeys = alarm.modeMap;
            final keys = journeys.keys.toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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

                      SizedBox(
                        height: 210,
                        child: ListView.builder(
                          itemCount: journeys.length,
                          itemBuilder: (context, index) {
                            final key = keys[index];
                            final journey = journeys[key] as List;

                            return Dismissible(
                              key: ValueKey(
                                "journey_${key}_${journey.hashCode}",
                              ),
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
                                clickStart: () => _changeDestinationMode(
                                  index,
                                  0,
                                  "Start Location",
                                ),
                                clickEnd: () => _changeDestinationMode(
                                  index,
                                  1,
                                  "End Location",
                                ),
                              ),
                            );
                          },
                        ),
                      ),

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
