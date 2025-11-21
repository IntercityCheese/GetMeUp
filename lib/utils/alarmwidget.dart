import 'package:flutter/material.dart';

class AlarmWidget extends StatelessWidget {
  final String alarmName;
  final String alarmTime;
  final bool isDelayed;
  final List modes;
  final bool enabled;
  final List<int> repeatDays;
  final Function(bool)? onToggle;
  final Function() onDelete;

  const AlarmWidget({
    super.key,
    required this.alarmName,
    required this.alarmTime,
    required this.modes,
    required this.isDelayed,
    required this.enabled,
    required this.repeatDays,
    required this.onToggle,
    required this.onDelete,
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
                    onChanged: (value) => onToggle?.call(value),
                    activeThumbColor: Colors.green,
                  ),

                  ElevatedButton(
                    // Edit
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                    ),
                    child: Icon(Icons.edit),
                  ),
                  ElevatedButton(
                    // Delete
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 108, 108),
                      foregroundColor: Colors.white,
                    ),
                    child: Icon(Icons.delete),
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
