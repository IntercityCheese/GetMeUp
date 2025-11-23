import 'package:flutter/material.dart';

class LiveGraphic extends StatelessWidget {
  final bool isLive; // null
  const LiveGraphic({super.key, required this.isLive});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isLive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Icon(
              isLive ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
              size: 20,
            ),
            Text(
              isLive ? "  LIVE" : "",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
