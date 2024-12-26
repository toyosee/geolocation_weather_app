import 'package:flutter/material.dart';

// Stateles widget for Hourly Weather Update
class HourlyForcastItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temperature;

  const HourlyForcastItem({
    super.key,
    required this.icon,
    required this.time,
    required this.temperature
    });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
              color: Colors.cyan,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(temperature),
          ],
        ),
      ),
    );
  }
}
