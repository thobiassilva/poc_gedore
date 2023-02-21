import 'package:flutter/material.dart';

import '../background.painter.dart';

class Teste2 extends StatefulWidget {
  const Teste2({super.key});

  @override
  State<Teste2> createState() => _Teste2State();
}

class _Teste2State extends State<Teste2> {
  double xAjust = 0;
  double yAjust = 0;

  // ValueNotifier<Offset> center = ValueNotifier<Offset>(Offset.zero);
  final store = MyStore();
  final double tam = 25;

  bool isFirstInit = true;

  Color color = Colors.white;

  @override
  void initState() {
    super.initState();
    // center.addListener(() {
    //   print(center.value);
    // });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // store.setCenter(details.localPosition - const Offset(25 / 2, 25 / 2));
    store.updateCenter(details.delta);
  }

  void _onPanDown(DragDownDetails details) {
    store.setCenter(details.localPosition - const Offset(25 / 2, 25 / 2));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      // onPanDown: _onPanDown,
      // onHorizontalDragUpdate: (details) => store.updateCenter(details.delta),
      // onVerticalDragUpdate: (details) => store.updateCenter(details.delta),

      child: Container(
        color: color,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (isFirstInit) {
              store.setCenter(
                  Offset(constraints.maxWidth / 2, constraints.maxHeight / 2));
              isFirstInit = false;
            }
            return ValueListenableBuilder(
                valueListenable: store,
                builder: (context, _, child) {
                  return CustomPaint(
                    // willChange: true,
                    // isComplex: true,
                    painter: BackgroundPainter(
                      min: -500,
                      max: 500,
                    ),
                    size: size,
                    child: Center(
                      child: Container(
                        child: Text(
                          store.value.toString(),
                          style: const TextStyle(color: Colors.transparent),
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}

class MyStore extends ValueNotifier<Offset> {
  MyStore() : super(Offset.zero);

  void setCenter(Offset offset) => value = offset;
  void updateCenter(Offset offset) => value += offset;
}
