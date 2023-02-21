import 'package:dio/dio.dart';
import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';

class DXFStore {
  Offset? _pos;
  Size? _size;

  Offset? get pos => _pos;
  Size? get size => _size;

  void setState({Offset? pos, Size? size}) {
    _pos = pos ?? _pos;
    _size = size ?? _size;
  }

  Future<void> callApi(String text) {
    final dio = Dio();
    return dio.post(
        'https://b5db-2804-108c-f88b-9101-4089-a03b-8364-58b3.ngrok.io/save',
        data: {'texto': text});
  }

  void generateDxf({
    double radius = 0,
  }) async {
    final dxf = DXF.create();

    final pos = _pos! + Offset(_size!.width / 2, _size!.height / 2);
    // print('CirclePos: $pos');
    // print('pos: $_pos');
    // print('size: $_size');

    var circle = AcDbCircle(
      x: pos.dx,
      y: pos.dy,
      z: 0,
      radius: radius,
    );
    dxf.addEntities(circle);

    var line = AcDbLine(
      x: _pos!.dx,
      y: _pos!.dy,
      x1: _pos!.dx,
      y1: _pos!.dy + _size!.height,
    );
    dxf.addEntities(line);

    var line2 = AcDbLine(
      x: _pos!.dx,
      y: _pos!.dy + _size!.height,
      x1: _pos!.dx + _size!.width,
      y1: _pos!.dy + _size!.height,
    );
    dxf.addEntities(line2);

    var line3 = AcDbLine(
      x: _pos!.dx + _size!.width,
      y: _pos!.dy + _size!.height,
      x1: _pos!.dx + _size!.width,
      y1: _pos!.dy,
    );
    dxf.addEntities(line3);

    var line4 = AcDbLine(
      x: _pos!.dx + _size!.width,
      y: _pos!.dy,
      x1: _pos!.dx,
      y1: _pos!.dy,
    );
    dxf.addEntities(line4);

    await callApi(dxf.dxfString);
  }

  void circleDxf({
    double radius = 0,
  }) async {
    final dxf = DXF.create();

    final pos = _pos! + Offset(_size!.width / 2, _size!.height / 2);

    var circle = AcDbCircle(
      x: pos.dx,
      y: pos.dy,
      z: 0,
      radius: radius,
    );
    dxf.addEntities(circle);

    await callApi(dxf.dxfString);
  }

  void lineDxf() async {
    final dxf = DXF.create();

    var line = AcDbLine(
      x: _pos!.dx,
      y: _pos!.dy,
      x1: _pos!.dx,
      y1: _size!.height,
    );
    dxf.addEntities(line);

    await callApi(dxf.dxfString);
  }

  void squareDxf() async {
    final dxf = DXF.create();

    var line = AcDbLine(
      x: _pos!.dx,
      y: _pos!.dy,
      x1: _pos!.dx,
      y1: _size!.height,
    );
    dxf.addEntities(line);

    var line2 = AcDbLine(
      x: _pos!.dx,
      y: _size!.height,
      x1: _size!.width,
      y1: _size!.height,
    );
    dxf.addEntities(line2);

    var line3 = AcDbLine(
      x: _size!.width,
      y: _size!.height,
      x1: _size!.width,
      y1: _pos!.dy,
    );

    dxf.addEntities(line3);
    var line4 = AcDbLine(
      x: _size!.width,
      y: _pos!.dy,
      x1: _pos!.dx,
      y1: _pos!.dy,
    );
    dxf.addEntities(line4);

    await callApi(dxf.dxfString);
  }
}
