import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final double min;
  final double max;
  final double tam;

  BackgroundPainter({
    this.min = 0,
    this.max = 1000.0,
    this.tam = 25.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // const textStyle = TextStyle(
    //   color: Colors.black,
    //   fontSize: 12,
    // );

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    for (double y = min; y <= max; y += tam) {
      final x1 = Offset(min, y);
      final x2 = Offset(max, y);
      canvas.drawLine(x1, x2, paint);

      // final textSpan = TextSpan(
      //   text: y.toStringAsFixed(0),
      //   style: textStyle,
      // );
      // final textPainter = TextPainter(
      //   text: textSpan,
      //   textDirection: TextDirection.ltr,
      // );
      // textPainter.layout(
      //   minWidth: 0,
      //   maxWidth: tam,
      // );
      // textPainter.paint(canvas, Offset(0, y) + center);

      for (double x = min; x <= max; x += tam) {
        final y1 = Offset(x, min);
        final y2 = Offset(x, max);
        canvas.drawLine(y1, y2, paint);

        // final textSpan = TextSpan(
        //   text: x.toStringAsFixed(0),
        //   style: textStyle,
        // );
        // final textPainter = TextPainter(
        //   text: textSpan,
        //   textDirection: TextDirection.ltr,
        // );
        // textPainter.layout(
        //   minWidth: 0,
        //   maxWidth: tam,
        // );
        // textPainter.paint(canvas, Offset(x, 0) + center);
      }
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BackgroundPainter oldDelegate) => false;
}
