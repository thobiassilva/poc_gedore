import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:poc_gedore/dxf.store.dart';
import 'package:poc_gedore/teste7/visualizacao.dart';

import '../background.painter.dart';
import 'ferramenta.dart';
import 'ferramenta.widget.dart';

class Teste7 extends StatefulWidget {
  final DXFStore store;

  const Teste7({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  State<Teste7> createState() => _Teste7State();
}

class _Teste7State extends State<Teste7> {
  double xAjust = 0;
  double yAjust = 0;
  DXF dxf = DXF.create();

  final double tam = 25;

  Color color = Colors.white;

  final List<Ferramenta> ferramentas = [
    Ferramenta.circle(
      radius: 25,
      cor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    ),
    Ferramenta.circle(
      radius: 25,
      cor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    ),
    Ferramenta.circle(
      radius: 25,
      cor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    ),
  ];

  void sendToApi() {
    final dio = Dio();
    dio.post(
      'https://8d9e-2804-108c-f88b-9101-a99a-5c8-76dd-30b3.ngrok.io/save',
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

  void ferramentaToDxf(Ferramenta ferramenta) async {
    final pos = ferramenta.position;
    // +
    //     Offset(ferramenta.size.width / 2, ferramenta.size.height / 2);
    var circle = AcDbCircle(
      x: pos.dx,
      y: pos.dy,
      z: 0,
      radius: ferramenta.size.height,
    );

    dxf.addEntities(circle);
  }

  Widget mapFromFerramenta(Ferramenta fer) {
    return ValueListenableBuilder<Offset>(
      valueListenable: fer.pos,
      builder: (BuildContext context, Offset value, Widget? child) {
        return Positioned(
          left: value.dx - (fer.size.width),
          bottom: value.dy - (fer.size.height),
          child: FerramentaWidget(
            ferramenta: fer,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: gerar,
              child: const Text('Gerar'),
            ),
            ElevatedButton(
              onPressed: visualizar,
              child: const Text('Visualizar'),
            ),
            ElevatedButton(
              onPressed: sendToApi,
              child: const Text('Enviar pra API'),
            ),
          ],
        ),
        Expanded(
          child: InteractiveViewer(
            // clipBehavior: Clip.none,
            // panEnabled: false,
            // alignment: Alignment.bottomLeft,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(20),
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
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: ferramentas.map(mapFromFerramenta).toList(),
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
