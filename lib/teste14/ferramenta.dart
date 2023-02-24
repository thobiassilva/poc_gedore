import 'dart:math';

import 'package:dxf/dxf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class Ferramenta {
  final ValueNotifier<Offset> pos = ValueNotifier(const Offset(0, 0));
  // final ValueNotifier<bool> collision = ValueNotifier(false);
  final Color cor;
  final List<AcDbEntity> entities;

  // bool get hasCollision => collision.value;
  Offset get position => pos.value;
  Size get size => Size(_width, _height);
  Offset get ajust => Offset(-menorX!, menorY! + _height);
  // Offset get ajust => const Offset(0, 0);

  // set hasCollision(bool value) => collision.value = value;

  double _width = 0;
  double _height = 0;

  double? menorX;
  double? maiorX;
  double? menorY;
  double? maiorY;

  List<Rect> hitboxes = [];

  Ferramenta({
    required this.cor,
    this.entities = const [],
  }) {
    _calcTam();
    _calcHitboxes();
  }

  void _calcHitboxes() {
    for (var entity in entities) {
      if (entity is AcDbCircle) {
        hitboxes.add(getCircleHitbox(entity));
      }
      if (entity is AcDbLine) {
        hitboxes.add(getLineHitbox(entity));
      }
      if (entity is AcDbArc) {
        hitboxes.add(getArcHitbox(entity));
      }
    }
  }

  bool hasCollision(List<Ferramenta> otherFerramentas) {
    for (var otherFerramenta in otherFerramentas) {
      if (otherFerramenta == this) continue;

      for (var hitbox in hitboxes) {
        for (var otherHitbox in otherFerramenta.hitboxes) {
          // print(position);
          // final tempAjut = Offset(menorX!, menorY!) -
          //     Offset(otherFerramenta.menorX!, -otherFerramenta.menorY!);
          // final ajust = Offset(tempAjut.dx, tempAjut.dy);
          // print(otherFerramenta.menorY);
          // final rect1 = hitbox.shift(position + const Offset(-2, 22));
          final rect1 = hitbox.shift(position);
          // final rect1 = hitbox.shift(position + ajust);
          final rect2 = otherHitbox.shift(otherFerramenta.position);

          if (rect1.overlaps(rect2)) return true;
        }
      }
    }

    return false;
  }

  void _calcTam() {
    for (var entity in entities) {
      if (entity is AcDbCircle) {
        menorX ??= entity.x;
        maiorX ??= entity.x;
        menorY ??= entity.y;
        maiorY ??= entity.y;

        if (entity.x - entity.radius <= menorX!) {
          menorX = entity.x - entity.radius;
        }
        if (entity.y - entity.radius <= menorY!) {
          menorY = entity.y - entity.radius;
        }
        if (entity.x + entity.radius >= maiorX!) {
          maiorX = entity.x + entity.radius;
        }
        if (entity.y + entity.radius >= maiorY!) {
          maiorY = entity.y + entity.radius;
        }
      }

      if (entity is AcDbLine) {
        menorX ??= entity.y;
        maiorX ??= entity.x;
        menorY ??= entity.y;
        maiorY ??= entity.y;

        if (entity.x <= menorX!) menorX = entity.x;
        if (entity.y <= menorY!) menorY = entity.y;
        if (entity.x >= maiorX!) maiorX = entity.x;
        if (entity.y >= maiorY!) maiorY = entity.y;
      }

      if (entity is AcDbArc) {
        menorX ??= entity.y;
        maiorX ??= entity.x;
        menorY ??= entity.y;
        maiorY ??= entity.y;

        final xEnd = entity.x + entity.radius * cos(radians(entity.endAngle));
        final yEnd = entity.y + entity.radius * sin(radians(entity.endAngle));

        if (xEnd <= menorX!) menorX = xEnd;
        if (yEnd <= menorY!) menorY = yEnd;
        if (xEnd >= maiorX!) maiorX = xEnd;
        if (yEnd >= maiorY!) maiorY = yEnd;

        final xStart =
            entity.x + entity.radius * cos(radians(entity.startAngle));
        final yStart =
            entity.y + entity.radius * sin(radians(entity.startAngle));

        if (xStart <= menorX!) menorX = xStart;
        if (yStart <= menorY!) menorY = yStart;
        if (xStart >= maiorX!) maiorX = xStart;
        if (yStart >= maiorY!) maiorY = yStart;
      }
    }

    menorX ??= 0;
    maiorX ??= 0;
    menorY ??= 0;
    maiorY ??= 0;

    _width = maiorX! - menorX!;
    _height = maiorY! - menorY!;
  }

  void setPosition(Offset delta) {
    Offset tempPos = position;
    tempPos += Offset(delta.dx, -delta.dy);
    if (isInside(tempPos)) {
      pos.value = tempPos;
    }
  }

  bool isInside(Offset position) {
    final x = position.dx;
    final y = position.dy;

    return x >= 0 - menorX! &&
        x <= 800 - menorX! - size.width &&
        y >= 0 - menorY! &&
        y <= 800 - maiorY!;
  }

  // bool _hasColision(Ferramenta ferramenta) {
  //   final ferramenta1 = this;
  //   final ferramenta2 = ferramenta;

  //   final x1 = ferramenta1.position.dx + menorX!;
  //   final y1 = ferramenta1.position.dy + menorY!;
  //   final x2 = ferramenta2.position.dx + ferramenta2.menorX!;
  //   final y2 = ferramenta2.position.dy + ferramenta2.menorY!;

  //   final w1 = ferramenta1.size.width;
  //   final h1 = ferramenta1.size.height;
  //   final w2 = ferramenta2.size.width;
  //   final h2 = ferramenta2.size.height;

  //   return x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2;
  // }

  // bool hasColision(List<Ferramenta> ferramentas) {
  //   for (var ferramenta in ferramentas) {
  //     if (ferramenta == this) continue;

  //     // if (_hasColision(ferramenta)) return true;

  //     // Don't work
  //     for (var entity1 in entities) {
  //       for (var entity2 in ferramenta.entities) {
  //         // if (entity1.hasColision(entity2)) return true;

  //         if (entity1 is AcDbCircle && entity2 is AcDbCircle) {
  //           final x1 = entity1.x + position.dx;
  //           final y1 = entity1.y + position.dy;
  //           final x2 = entity2.x + ferramenta.position.dx;
  //           final y2 = entity2.y + ferramenta.position.dy;

  //           final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //           if (distance <= entity1.radius + entity2.radius) {
  //             return true;
  //           }
  //         }

  //         if (entity1 is AcDbLine && entity2 is AcDbLine) {
  //           final x1 = entity1.x + position.dx;
  //           final y1 = entity1.y + position.dy;
  //           final x2 = entity2.x + ferramenta.position.dx;
  //           final y2 = entity2.y + ferramenta.position.dy;

  //           final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //           // if (distance <= entity1.thickness + entity2.thickness) {
  //           if (distance <= 1 + 1) {
  //             return true;
  //           }
  //         }

  //         // if (entity1 is AcDbArc && entity2 is AcDbArc) {
  //         //   final x1 = entity1.x + position.dx;
  //         //   final y1 = entity1.y + position.dy;
  //         //   final x2 = entity2.x + ferramenta.position.dx;
  //         //   final y2 = entity2.y + ferramenta.position.dy;

  //         //   final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //         //   if (distance <= entity1.radius + entity2.radius) {
  //         //     return true;
  //         //   }
  //         // }

  //         if (entity1 is AcDbLine && entity2 is AcDbCircle) {
  //           final x1 = entity1.x + position.dx;
  //           final y1 = entity1.y + position.dy;
  //           final x2 = entity2.x + ferramenta.position.dx;
  //           final y2 = entity2.y + ferramenta.position.dy;

  //           final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //           // if (distance <= entity1.thickness + entity2.radius) {
  //           if (distance <= 1 + entity2.radius) {
  //             return true;
  //           }
  //         }

  //         // if (entity1 is AcDbLine && entity2 is AcDbArc) {
  //         //   final x1 = entity1.x + position.dx;
  //         //   final y1 = entity1.y + position.dy;
  //         //   final x2 = entity2.x + ferramenta.position.dx;
  //         //   final y2 = entity2.y + ferramenta.position.dy;

  //         //   final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //         //   // if (distance <= entity1.thickness + entity2.radius) {
  //         //   if (distance <= 1 + entity2.radius) {
  //         //     return true;
  //         //   }
  //         // }

  //         if (entity1 is AcDbCircle && entity2 is AcDbLine) {
  //           final x1 = entity1.x + position.dx;
  //           final y1 = entity1.y + position.dy;
  //           final x2 = entity2.x + ferramenta.position.dx;
  //           final y2 = entity2.y + ferramenta.position.dy;

  //           final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //           // if (distance <= entity1.radius + entity2.thickness) {
  //           if (distance <= entity1.radius) {
  //             return true;
  //           }
  //         }

  //         // if (entity1 is AcDbCircle && entity2 is AcDbArc) {
  //         //   final x1 = entity1.x + position.dx;
  //         //   final y1 = entity1.y + position.dy;
  //         //   final x2 = entity2.x + ferramenta.position.dx;
  //         //   final y2 = entity2.y + ferramenta.position.dy;

  //         //   final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //         //   if (distance <= entity1.radius + entity2.radius) {
  //         //     return true;
  //         //   }
  //         // }

  //         // if (entity1 is AcDbArc && entity2 is AcDbLine) {
  //         //   final x1 = entity1.x + position.dx;
  //         //   final y1 = entity1.y + position.dy;
  //         //   final x2 = entity2.x + ferramenta.position.dx;
  //         //   final y2 = entity2.y + ferramenta.position.dy;

  //         //   final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //         //   // if (distance <= entity1.radius + entity2.thickness) {
  //         //   if (distance <= entity1.radius + 1) {
  //         //     return true;
  //         //   }
  //         // }

  //         // if (entity1 is AcDbArc && entity2 is AcDbCircle) {
  //         //   final x1 = entity1.x + position.dx;
  //         //   final y1 = entity1.y + position.dy;
  //         //   final x2 = entity2.x + ferramenta.position.dx;
  //         //   final y2 = entity2.y + ferramenta.position.dy;

  //         //   final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //         //   if (distance <= entity1.radius + entity2.radius) {
  //         //     return true;
  //         //   }
  //         // }

  //         if (entity1 is AcDbLine && entity2 is AcDbLine) {
  //           final x1 = entity1.x + position.dx;
  //           final y1 = entity1.y + position.dy;
  //           final x2 = entity2.x + ferramenta.position.dx;
  //           final y2 = entity2.y + ferramenta.position.dy;

  //           final distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

  //           // if (distance <= entity1.thickness + entity2.thickness) {
  //           if (distance <= 1 + 1) {
  //             return true;
  //           }
  //         }
  //       }
  //     }
  //   }

  //   return false;
  // }

  void drawHitboxes(Canvas canvas) {
    final hitboxPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    for (var hitbox in hitboxes) {
      canvas.drawRect(hitbox, hitboxPaint);
    }
  }

  // bool hasCollision(List<Ferramenta> ferramentas) {
  //   for (var ferramenta in ferramentas) {
  //     for (var entity1 in entities) {
  //       for (var entity2 in ferramenta.entities) {
  //         if (entity1 is AcDbLine && entity2 is AcDbLine) {
  //           final rect1 = getLineHitbox(entity1);
  //           final rect2 = ferramenta.getLineHitbox(entity2);
  //           return rect1.overlaps(rect2);
  //         }

  //         // if (entity1 is AcDbLine && entity2 is AcDbCircle) {
  //         //   final rect1 = getLineHitbox(entity1);
  //         //   final rect2 = ferramenta.getCircleHitbox(entity2);
  //         //   return rect1.overlaps(rect2);
  //         // }

  //         // if (entity1 is AcDbLine && entity2 is AcDbArc) {
  //         //   final rect1 = getLineHitbox(entity1);
  //         //   final rect2 = ferramenta.getArcHitbox(entity2);
  //         //   return rect1.overlaps(rect2);
  //         // }

  //         // if (entity1 is AcDbCircle && entity2 is AcDbLine) {
  //         //   final rect1 = getCircleHitbox(entity1);
  //         //   final rect2 = ferramenta.getLineHitbox(entity2);
  //         //   return rect1.overlaps(rect2);
  //         // }

  //         if (entity1 is AcDbCircle && entity2 is AcDbCircle) {
  //           final rect1 = getCircleHitbox(entity1);
  //           final rect2 = ferramenta.getCircleHitbox(entity2);
  //           return rect1.overlaps(rect2);
  //         }

  //         // if (entity1 is AcDbCircle && entity2 is AcDbArc) {
  //         //   final rect1 = getCircleHitbox(entity1);
  //         //   final rect2 = ferramenta.getArcHitbox(entity2);
  //         //   return rect1.overlaps(rect2);
  //         // }

  //         // if (entity1 is AcDbArc && entity2 is AcDbLine) {
  //         //   final rect1 = getArcHitbox(entity1);
  //         //   final rect2 = ferramenta.getLineHitbox(entity2);
  //         //   return rect1.overlaps(rect2);
  //         // }

  //         // if (entity1 is AcDbArc && entity2 is AcDbCircle) {
  //         //   final rect1 = getArcHitbox(entity1);
  //         //   final rect2 = ferramenta.getCircleHitbox(entity2);
  //         //   return rect1.overlaps(rect2);
  //         // }

  //         // if (entity1 is AcDbArc && entity2 is AcDbArc) {
  //         //   final rect1 = getArcHitbox(entity1);
  //         //   final rect2 = ferramenta.getArcHitbox(entity2);
  //         //   return rect1.overlaps(rect2);
  //         // }
  //       }
  //     }
  //   }

  //   return false;
  // }

  Rect getArcHitbox(AcDbArc arc) {
    return Rect.fromPoints(
      _getArcStart(arc),
      _getArcEnd(arc),
    ).inflate(6);
  }

  Rect getLineHitbox(AcDbLine line) {
    return Rect.fromPoints(
      Offset(line.x, -line.y) + ajust,
      Offset(line.x1, -line.y1) + ajust,
    ).inflate(6);
  }

  Rect getCircleHitbox(AcDbCircle circle) {
    return Rect.fromPoints(
      Offset(circle.x, -circle.y) + ajust,
      Offset(circle.x, -circle.y) + ajust,
    ).inflate(circle.radius * 1.6);
  }

  Offset _getArcStart(AcDbArc entity) {
    final startAngle = radians(entity.startAngle);

    final start = Offset(
      entity.x + entity.radius * cos(startAngle),
      -entity.y + entity.radius * -sin(startAngle),
    );

    return start + ajust;
  }

  Offset _getArcEnd(AcDbArc entity) {
    final endAngle = radians(entity.endAngle);

    final end = Offset(
      entity.x + entity.radius * cos(endAngle),
      -entity.y + entity.radius * -sin(endAngle),
    );

    return end + ajust;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ferramenta &&
        other.pos == pos &&
        other.cor == cor &&
        listEquals(other.entities, entities) &&
        other._width == _width &&
        other._height == _height &&
        other.menorX == menorX &&
        other.maiorX == maiorX &&
        other.menorY == menorY &&
        other.maiorY == maiorY;
  }

  @override
  int get hashCode {
    return pos.hashCode ^
        cor.hashCode ^
        entities.hashCode ^
        _width.hashCode ^
        _height.hashCode ^
        menorX.hashCode ^
        maiorX.hashCode ^
        menorY.hashCode ^
        maiorY.hashCode;
  }
}
