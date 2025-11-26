import 'package:flutter/material.dart';
import 'package:getmeup/utils/hiveutils/alarmmodel.dart';
import 'package:getmeup/utils/navigation_tile_widget.dart';

class EditAlarmPopout extends StatefulWidget {
  final Alarm? alarm;

  const EditAlarmPopout({super.key, required this.alarm});

  @override
  State<EditAlarmPopout> createState() => _EditAlarmPopoutState();
}

class _EditAlarmPopoutState extends State<EditAlarmPopout> {
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pre-fill the controller if alarm has a time
    _timeController.text = widget.alarm?.time ?? "";
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.alarm!.alarmName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.alarm!.time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Body container
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      label: const Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                      ),
                    ),

                    SizedBox(
                      height: 210,
                      child: ListView(
                        children: const [
                          NavigationTileWidget(
                            startLocation: "2 Albermarle Road",
                            endLocation: "1 Station Road",
                            mode: "Car",
                          ),
                          NavigationTileWidget(
                            startLocation: "Bournemouth",
                            endLocation: "London Waterloo",
                            mode: "Train",
                          ),
                          NavigationTileWidget(
                            startLocation: "London Waterloo",
                            endLocation: "Stratford",
                            mode: "Tube",
                          ),
                          NavigationTileWidget(
                            startLocation: "Stratford Station BR Station St",
                            endLocation: "London Stadium, Queen Elizabe...",
                            mode: "Walk",
                          ),
                        ],
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
                        fillColor: Colors.grey[800],
                        filled: true,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
