import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';

import 'entity.dart';

class LineEntity extends AcDbLine implements Entity {
  @override
  final double x;
  @override
  final double y;
  @override
  final double x1;
  @override
  final double y1;

  LineEntity({
    required this.x,
    required this.y,
    required this.x1,
    required this.y1,
  });

  factory LineEntity.fromAcDbEntity(AcDbLine line) {
    return LineEntity(
      x: line.x,
      y: line.y,
      x1: line.x1,
      y1: line.y1,
    );
  }

  @override
  void draw(Offset ajust, Canvas canvas, Paint paint) {
    canvas.drawLine(
      Offset(x, -y) + ajust,
      Offset(x1, -y1) + ajust,
      paint,
    );
  }

  @override
  bool hasColision(Entity other) {
    return false;
    if (other is LineEntity) {
      // calculate the distance to intersection point
      double uA = ((other.x1 - other.x) * (y - other.y) -
              (other.y1 - other.y) * (x - other.x)) /
          ((other.y1 - other.y) * (x1 - x) - (other.x1 - other.x) * (y1 - y));

      double uB = ((x1 - x) * (y - other.y) - (y1 - y) * (x - other.x)) /
          ((other.y1 - other.y) * (x1 - x) - (other.x1 - other.x) * (y1 - y));

      // if uA and uB are between 0-1, lines are colliding
      if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
        return true;
      }
    }
    return false;
  }
}
