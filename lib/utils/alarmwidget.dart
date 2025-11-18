import 'package:flutter/material.dart';

class AlarmWidget extends StatelessWidget {
  final String alarmName;
  final String alarmTime;
  final bool isDelayed;
  final List modes;
  final bool enabled;

  const AlarmWidget({
    super.key,
    required this.alarmName,
    required this.alarmTime,
    required this.modes,
    required this.isDelayed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                alarmName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                alarmTime,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Switch(
                    value: enabled,
                    onChanged: (context) {},
                    activeThumbColor: Colors.green,
                  ),

                  ElevatedButton(
                    child: Icon(Icons.edit),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
