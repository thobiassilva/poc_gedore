import 'package:flutter/material.dart';

class Ferramenta {
  final ValueNotifier<Offset> pos;
  final Size size;
  final Color cor;

  Offset get position => pos.value;

  Ferramenta({
    Offset? pos,
    required this.size,
    required this.cor,
  }) : pos = ValueNotifier(pos ?? Offset(size.width / 2, size.height / 2));

  Ferramenta.circle({
    Offset? pos,
    required double radius,
    required this.cor,
  })  : pos = ValueNotifier(pos ?? Offset(radius, radius)),
        size = Size(radius, radius);

  void setPosition(Offset delta) {
    Offset tempPos = position;
    tempPos += Offset(delta.dx, -delta.dy);
    if (posIsValid(tempPos)) {
      pos.value = tempPos;
    }
  }

  bool posIsValid(Offset pos) =>
      pos.dx >= 0 + size.width &&
      pos.dy >= 0 + size.width &&
      pos.dx <= (800 - size.width) &&
      pos.dy <= (800 - size.width);
}
