import 'package:flutter/material.dart';

class NavigationTileWidget extends StatelessWidget {
  final String startLocation;
  final String endLocation;
  final String mode;
  const NavigationTileWidget({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    mode == "Car"
                        ? Icons.drive_eta
                        : mode == "Tube"
                        ? Icons.subway_rounded
                        : mode == "Train"
                        ? Icons.train
                        : Icons.directions_walk_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    startLocation,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_downward, color: Colors.white, size: 30),
              Row(
                children: [
                  Icon(
                    mode == "Car"
                        ? Icons.drive_eta
                        : mode == "Tube"
                        ? Icons.subway_rounded
                        : mode == "Train"
                        ? Icons.train
                        : Icons.directions_walk_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    endLocation,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
