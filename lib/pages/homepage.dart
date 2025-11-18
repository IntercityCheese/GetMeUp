import 'package:flutter/material.dart';
import 'package:getmeup/utils/alarmwidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        onPressed: () {},
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            AlarmWidget(
              alarmName: "Mon-Fri Work Commute",
              alarmTime: "09:40",
              modes: ["TfL - Central", "SouthWest - Waterloo2Bournemouth"],
              isDelayed: false,
              enabled: true,
            ),
            AlarmWidget(
              alarmName: "Alarm 2",
              alarmTime: "10:40",
              modes: ["TfL - Central", "SouthWest - Waterloo2Bournemouth"],
              isDelayed: false,
              enabled: false,
            ),
            AlarmWidget(
              alarmName: "Train Home",
              alarmTime: "18:36",
              modes: ["TfL - Central", "SouthWest - Waterloo2Bournemouth"],
              isDelayed: false,
              enabled: false,
            ),
            AlarmWidget(
              alarmName: "Alarm 3",
              alarmTime: "18:36",
              modes: ["TfL - Central", "SouthWest - Waterloo2Bournemouth"],
              isDelayed: false,
              enabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
