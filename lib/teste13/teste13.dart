import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:poc_gedore/main.dart';
import 'package:poc_gedore/teste13/entities/arc.entity.dart';
import 'package:poc_gedore/teste13/entities/circle.entity.dart';
import 'package:poc_gedore/teste13/entities/line.entity.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import '../background.painter.dart';
import 'ferramenta.dart';
import 'ferramenta.widget.dart';
import 'visualizacao.dart';

class Teste13 extends StatefulWidget {
  const Teste13({
    Key? key,
  }) : super(key: key);

  @override
  State<Teste13> createState() => _Teste13State();
}

class _Teste13State extends State<Teste13> {
  DXF dxf = DXF.create();

  final double tam = 25;

  Color color = Colors.white;

  final List<Ferramenta> ferramentas = [];

  void sendToApi() {
    final dio = Dio(BaseOptions(baseUrl: Constants.API_URL));
    dio.post(
      '/save',
      data: {
        'texto': dxf.dxfString,
      },
    );
  }

  void gerar() {
    dxf = DXF.create();
    for (var ferramenta in ferramentas) {
      ferramentaToDxf(ferramenta);
    }
  }

  void visualizar() {
    showBottomSheet(
      enableDrag: false,
      context: context,
      builder: (context) {
        return Visualizacao(dxfString: dxf.dxfString);
      },
    );
  }

  void visualizarDaApi() async {
    final dio = Dio(BaseOptions(baseUrl: Constants.API_URL));
    final result = await dio.get('/file');

    // ignore: use_build_context_synchronously
    showBottomSheet(
      enableDrag: false,
      context: context,
      builder: (context) {
        return Visualizacao(dxfString: result.data);
      },
    );
  }

  void rotateLine(LineEntity line) {
    final dx = line.x1 - line.x;
    final dy = line.y1 - line.y;
    final angle = atan2(dy, dx);
    final newAngle = angle + pi / 2;
    final newDx = cos(newAngle) * sqrt(dx * dx + dy * dy);
    final newDy = sin(newAngle) * sqrt(dx * dx + dy * dy);
    line.x1 = line.x + newDx;
    line.y1 = line.y + newDy;
  }

  void rotateArc(ArcEntity arc) {
    // final dx = arc.x - arc.x1;
    // final dy = arc.y - arc.y1;

    // final angle = atan2(arc.y, arc.x);
    // final newAngle = angle + pi / 2;
    // final newDx = cos(newAngle) * sqrt(arc.x * arc.x + arc.y * arc.y);
    // final newDy = sin(newAngle) * sqrt(arc.x * arc.x + arc.y * arc.y);
    // arc.x1 = arc.x - newDx;
    // arc.y1 = arc.y - newDy;
  }

  void ferramentaToDxf(Ferramenta ferramenta) async {
    final pos = ferramenta.position;
    for (var entity in ferramenta.entities) {
      if (entity is CircleEntity) {
        dxf.addEntities(AcDbCircle(
          x: entity.x + pos.dx,
          y: entity.y + pos.dy,
          radius: entity.radius,
          layerName: entity.layerName,
        ));
      }

      if (entity is LineEntity) {
        dxf.addEntities(AcDbLine(
          x: entity.x + pos.dx,
          y: entity.y + pos.dy,
          x1: entity.x1 + pos.dx,
          y1: entity.y1 + pos.dy,
          layerName: entity.layerName,
        ));
      }
      if (entity is ArcEntity) {
        dxf.addEntities(AcDbArc(
          x: entity.x + pos.dx,
          y: entity.y + pos.dy,
          radius: entity.radius,
          startAngle: entity.startAngle,
          endAngle: entity.endAngle,
          layerName: entity.layerName,
        ));
      }
    }
  }

  Widget mapFromFerramenta(Ferramenta fer) {
    return ValueListenableBuilder<Offset>(
      valueListenable: fer.pos,
      builder: (BuildContext context, Offset value, Widget? child) {
        return Positioned(
          left: fer.position.dx + fer.menorX!,
          bottom: fer.position.dy + fer.menorY!,
          child: Transform.rotate(
            angle: radians(0),
            child: FerramentaWidget(
              ferramenta: fer,
              otherFerramentas: ferramentas.where((e) => fer != e).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dio = Dio(BaseOptions(baseUrl: Constants.API_URL));
      final result = await dio.get('/files');
      setState(() {
        for (var element in result.data) {
          final dxf = DXF.fromString(element);

          ferramentas.add(
            Ferramenta.fromDxf(
              cor: Colors.red,
              acDbEntities: dxf.entities,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: gerar,
                child: const Text('Gerar'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: visualizar,
                child: const Text('Visualizar'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: sendToApi,
                child: const Text('Enviar pra API'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: visualizarDaApi,
                child: const Text('Visualizar da API'),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        Expanded(
          child: InteractiveViewer(
            constrained: false,
            boundaryMargin: const EdgeInsets.all(100),
            maxScale: 5,
            minScale: 0.5,
            child: Container(
              width: 800,
              height: 800,
              color: color,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return CustomPaint(
                    painter: BackgroundPainter(
                      min: 0,
                      max: 800,
                      tam: tam,
                    ),
                    child: GestureDetector(
                      onPanDown: (details) {},
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: ferramentas.map(mapFromFerramenta).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
