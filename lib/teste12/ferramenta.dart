import 'package:dxf/dxf.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Ferramenta {
  final ValueNotifier<Offset> pos;
  final Color cor;
  final List<AcDbEntity> entities;

  Offset get position => pos.value;
  Size get size => Size(_width, _height);

  double _width = 0;
  double _height = 0;

  double? menorX;
  double? maiorX;
  double? menorY;
  double? maiorY;

  Ferramenta({
    required this.cor,
    this.entities = const [],
  }) : pos = ValueNotifier(const Offset(0, 0)) {
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
        // menorX ??= entity.y;
        // maiorX ??= entity.x;
        // menorY ??= entity.y;
        // maiorY ??= entity.y;

        // final xEnd = entity.x + entity.radius * cos(entity.endAngle);
        // final yEnd = entity.y + entity.radius * sin(entity.endAngle);

        // if (xEnd <= menorX!) menorX = xEnd;
        // if (yEnd <= menorY!) menorY = yEnd;
        // if (xEnd >= maiorX!) maiorX = xEnd;
        // if (yEnd >= maiorY!) maiorY = yEnd;

        // final xStart = entity.x + entity.radius * cos(entity.startAngle);
        // final yStart = entity.y + entity.radius * sin(entity.startAngle);

        // if (xStart <= menorX!) menorX = xStart;
        // if (yStart <= menorY!) menorY = yStart;
        // if (xStart >= maiorX!) maiorX = xStart;
        // if (yStart >= maiorY!) maiorY = yStart;
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

  bool _hasColision(Ferramenta ferramenta) {
    final ferramenta1 = this;
    final ferramenta2 = ferramenta;

    final x1 = ferramenta1.position.dx + menorX!;
    final y1 = ferramenta1.position.dy + menorY!;
    final x2 = ferramenta2.position.dx + ferramenta2.menorX!;
    final y2 = ferramenta2.position.dy + ferramenta2.menorY!;

    final w1 = ferramenta1.size.width;
    final h1 = ferramenta1.size.height;
    final w2 = ferramenta2.size.width;
    final h2 = ferramenta2.size.height;

    return x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2;
  }

  bool hasColision(List<Ferramenta> ferramentas) {
    for (var ferramenta in ferramentas) {
      if (ferramenta == this) continue;
      if (_hasColision(ferramenta)) return true;
    }
    return false;
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
