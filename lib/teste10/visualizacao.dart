import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';

import '../background.painter.dart';
import 'ferramenta.dart';
import 'ferramenta.widget.dart';

class Visualizacao extends StatefulWidget {
  final String dxfString;
  const Visualizacao({
    Key? key,
    required this.dxfString,
  }) : super(key: key);

  @override
  State<Visualizacao> createState() => _VisualizacaoState();
}

class _VisualizacaoState extends State<Visualizacao> {
  List<Ferramenta> ferramentas = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final dxf = DXF.fromString(widget.dxfString);
        // ferramentas = dxf.entities.map(mapFromEntitie).toList();
        ferramentas.add(
          Ferramenta(
            // pos: const Offset(114, 190),
            // size: const Size(50, 50),
            cor: Colors.red,
            entities: dxf.entities,
          ),
        );
      });
    });
  }

  // Widget mapFromFerramenta(Ferramenta fer) {
  //   return Positioned(
  //     left: fer.position.dx - (fer.size.width),
  //     bottom: fer.position.dy - (fer.size.height),
  //     child: CustomPaint(
  //       painter: EntityPainter(
  //         color: fer.cor,
  //         entities: fer.entites,
  //       ),
  //       child: const Center(),
  //     ),
  //   );
  // }
  Widget mapFromFerramenta(Ferramenta fer) {
    return Positioned(
      left: fer.position.dx - (fer.size.width),
      bottom: fer.position.dy - (fer.size.height),
      child: FerramentaWidget(
        ferramenta: fer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(20),
      maxScale: 5,
      minScale: 0.5,
      child: Container(
        width: 800,
        height: 800,
        color: Colors.grey.shade300,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return CustomPaint(
              painter: BackgroundPainter(
                min: 0,
                max: 800,
                tam: 25,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: ferramentas.map(mapFromFerramenta).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
