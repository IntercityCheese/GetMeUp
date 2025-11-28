import 'package:flutter/material.dart';
import 'package:getmeup/utils/livegraphic.dart';

class AlarmWidget extends StatelessWidget {
  final String alarmName;
  final String alarmTime;
  final bool isDelayed;
  final List modes;
  final bool enabled;
  final bool isLive; // <--- NEW (comes from HomePage)
  final List<int> repeatDays;
  final Function(bool)? onToggle;
  final VoidCallback? setTime;
  final VoidCallback? setName;
  final VoidCallback? editAlarm;

  const AlarmWidget({
    super.key,
    required this.alarmName,
    required this.alarmTime,
    required this.modes,
    required this.isDelayed,
    required this.enabled,
    required this.isLive, // <--- NEW
    required this.repeatDays,
    required this.onToggle,
    required this.setTime,
    required this.setName,
    required this.editAlarm,
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
              Row(
                children: [
                  // Uses delayed live state now
                  LiveGraphic(isLive: isLive),

                  const Text("  "),

                  GestureDetector(
                    onTap: setName,
                    child: Text(
                      alarmName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: setTime,
                child: Text(
                  alarmTime,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Colors.white,
                  ),
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
                    onPressed: editAlarm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.edit),
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
