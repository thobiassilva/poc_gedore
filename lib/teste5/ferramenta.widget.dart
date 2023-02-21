import 'package:flutter/material.dart';

class FerramentaWidget extends StatelessWidget {
  final Color color;
  final Offset pos;
  final void Function(Offset delta) onPanUpdate;

  const FerramentaWidget({
    Key? key,
    required this.color,
    required this.pos,
    required this.onPanUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 75,
      color: Colors.blue,
      child: GestureDetector(
        onPanUpdate: (details) => onPanUpdate(details.delta),
        child: CustomPaint(
          painter: FerramentaPainter(
            color: color,
          ),
          child: Center(
            child: Text(
              pos.toString(),
            ),
          ),
        ),
      ),
    );
  }
}

class FerramentaPainter extends CustomPainter {
  final Color color;
  const FerramentaPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    canvas.drawRect(
      // Rect.fromCircle(center: const Offset(25, 25), radius: 25),
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 60,
        height: 70,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant FerramentaPainter oldDelegate) => true;
}
