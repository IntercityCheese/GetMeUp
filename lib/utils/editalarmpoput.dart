import 'package:flutter/material.dart';
import 'package:getmeup/utils/hiveutils/alarmmodel.dart';
import 'package:getmeup/utils/navigation_tile_widget.dart';

class EditAlarmPopout extends StatelessWidget {
  final Alarm? alarm;

  const EditAlarmPopout({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 515,
      width: 100000,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.only(
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
            Container(
              //Header
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
                        alarm!.alarmName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        alarm!.time,
                        style: TextStyle(
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
                      label: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                      ),
                    ),

                    SizedBox(
                      height: 250,
                      child: ListView(
                        children: [
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
