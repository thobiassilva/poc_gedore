import 'dart:math';
import 'dart:ui';

extension OffsetExtension on Offset {
  Offset operator +(Offset other) => Offset(dx + other.dx, dy + other.dy);
  Offset operator -(Offset other) => Offset(dx - other.dx, dy - other.dy);
  Offset operator *(double scale) => Offset(dx * scale, dy * scale);
  Offset operator /(double scale) => Offset(dx / scale, dy / scale);

  double distanceTo(Offset other) =>
      sqrt(pow(dx - other.dx, 2) + pow(dy - other.dy, 2));
}
