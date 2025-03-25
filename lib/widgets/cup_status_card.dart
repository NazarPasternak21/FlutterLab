import 'package:flutter/material.dart';

class CupStatusCard extends StatelessWidget {
  final double temperature;
  final bool isHeating;

  const CupStatusCard({
    required this.temperature,
    required this.isHeating,
    Key? key,
  }) : super(key: key);  

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.local_cafe, size: 72, color: Colors.brown),
            SizedBox(height: 16),
            Text(
              'Температура: ${temperature.toStringAsFixed(1)}°C',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Text(
              isHeating ? 'Підігрів увімкнено' : 'Очікування...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
