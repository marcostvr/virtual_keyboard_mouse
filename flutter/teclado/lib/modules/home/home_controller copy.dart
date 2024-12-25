import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomeController {
  int _pointerCount = 0;
  bool _shouldRightClick = true;
  Offset _previousScale = Offset(0, 0);

  Future<void> sendClick() async {
    try {
      final String url = 'http://192.168.0.8:8080/?click=click';
      // ignore: unused_local_variable
      final response = await http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar clique');
    }
  }

  // Future<void> sendMovement(String movement, String data) async {
  //   try {
  //     final String url =
  //         'http://192.168.0.8:8080/?${movement}=${Uri.encodeComponent(data)}';
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       log('Success: ${response.body}');
  //     } else {
  //       log('Error: ${response.statusCode}');
  //     }
  //   } on Exception catch (e) {
  //     log('erro ao enviar movimento: $e');
  //   }
  // }

  // Future<void> onDoubleTap() async {
  //   try {
  //     final String url = 'http://192.168.0.8:8080/?double_click=double_click';
  //     // ignore: unused_local_variable
  //     final response = await http.get(Uri.parse(url));
  //   } catch (e) {
  //     log('Erro ao enviar duplo clique');
  //   }
  // }

  void onScaleStart(ScaleStartDetails details) {
    // define should right click para false quando um gesto de pinça é iniciado
    // para que não dê right click quando levantar os dedos
    _shouldRightClick = false;

    _previousScale = details.localFocalPoint;
    // TODO enviar o movimento de pinça com o _sendMovement
  }

  void onScaleEnd(ScaleEndDetails details) {
    // define should right click para true quando o gesto de pinça termina
    // para que seja possível o right click com tap de 2 dedos
    _shouldRightClick = true;
  }

  // void onTap() {
  //   sendClick();
  // }

  onPointerDown(PointerDownEvent pdEvent) {
    _pointerCount++;
  }

  onPointerUp(PointerUpEvent puEvent) async {
    _pointerCount--;
    if (_pointerCount == 1 && _shouldRightClick) {
      try {
        final String url = 'http://192.168.0.8:8080/?right_click=right_click';
        // ignore: unused_local_variable
        final response = await http.get(Uri.parse(url));
      } catch (e) {
        log('Erro ao enviar right click');
      }
    }
  }

  Future<void> onScaleUpdate(ScaleUpdateDetails details) async {
    // Ao atualizar a escala, envie as coordenadas do foco do gesto
    if (_pointerCount == 2) {
      final focalPoint = details.focalPoint;

      if (_previousScale == focalPoint) return;

      if (_previousScale.dy > focalPoint.dy) {
        try {
          final String url = 'http://192.168.0.8:8080/?scroll_up=x';
          // ignore: unused_local_variable
          final response = await http.get(Uri.parse(url));
        } catch (e) {
          log('Erro ao enviar scroll up');
        }
        log('pra cima');
      } else {
        try {
          final String url = 'http://192.168.0.8:8080/?scroll_down=x';
          // ignore: unused_local_variable
          final response = await http.get(Uri.parse(url));
        } catch (e) {
          log('Erro ao enviar scroll up');
        }
        log('pra baixo');
      }
      _previousScale = focalPoint;
    } else {
      // calcular a diferença de coordenadas e enviar movimento do mouse
      final dx = details.localFocalPoint.dx;
      final dy = details.localFocalPoint.dy;
      final previousDx = _previousScale.dx;
      final previousDy = _previousScale.dy;
      final coordenadas = Offset(dx - previousDx, dy - previousDy);
      // sendMovement('coordenadas', '${coordenadas.dx},${coordenadas.dy}');
      log('coordenadas:${coordenadas.dx},${coordenadas.dy}');
    }
  }

  Future<void> sendKey(String key) async {
    final String url =
        'http://192.168.0.8:3555/?text=${Uri.encodeComponent(key)}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
}
