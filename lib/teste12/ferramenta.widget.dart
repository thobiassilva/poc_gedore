import 'dart:math';

import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'ferramenta.dart';

class FerramentaWidget extends StatelessWidget {
  final Ferramenta ferramenta;
  final List<Ferramenta> otherFerramentas;

  const FerramentaWidget({
    Key? key,
    required this.ferramenta,
    required this.otherFerramentas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('FER: ${ferramenta.position}');
    print('otherFerramentas: ${otherFerramentas[0].position}');
    return Container(
      width: ferramenta.size.width,
      height: ferramenta.size.height,
      color: ferramenta.hasColision(otherFerramentas)
          ? Colors.red
          : Colors.black26,
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
      final ajust = Offset(-menorX, menorY + size.height);

      if (entity is AcDbCircle) drawCircle(entity, ajust, canvas, paint);
      if (entity is AcDbLine) drawLine(entity, ajust, canvas, paint);
      if (entity is AcDbArc) drawArc(entity, ajust, canvas, paint);
    }
  }

  void drawRotated(
    Canvas canvas,
    Offset center,
    double angle,
    VoidCallback drawFunction,
  ) {
    canvas.save();
    // canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    // canvas.translate(-center.dx, -center.dy);
    drawFunction();
    canvas.restore();
  }

  bool hasCircleColision(AcDbCircle entity, Offset ajust, Offset position) {
    final center = Offset(entity.x, -entity.y) + ajust;
    final distance = (center - position).distance;
    return distance <= entity.radius;
  }

  bool hasArcColision(AcDbArc entity, Offset ajust, Offset position) {
    final center = Offset(entity.x, -entity.y) + ajust;
    final distance = (center - position).distance;
    if (distance > entity.radius) return false;

    final angle = atan2(position.dy - center.dy, position.dx - center.dx);
    final angleDegrees = degrees(angle);

    final startAngle = entity.startAngle;
    final endAngle = entity.endAngle;

    if (startAngle < endAngle) {
      return angleDegrees >= startAngle && angleDegrees <= endAngle;
    } else {
      return angleDegrees >= startAngle || angleDegrees <= endAngle;
    }
  }

  bool hasLineColision(AcDbLine entity, Offset ajust, Offset position) {
    final p1 = Offset(entity.x, -entity.y) + ajust;
    final p2 = Offset(entity.x1, -entity.y1) + ajust;

    final distance = (p1 - p2).distance;
    final distance1 = (p1 - position).distance;
    final distance2 = (p2 - position).distance;

    return distance1 + distance2 <= distance + 0.1;
  }

  void drawLine(AcDbLine entity, Offset ajust, Canvas canvas, Paint paint) {
    canvas.drawLine(
      Offset(entity.x, -entity.y) + ajust,
      Offset(entity.x1, -entity.y1) + ajust,
      paint,
    );
  }

  void drawCircle(AcDbCircle entity, Offset ajust, Canvas canvas, Paint paint) {
    canvas.drawCircle(
      Offset(entity.x, -entity.y) + ajust,
      entity.radius,
      paint,
    );
  }

  void drawArc(AcDbArc entity, Offset ajust, Canvas canvas, Paint paint) {
    final rect = Rect.fromCircle(
      center: Offset(entity.x, -entity.y) + ajust,
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

  @override
  bool shouldRepaint(covariant FerramentaPainter oldDelegate) => true;
}
