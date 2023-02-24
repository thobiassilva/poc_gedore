import 'dart:math';

import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:poc_gedore/extension_methods.dart';
import 'package:poc_gedore/teste14/teste14.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'ferramenta.dart';

class FerramentaWidget extends StatelessWidget {
  final Ferramenta ferramenta;
  final MyStore myStore;

  const FerramentaWidget({
    Key? key,
    required this.ferramenta,
    required this.myStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder<bool>(
    //   valueListenable: ferramenta.collision,
    //   builder: (context, hasCollision, child) {
    //     return Container(
    //       width: ferramenta.size.width,
    //       height: ferramenta.size.height,
    //       color: hasCollision ? Colors.red : Colors.black26,
    //       child: GestureDetector(
    //         onPanUpdate: (details) {
    //           ferramenta.setPosition(details.delta);
    //           myStore.verifyHasCollision(ferramenta);
    //         },
    //         child: CustomPaint(
    //           painter: FerramentaPainter(
    //             entities: ferramenta.entities,
    //             ferramenta: ferramenta,
    //             menorX: ferramenta.menorX ?? 0,
    //             menorY: ferramenta.menorY ?? 0,
    //           ),
    //           // child: const Center(),
    //         ),
    //       ),
    //     );
    //   },
    // );
    return Container(
      width: ferramenta.size.width,
      height: ferramenta.size.height,
      // color: ferramenta.hasCollision(myStore.ferramentas)
      //     ? Colors.red
      //     : Colors.black26,
      color: Colors.black26,
      child: GestureDetector(
        onPanUpdate: (details) {
          ferramenta.setPosition(details.delta);
          // print(ferramenta.size);
          // myStore.verifyHasCollision(ferramenta);
        },
        child: CustomPaint(
          painter: FerramentaPainter(
            entities: ferramenta.entities,
            ferramenta: ferramenta,
            menorX: ferramenta.menorX ?? 0,
            menorY: ferramenta.menorY ?? 0,
          ),
          // child: const Center(),
        ),
      ),
    );
  }
}

class FerramentaPainter extends CustomPainter {
  final Ferramenta ferramenta;
  final List<AcDbEntity> entities;
  final double menorX;
  final double menorY;

  const FerramentaPainter({
    required this.entities,
    required this.ferramenta,
    required this.menorX,
    required this.menorY,
  });
  @override
  void paint(Canvas canvas, Size size) {
    // final ajust = Offset(-menorX, menorY + size.height);
    final ajust = ferramenta.ajust;

    for (var entity in entities) {
      drawEntity(entity, ajust, canvas);
      // drawHitbox(entity, ajust, canvas);
    }

    for (var element in ferramenta.hitboxes) {
      canvas.drawRect(
        element,
        Paint()
          ..color = Colors.green
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void drawEntity(AcDbEntity entity, Offset ajust, Canvas canvas) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    if (entity is AcDbCircle) {
      drawCircle(entity, ajust, canvas, paint);
    }
    if (entity is AcDbLine) {
      drawLine(entity, ajust, canvas, paint);
    }
    if (entity is AcDbArc) {
      drawArc(entity, ajust, canvas, paint);
    }
  }

  void drawHitbox(AcDbEntity entity, Offset ajust, Canvas canvas) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    if (entity is AcDbCircle) {
      // canvas.drawCircle(
      //   Offset(entity.x, -entity.y) + ajust,
      //   entity.radius * 1.4,
      //   paint,
      // );

      canvas.drawRect(
        Rect.fromPoints(
          Offset(entity.x, -entity.y) + ajust,
          Offset(entity.x, -entity.y) + ajust,
        ).inflate(entity.radius * 1.6),
        paint,
      );
    }
    if (entity is AcDbLine) {
      canvas.drawRect(
        Rect.fromPoints(
          Offset(entity.x, -entity.y) + ajust,
          Offset(entity.x1, -entity.y1) + ajust,
        ).inflate(6),
        paint,
      );
    }
    if (entity is AcDbArc) {
      canvas.drawRect(
        Rect.fromPoints(
          getArcStart(entity, ajust),
          getArcEnd(entity, ajust),
        ).inflate(6),
        paint,
      );
    }
  }

  Offset getArcStart(AcDbArc entity, Offset ajust) {
    final startAngle = radians(entity.startAngle);

    final start = Offset(
      entity.x + entity.radius * cos(startAngle),
      -entity.y + entity.radius * -sin(startAngle),
    );

    // canvas.drawCircle(start + ajust, 2, paint);
    return start + ajust;
  }

  Offset getArcEnd(AcDbArc entity, Offset ajust) {
    final endAngle = radians(entity.endAngle);

    final end = Offset(
      entity.x + entity.radius * cos(endAngle),
      -entity.y + entity.radius * -sin(endAngle),
    );

    // canvas.drawCircle(end + ajust, 2, paint);
    return end + ajust;
  }

  Offset findTheNearestPoint(
      List<AcDbEntity> entities, AcDbEntity entity, Offset ajust) {
    final points = <Offset>[];
    for (var entity in entities) {
      // if (entity is AcDbCircle) points.add(Offset(entity.x, -entity.y) + ajust);
      if (entity is AcDbLine) points.add(Offset(entity.x, -entity.y) + ajust);
      if (entity is AcDbArc) {
        points.add(getArcStart(entity, ajust));
        points.add(getArcEnd(entity, ajust));
      }
    }

    // if (entity is AcDbCircle) {
    //   return points.reduce((value, element) =>
    //       value.distanceTo(Offset(entity.x, -entity.y) + ajust) <
    //               element.distanceTo(Offset(entity.x, -entity.y) + ajust)
    //           ? value
    //           : element);
    // }

    if (entity is AcDbLine) {
      return points.reduce((value, element) =>
          value.distanceTo(Offset(entity.x, -entity.y) + ajust) <
                  element.distanceTo(Offset(entity.x, -entity.y) + ajust)
              ? value
              : element);
    }

    if (entity is AcDbArc) {
      return points.reduce((value, element) =>
          value.distanceTo(Offset(entity.x, -entity.y) + ajust) <
                  element.distanceTo(Offset(entity.x, -entity.y) + ajust)
              ? value
              : element);
    }

    return Offset.zero;
  }

  void drawRotated(
    Canvas canvas,
    Offset center,
    double angle,
    VoidCallback drawFunction,
  ) {
    canvas.save();
    // canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    // canvas.translate(-center.dx, -center.dy);
    drawFunction();
    canvas.restore();
  }

  void drawLine(AcDbLine entity, Offset ajust, Canvas canvas, Paint paint) {
    canvas.drawLine(
      Offset(entity.x, -entity.y) + ajust,
      Offset(entity.x1, -entity.y1) + ajust,
      paint,
    );
  }

  void drawCircle(AcDbCircle entity, Offset ajust, Canvas canvas, Paint paint) {
    canvas.drawCircle(
      Offset(entity.x, -entity.y) + ajust,
      entity.radius,
      paint,
    );
  }

  void drawArc(AcDbArc entity, Offset ajust, Canvas canvas, Paint paint) {
    final rect = Rect.fromCircle(
      center: Offset(entity.x, -entity.y) + ajust,
      radius: entity.radius,
    );

    if (entity.endAngle - entity.startAngle < 0) {
      canvas.drawArc(
        rect,
        -radians(entity.endAngle),
        radians(360 - entity.startAngle),
        false,
        paint,
      );

      canvas.drawArc(
        rect,
        -radians(entity.startAngle),
        -radians(entity.endAngle),
        false,
        paint..color,
      );
    } else {
      canvas.drawArc(
        rect,
        -radians(entity.startAngle),
        -radians(entity.endAngle - entity.startAngle),
        false,
        paint,
      );
    }
  }

  void drawPathLine(AcDbLine entity, Offset ajust, Path path) {
    path.moveTo(entity.x + ajust.dx, -entity.y + ajust.dy);
    path.lineTo(entity.x1 + ajust.dx, -entity.y1 + ajust.dy);
  }

  void drawPathCircle(AcDbCircle entity, Offset ajust, Path path) {
    path.addOval(
      Rect.fromCircle(
        center: Offset(entity.x, -entity.y) + ajust,
        radius: entity.radius,
      ),
    );
  }

  void drawPathArc(AcDbArc entity, Offset ajust, Path path) {
    final rect = Rect.fromCircle(
      center: Offset(entity.x, -entity.y) + ajust,
      radius: entity.radius,
    );

    if (entity.endAngle - entity.startAngle < 0) {
      path.arcTo(
        rect,
        -radians(entity.endAngle),
        radians(360 - entity.startAngle),
        false,
      );

      path.arcTo(
        rect,
        -radians(entity.startAngle),
        -radians(entity.endAngle),
        false,
      );
    } else {
      path.arcTo(
        rect,
        -radians(entity.startAngle),
        -radians(entity.endAngle - entity.startAngle),
        false,
      );
    }
  }

  void sortByNearestPoint(List<AcDbEntity> entities, Offset ajust) {
    entities.sort((a, b) {
      final aPoint = findTheNearestPoint(entities, a, ajust);
      final bPoint = findTheNearestPoint(entities, b, ajust);

      return aPoint.distanceTo(Offset.zero) > bPoint.distanceTo(Offset.zero)
          ? 1
          : -1;
    });
  }

  @override
  bool shouldRepaint(covariant FerramentaPainter oldDelegate) => true;
}
