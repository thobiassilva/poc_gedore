import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

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
      width: ferramenta.size.width,
      height: ferramenta.size.height,
      color: Colors.black26,
      child: GestureDetector(
        onPanUpdate: (details) => ferramenta.setPosition(details.delta),
        child: CustomPaint(
          painter: FerramentaPainter(
            entities: ferramenta.entities,
            menorX: ferramenta.menorX ?? 0,
            menorY: ferramenta.menorY ?? 0,
          ),
          // child: const Center(),
        ),
      ),
    );
  }
}

class FerramentaPainter extends CustomPainter {
  final List<AcDbEntity> entities;
  final double menorX;
  final double menorY;
  const FerramentaPainter({
    required this.entities,
    required this.menorX,
    required this.menorY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.square;

    for (var entity in entities) {
      final ajustX = menorX;
      final ajustY = menorY + size.height;

      if (entity is AcDbCircle) {
        canvas.drawCircle(
          Offset(entity.x - ajustX, -entity.y + ajustY),
          entity.radius,
          paint,
        );
      }

      if (entity is AcDbLine) {
        canvas.drawLine(
          Offset(entity.x - ajustX, -entity.y + ajustY),
          Offset(entity.x1 - ajustX, -entity.y1 + ajustY),
          paint,
        );
      }

      if (entity is AcDbArc) {
        final rect = Rect.fromCircle(
          center: Offset(entity.x - ajustX, -entity.y + ajustY),
          radius: entity.radius,
        );

        if (entity.endAngle - entity.startAngle < 0) {
          canvas.drawArc(
            rect,
            -radians(entity.endAngle),
            radians(360 - entity.startAngle),
            false,
            paint,
          );

          canvas.drawArc(
            rect,
            -radians(entity.startAngle),
            -radians(entity.endAngle),
            false,
            paint..color,
          );
        } else {
          canvas.drawArc(
            rect,
            -radians(entity.startAngle),
            -radians(entity.endAngle - entity.startAngle),
            false,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant FerramentaPainter oldDelegate) => true;
}
