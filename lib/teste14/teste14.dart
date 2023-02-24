import 'package:dio/dio.dart';
import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:poc_gedore/main.dart';

import '../background.painter.dart';
import 'ferramenta.dart';
import 'ferramenta.widget.dart';
import 'mygame.dart';
import 'visualizacao.dart';

class Teste14 extends StatefulWidget {
  const Teste14({
    Key? key,
  }) : super(key: key);

  @override
  State<Teste14> createState() => _Teste14State();
}

class _Teste14State extends State<Teste14> {
  late final MyGame _game;
  DXF dxf = DXF.create();

  final myStore = MyStore();

  final double tam = 25;
  final double tamanhoPlano = 800;

  Color color = Colors.white;

  // final List<Ferramenta> ferramentas = [];

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
    for (var ferramenta in myStore.ferramentas) {
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

  void ferramentaToDxf(Ferramenta ferramenta) async {
    final pos = ferramenta.position;
    for (var entity in ferramenta.entities) {
      if (entity is AcDbCircle) {
        dxf.addEntities(AcDbCircle(
          x: entity.x + pos.dx,
          y: entity.y + pos.dy,
          radius: entity.radius,
          layerName: entity.layerName,
        ));
      }

      if (entity is AcDbLine) {
        dxf.addEntities(AcDbLine(
          x: entity.x + pos.dx,
          y: entity.y + pos.dy,
          x1: entity.x1 + pos.dx,
          y1: entity.y1 + pos.dy,
          layerName: entity.layerName,
        ));
      }
      if (entity is AcDbArc) {
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
          child: FerramentaWidget(
            ferramenta: fer,
            myStore: myStore,
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

          myStore.ferramentas.add(
            Ferramenta(
              cor: Colors.red,
              entities: dxf.entities,
            ),
          );
        }
      });
    });

    // _game = MyGame();
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
            // panEnabled: false,
            boundaryMargin: const EdgeInsets.all(100),
            maxScale: 5,
            minScale: 0.5,
            child: Container(
              width: tamanhoPlano,
              height: tamanhoPlano,
              color: color,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return CustomPaint(
                    painter: BackgroundPainter(
                      min: 0,
                      max: tamanhoPlano,
                      tam: tam,
                    ),
                    // foregroundPainter: HitBoxPainter(myStore: myStore),
                    child: GestureDetector(
                      onPanDown: (details) {},
                      child: Stack(
                        clipBehavior: Clip.none,
                        children:
                            myStore.ferramentas.map(mapFromFerramenta).toList(),
                      ),
                    ),
                    // child: GameWidget(
                    //   game: _game,
                    // ),
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

class MyStore {
  static final MyStore _instance = MyStore._internal();

  factory MyStore() {
    return _instance;
  }

  MyStore._internal();

  List<Ferramenta> ferramentas = [];

  void addFerramenta(Ferramenta ferramenta) {
    ferramentas.add(ferramenta);
  }

  // void verifyHasCollision(Ferramenta ferramenta) {
  //   for (var otherFerramenta in ferramentas) {
  //     if (otherFerramenta == ferramenta) continue;

  //     for (var hitbox in ferramenta.hitboxes) {
  //       for (var otherHitbox in otherFerramenta.hitboxes) {
  //         final tempAjut = Offset(ferramenta.menorX!, ferramenta.menorY!) -
  //             Offset(otherFerramenta.menorX!, -otherFerramenta.menorY!);
  //         final ajust = Offset(tempAjut.dx, tempAjut.dy);

  //         // final ajust = Offset(-ferramenta.ajust.dx, 800 - ferramenta.ajust.dy);

  //         final rect1 = hitbox
  //             .shift(Offset(ferramenta.position.dx, ferramenta.position.dy));
  //         final rect2 = otherHitbox.shift(otherFerramenta.position);

  //         if (rect1.overlaps(rect2)) {
  //           ferramenta.hasCollision = true;
  //           otherFerramenta.hasCollision = true;
  //           return;
  //         }
  //       }
  //     }

  //     ferramenta.hasCollision = false;
  //     otherFerramenta.hasCollision = false;
  //   }
  // }
}

class HitBoxPainter extends CustomPainter {
  final MyStore myStore;
  HitBoxPainter({
    required this.myStore,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const tamanhoPlano = 800;
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var ferramenta in myStore.ferramentas) {
      // print(ferramenta.ajust);
      // print(ferramenta.size);
      // print(ferramenta.menorY);
      // print(ferramenta.menorX);

      for (var hitbox in ferramenta.hitboxes) {
        canvas.drawRect(
            hitbox.shift(
              Offset(ferramenta.position.dx, -ferramenta.position.dy) +
                  Offset(
                      -ferramenta.ajust.dx, tamanhoPlano - ferramenta.ajust.dy),

              // Offset(ferramenta.position.dx, ferramenta.position.dy) + ajust,
            ),
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
