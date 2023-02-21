import 'dart:ui' as ui;

import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'ferramenta.dart';

class CustomWidget extends StatelessWidget {
  final Ferramenta ferramenta;

  const CustomWidget({
    Key? key,
    required this.ferramenta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: ferramenta.size.width,
        height: ferramenta.size.height,
        child: Material(
          shape: CustomShape(
            entities: ferramenta.entities,
            size: ferramenta.size,
          ),
          color: Colors.orange,
          child: GestureDetector(
            onPanUpdate: (details) => ferramenta.setPosition(details.delta),
          ),
        ),
      ),
    );
  }
}

class CustomShape extends ShapeBorder {
  final List<AcDbEntity> entities;
  final Size size;
  const CustomShape({
    required this.entities,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Rect rect, {ui.TextDirection? textDirection}) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.square;

    for (var entity in entities) {
      if (entity is AcDbCircle) {
        canvas.drawCircle(Offset(entity.x, -entity.y), entity.radius, paint);
      }

      if (entity is AcDbLine) {
        canvas.drawLine(Offset(entity.x, -entity.y + size.height),
            Offset(entity.x1, -entity.y1 + size.height), paint);
      }

      if (entity is AcDbArc) {
        if (entity.endAngle - entity.startAngle < 0) {
          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(entity.x, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.endAngle),
            radians(360 - entity.startAngle),
            false,
            paint..color,
          );

          canvas.drawArc(
            Rect.fromCircle(
              center: Offset(entity.x, -entity.y + size.height),
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
              center: Offset(entity.x, -entity.y + size.height),
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
  Path getOuterPath(Rect rect, {ui.TextDirection? textDirection}) {
    return Path()..addRect(rect);
    final path = Path();

    for (var entity in entities) {
      if (entity is AcDbLine) {
        path.addPolygon(
          [
            Offset(entity.x, -entity.y + size.height),
            Offset(
              entity.x1,
              -entity.y1,
            ),
          ],
          true,
        );
        // path.addRect(Rect.fromPoints(
        //   Offset(entity.x, -entity.y),
        //   Offset(
        //     entity.x1,
        //     -entity.y1,
        //   ),
        // ));
      }

      if (entity is AcDbArc) {
        if (entity.endAngle - entity.startAngle < 0) {
          path.addArc(
            Rect.fromCircle(
              center: Offset(entity.x, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.endAngle),
            radians(360 - entity.startAngle),
          );

          path.addArc(
            Rect.fromCircle(
              center: Offset(entity.x, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.startAngle),
            -radians(entity.endAngle),
          );
        } else {
          path.addArc(
            Rect.fromCircle(
              center: Offset(entity.x, -entity.y + size.height),
              radius: entity.radius,
            ),
            -radians(entity.startAngle),
            -radians(entity.endAngle - entity.startAngle),
          );
        }
      }
    }
    return path;
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  ShapeBorder scale(double t) => CustomShape(entities: entities, size: size);
}
