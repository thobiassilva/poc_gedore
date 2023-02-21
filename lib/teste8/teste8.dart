import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:poc_gedore/teste7/visualizacao.dart';

import '../background.painter.dart';
import 'ferramenta.dart';
import 'ferramenta.widget.dart';

class Teste8 extends StatefulWidget {
  const Teste8({
    Key? key,
  }) : super(key: key);

  @override
  State<Teste8> createState() => _Teste7State();
}

class _Teste7State extends State<Teste8> {
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
      'https://b5db-2804-108c-f88b-9101-4089-a03b-8364-58b3.ngrok.io/save',
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
    final dio = Dio();
    final result = await dio.get(
        'https://b5db-2804-108c-f88b-9101-4089-a03b-8364-58b3.ngrok.io/file');

    // ignore: use_build_context_synchronously
    showBottomSheet(
      enableDrag: false,
      context: context,
      builder: (context) {
        return Visualizacao(dxfString: result.data);
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
    final size = MediaQuery.of(context).size.shortestSide;

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
