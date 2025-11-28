import 'package:flutter/material.dart';

class NavigationTileWidget extends StatelessWidget {
  final String startLocation;
  final String endLocation;
  final String mode;
  final VoidCallback onTap;

  const NavigationTileWidget({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.mode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        startLocation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Icon(Icons.arrow_downward, color: Colors.white, size: 30),
                const SizedBox(height: 8),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        endLocation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
