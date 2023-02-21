import 'package:dxf/dxf.dart';
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
    if (posIsValid(tempPos)) {
      pos.value = tempPos;
    }
  }

  bool posIsValid(Offset pos) => true;
  // pos.dx >= 0 + size.width &&
  // pos.dy >= 0 + size.width &&
  // pos.dx <= (800 - size.width) &&
  // pos.dy <= (800 - size.width);
}
