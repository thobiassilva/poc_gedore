import 'dart:ui';

import 'package:dxf/dxf.dart';

mixin Entity implements AcDbEntity {
  void draw(Offset ajust, Canvas canvas, Paint paint) {}
  // bool hasColision(Entity other);
}
