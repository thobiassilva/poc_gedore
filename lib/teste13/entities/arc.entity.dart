import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

import 'entity.dart';

class ArcEntity extends AcDbArc implements Entity {
  @override
  final double x;
  @override
  final double y;
  @override
  final double radius;
  @override
  final double startAngle;
  @override
  final double endAngle;

  ArcEntity({
    required this.x,
    required this.y,
    required this.radius,
    required this.startAngle,
    required this.endAngle,
  });

  factory ArcEntity.fromAcDbEntity(AcDbArc arc) {
    return ArcEntity(
      x: arc.x,
      y: arc.y,
      radius: arc.radius,
      startAngle: arc.startAngle,
      endAngle: arc.endAngle,
    );
  }

  @override
  void draw(Offset ajust, Canvas canvas, Paint paint) {
    final rect = Rect.fromCircle(
      center: Offset(x, -y) + ajust,
      radius: radius,
    );

    if (endAngle - startAngle < 0) {
      canvas.drawArc(
        rect,
        -radians(endAngle),
        radians(360 - startAngle),
        false,
        paint,
      );

      canvas.drawArc(
        rect,
        -radians(startAngle),
        -radians(endAngle),
        false,
        paint..color,
      );
    } else {
      canvas.drawArc(
        rect,
        -radians(startAngle),
        -radians(endAngle - startAngle),
        false,
        paint,
      );
    }
  }

  @override
  bool hasColision(Entity other) {
    return false;
    if (other is ArcEntity) {
      final rect = Rect.fromCircle(
        center: Offset(x, -y),
        radius: radius,
      );

      final rect2 = Rect.fromCircle(
        center: Offset(other.x, -other.y),
        radius: other.radius,
      );

      return rect.overlaps(rect2);
    }
    return false;
  }
}
