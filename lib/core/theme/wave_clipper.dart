import 'package:flutter/material.dart';

class WaveClipper extends CustomPainter {
  final bool showBottom;

  WaveClipper({this.showBottom = true});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color =Colors.teal
      ..style = PaintingStyle.fill;

    // Top Wave
    Path topWave = Path();
    topWave.moveTo(0, 0);
    topWave.lineTo(0, size.height * 0.15);
    topWave.quadraticBezierTo(size.width * 0.25, size.height * 0.10,
        size.width * 0.5, size.height * 0.12);
    topWave.quadraticBezierTo(
        size.width * 0.82, size.height * 0.13, size.width, size.height * 0.06);
    topWave.lineTo(size.width, 0);
    topWave.close();

    canvas.drawPath(topWave, paint);

    // Bottom Wave (only if showBottom is true)
    if (showBottom) {
      Path bottomWave = Path();
      bottomWave.moveTo(0, size.height);
      bottomWave.lineTo(0, size.height * 0.85);
      bottomWave.quadraticBezierTo(size.width * 0.25, size.height * 0.90,
          size.width * 0.5, size.height * 0.88);
      bottomWave.quadraticBezierTo(size.width * 0.82, size.height * 0.87,
          size.width, size.height * 0.94);
      bottomWave.lineTo(size.width, size.height);
      bottomWave.close();

      canvas.drawPath(bottomWave, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WaveClipper oldDelegate) {
    return oldDelegate.showBottom != showBottom;
  }
}
