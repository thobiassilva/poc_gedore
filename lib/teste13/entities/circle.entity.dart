import 'dart:math';

import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';

import 'entity.dart';

class CircleEntity extends AcDbCircle implements Entity {
  @override
  final double x;
  @override
  final double y;
  @override
  final double radius;

  Offset get center => Offset(x, y);

  CircleEntity({
    required this.x,
    required this.y,
    required this.radius,
  });

  factory CircleEntity.fromAcDbEntity(AcDbCircle circle) {
    return CircleEntity(
      x: circle.x,
      y: circle.y,
      radius: circle.radius,
    );
  }

  @override
  void draw(Offset ajust, Canvas canvas, Paint paint) {
    canvas.drawCircle(
      Offset(x, -y) + ajust,
      radius,
      paint,
    );
  }

  bool hasColisionWithCircle({
    required CircleEntity other,
    required Offset otherPosition,
    required Offset thisPosition,
  }) {
    final distance = sqrt(
      pow(x + thisPosition.dx - other.x + otherPosition.dx, 2) +
          pow(y + thisPosition.dy - other.y + otherPosition.dy, 2),
    );
    return distance < radius + other.radius;
  }

  // bool hasColisionWithLine({
  //   required LineEntity other,
  //   required Offset otherPosition,
  //   required Offset thisPosition,
  // }) {
  //   // is either end INSIDE the circle?
  //   // if so, return true immediately
  //   bool inside1 = _pointCircle(Offset(other.x, other.y), center, radius);
  //   bool inside2 = _pointCircle(Offset(other.x1, other.y1), center, radius);
  //   if (inside1 || inside2) return true;

  //   // get length of the line
  //   double distX = other.x1 - other.x;
  //   double distY = other.y1 - other.y;
  //   double length = sqrt((distX * distX) + (distY * distY));

  //   // get dot product of the line and circle
  //   double dot = (((center.dx - other.x) * (other.x1 - other.x)) +
  //           ((center.dy - other.y) * (other.y1 - other.y))) /
  //       pow(length, 2);

  //   // find the closest point on the line
  //   double closestX = other.x + (dot * (other.x1 - other.x));
  //   double closestY = other.y + (dot * (other.y1 - other.y));

  //   // is this point actually on the line segment?
  //   // if so keep going, but if not, return false
  //   bool onSegment =
  //       linePoint(other.x, other.y, other.x1, other.y1, closestX, closestY);
  //   if (!onSegment) return false;

  //   // get distance to closest point
  //   distX = closestX - x;
  //   distY = closestY - y;
  //   double distance = sqrt((distX * distX) + (distY * distY));

  //   if (distance <= radius) {
  //     return true;
  //   }
  //   return false;
  // }

  // bool _pointCircle(Offset point, Offset center, double radius) {
  //   final distance = sqrt(
  //     pow(point.dx - center.dx, 2) + pow(point.dy - center.dy, 2),
  //   );
  //   return distance < radius;
  // }

  // bool _linePoint(Offset a, Offset b, Offset point) {
  //   // get distance from the point to the two ends of the line
  //   // double d1 = dist(px, py, x1, y1);
  //   // double d2 = dist(px, py, x2, y2);

  //   // get the length of the line
  //   double lineLen = dist(x1, y1, x2, y2);

  //   // since floats are so minutely accurate, add
  //   // a little buffer zone that will give collision
  //   double buffer = 0.1; // higher # = less accurate

  //   // if the two distances are equal to the line's
  //   // length, the point is on the line!
  //   // note we use the buffer here to give a range,
  //   // rather than one #
  //   if (d1 + d2 >= lineLen - buffer && d1 + d2 <= lineLen + buffer) {
  //     return true;
  //   }

  //   return false;
  // }
}
