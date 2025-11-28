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

  Box<Alarm> get alarmBox => Hive.box<Alarm>("alarms");

  @override
  void initState() {
    super.initState();
    _timeController.text = widget.alarm.arrivalTime;
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
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

  /// Opens the full-edit dialog for a journey and returns a List<String>
  /// [start, end, mode] or null if cancelled.
  Future<List<String>?> changeLocationDialog(
    String title,
    List<String> existing,
  ) {
    final startController = TextEditingController(text: existing[0]);
    final endController = TextEditingController(text: existing[1]);
    String selectedMode = existing[2];

    const modes = [
      "Car",
      "Train",
      "Tube",
      "Walking",
      "Cycling",
      "Get Ready Period",
    ];

    return showDialog<List<String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Start Location"),
              controller: startController,
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: "End Location"),
              controller: endController,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedMode,
              items: modes
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (val) {
                if (val != null) selectedMode = val;
              },
              decoration: const InputDecoration(labelText: "Mode"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Dispose controllers before popping
              startController.dispose();
              endController.dispose();
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final result = [
                startController.text,
                endController.text,
                selectedMode,
              ];
              startController.dispose();
              endController.dispose();
              Navigator.of(context).pop(result);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _changeDestinationMode(int journeyIndex) async {
    final alarm = alarmBox.getAt(widget.index);
    if (alarm == null) return;

    final updatedMap = Map<String, dynamic>.from(alarm.modeMap);
    final key = journeyIndex.toString();

    // Ensure we have a journey to edit; if not, return.
    if (!updatedMap.containsKey(key)) return;

    final currentJourney = List<String>.from(updatedMap[key] as List);

    final newJourney = await changeLocationDialog(
      "Edit Journey",
      currentJourney,
    );

    if (newJourney == null) return;

    updatedMap[key] = newJourney;

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

            final journeys = alarm.modeMap as Map<String, dynamic>;
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
                            final journey = List<String>.from(
                              journeys[key] as List,
                            );

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
                                onTap: () => _changeDestinationMode(index),
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
