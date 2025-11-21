import 'package:flutter/material.dart';
import 'package:getmeup/utils/alarmwidget.dart';
import 'package:getmeup/utils/hiveutils/alarm_service.dart';
import 'package:hive_flutter/adapters.dart';

import '../utils/hiveutils/alarmmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final alarmService = AlarmService();

  // Create new alarm
  void _createNewAlarm() {
    final box = Hive.box<Alarm>('alarms');

    final newAlarm = Alarm(
      time: "00:00",
      isEnabled: true,
      repeatDays: [],
      alarmName: "New Alarm",
    );

    box.add(newAlarm);
  }

  void _deleteAlarm(int index) {
    final box = Hive.box<Alarm>('alarms');
    box.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("GetMeUp!"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("New Alarm"),
        icon: Icon(Icons.alarm),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        onPressed: () {
          _createNewAlarm();
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Alarm>('alarms').listenable(),
          builder: (context, Box<Alarm> box, _) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final alarm = box.getAt(index)!;

                return Dismissible(
                  key: ValueKey(box.keyAt(index)),
                  direction: DismissDirection.endToStart,
                  background: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (direction) {
                    _deleteAlarm(index);
                  },

                  child: AlarmWidget(
                    alarmName: alarm.alarmName,
                    alarmTime: alarm.time,
                    modes: [],
                    isDelayed: false,
                    enabled: alarm.isEnabled,
                    repeatDays: alarm.repeatDays,
                    onToggle: (value) {
                      final updated = Alarm(
                        alarmName: alarm.alarmName,
                        time: alarm.time,
                        isEnabled: value,
                        repeatDays: alarm.repeatDays,
                      );

                      box.putAt(index, updated);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
