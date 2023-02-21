import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'ferramenta.dart';

class FerramentaWidget extends StatelessWidget {
  final Ferramenta ferramenta;

  const FerramentaWidget({
    Key? key,
    required this.ferramenta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ferramenta.size.width,
      height: ferramenta.size.height,
      color: Colors.black26,
      child: GestureDetector(
        onPanUpdate: (details) => ferramenta.setPosition(details.delta),
        child: CustomPaint(
          painter: FerramentaPainter(
            color: ferramenta.cor,
            entities: ferramenta.entities,
          ),
          // child: const Center(),
        ),
      ),
    );
  }
}

class FerramentaPainter extends CustomPainter {
  final Color color;
  final List<AcDbEntity> entities;
  const FerramentaPainter({
    required this.color,
    required this.entities,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.square;

    // for (var entity in entities) {
    //   if (entity is AcDbLine) {
    //     path.addRect(Rect.fromPoints(
    //       Offset(entity.x, -entity.y),
    //       Offset(
    //         entity.x1,
    //         -entity.y1,
    //       ),
    //     ));
    //   }

    //   if (entity is AcDbArc) {
    //     if (entity.endAngle - entity.startAngle < 0) {
    //       path.addArc(
    //         Rect.fromCircle(
    //           center: Offset(entity.x, -entity.y),
    //           radius: entity.radius,
    //         ),
    //         -radians(entity.endAngle),
    //         radians(360 - entity.startAngle),
    //       );

    //       path.addArc(
    //         Rect.fromCircle(
    //           center: Offset(entity.x, -entity.y),
    //           radius: entity.radius,
    //         ),
    //         -radians(entity.startAngle),
    //         -radians(entity.endAngle),
    //       );
    //     } else {
    //       path.addArc(
    //         Rect.fromCircle(
    //           center: Offset(entity.x, -entity.y),
    //           radius: entity.radius,
    //         ),
    //         -radians(entity.startAngle),
    //         -radians(entity.endAngle - entity.startAngle),
    //       );
    //     }
    //   }
    // }

    // canvas.drawPath(path, paint);

    for (var entity in entities) {
      if (entity is AcDbCircle) {
        canvas.drawCircle(
            Offset(entity.x - size.width, -entity.y), entity.radius, paint);
      }

      if (entity is AcDbLine) {
        canvas.drawLine(Offset(entity.x - size.width, -entity.y + size.height),
            Offset(entity.x1 - size.width, -entity.y1 + size.height), paint);
      }

      if (entity is AcDbArc) {
        if (entity.endAngle - entity.startAngle < 0) {
          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(entity.x - size.width, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.endAngle),
            radians(360 - entity.startAngle),
            false,
            paint..color,
          );

          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(entity.x - size.width, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.startAngle),
            -radians(entity.endAngle),
            false,
            paint..color,
          );
        } else {
          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(entity.x - size.width, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.startAngle),
            -radians(entity.endAngle - entity.startAngle),
            false,
            paint..color,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant FerramentaPainter oldDelegate) => true;
}
