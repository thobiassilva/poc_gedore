import 'package:flutter/material.dart';

import 'ferramenta.dart';

class FerramentaWidget extends StatelessWidget {
  final Ferramenta ferramenta;

  const FerramentaWidget({
    Key? key,
    required this.ferramenta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ferramenta.size.width * 2,
      height: ferramenta.size.height * 2,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        onPanUpdate: (details) => ferramenta.setPosition(details.delta),
        child: CustomPaint(
          painter: FerramentaPainter(
            color: ferramenta.cor,
          ),
          child: const Center(),
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

    // canvas.drawRect(
    //   // Rect.fromCircle(center: const Offset(25, 25), radius: 25),
    //   Rect.fromCenter(
    //     center: Offset(size.width / 2, size.height / 2),
    //     width: 60,
    //     height: 70,
    //   ),
    //   paint,
    // );

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant FerramentaPainter oldDelegate) => true;
}
