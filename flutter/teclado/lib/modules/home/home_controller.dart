import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomeController {
  final String baseUrl = 'http://192.168.0.8:3555/?';
  late Offset _startDrag; // Para armazenar a posição inicial do arraste
  bool _isDragging = false; // Para controlar se estamos arrastando
  bool _doubleTap = false;
  bool _isMoving = false;

  int _pointerCount = 0;
  bool _shouldRightClick = true;
  Offset _previousScale = Offset(0, 0);

  // Método para lidar com o double tap
  Future<void> onDoubleTap() async {
    log('passou pelo onDoubleTap');
    _isMoving = false;
    _doubleTap = true;
    // Inicia o drag
    _isDragging = true;
    // Enviar o clique para iniciar o drag
    try {
      final String url = '${baseUrl}start_drag=x';
      // ignore: unused_local_variable
      final response = await http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar clique');
    }
  }

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

  sendArrowDown() {
    try {
      final String url = 'http://198.162.0.8:3550/?arrow_down=x';
      http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar seta para baixo');
    }
  }

  void onScaleStart(ScaleStartDetails details) {
    log('passou pelo onScaleStart');
    // define should right click para false quando um gesto de pinça é iniciado
    // para que não dê right click quando levantar os dedos
    _shouldRightClick = false;

    _previousScale = details.localFocalPoint;
    _isMoving = true;

    // TODO enviar o movimento de pinça com o _sendMovement
  }

  void onScaleEnd(ScaleEndDetails details) {
    // define should right click para true quando o gesto de pinça termina
    // para que seja possível o right click com tap de 2 dedos
    _shouldRightClick = true;
    _isMoving = false;
    ('Passou pelo onScaleEnd');
  }

  void onTap() {
    log('passou pelo onTap');
    _isMoving = false;
    // if(_pointerCount == 1) {
    //   try {
    //     final String url = '${baseUrl}'
    //   } catch (e) {

    //   }
    // }
  }

  onPointerDown(PointerDownEvent pdEvent) {
    _pointerCount++;
  }

  onPointerUp(PointerUpEvent puEvent) async {
    log('passou pelo pointerUp: $_pointerCount');
    try {
      _pointerCount--;
      if (_pointerCount == 1) {
        if (_shouldRightClick) {
          log('passou pelo right click');
          try {
            final String url = '${baseUrl}right_click=right_click';
            // ignore: unused_local_variable
            http.get(Uri.parse(url));
          } catch (e) {
            log('Erro ao enviar right click');
          }
        }
      } else if (_pointerCount == 0) {
        log('isDragging: $_isDragging');
        log('isMoving: $_isMoving');
        if (_isDragging) {
          _isDragging = false;
          try {
            final String url = '${baseUrl}end_drag=x';
            http.get(Uri.parse(url));
          } catch (e) {
            log('Erro ao enviar drag');
          }
        } else if (!_isMoving) {
          try {
            log('passou pelo click');
            final String url = 'http://192.168.0.8:3555/?click=click';
            http
                .get(Uri.parse(url))
                .then((response) => log('response ${response.body}'));
          } catch (e) {
            log('Erro ao enviar click');
          }
        }
      }
    } catch (e) {
      log('Erro ao decrementar pointerCount: $e');
    }
    log('final do pointerUp: $_pointerCount');
  }

  Future<void> onScaleUpdate(ScaleUpdateDetails details) async {
    // Ao atualizar a escala, envie as coordenadas do foco do gesto
    if (_pointerCount == 2) {
      final focalPoint = details.focalPoint;

      if (_previousScale == focalPoint) return;

      if (_previousScale.dy > focalPoint.dy) {
        try {
          final String url = '${baseUrl}scroll_up=x';
          // ignore: unused_local_variable
          final response = await http.get(Uri.parse(url));
        } catch (e) {
          log('Erro ao enviar scroll up');
        }
        log('pra cima');
      } else {
        try {
          final String url = '${baseUrl}scroll_down=x';
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
      final String dxFinal = (dx - previousDx).toString().split(',')[0];
      final String dyFinal = (dy - previousDy).toString().split(',')[0];

      try {
        final url =
            '${baseUrl}coordenadas=${Uri.encodeComponent(dxFinal)},${Uri.encodeComponent(dyFinal)}';
        http.get(Uri.parse(url));
      } catch (e) {
        // log('Erro ao enviar coordenadas');
      }
      // log('coordenadas:${dxFinal},${dyFinal}');
    }
  }

  Future<void> sendText(String key) async {
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

  void sendKey(String s) {}

  void sendBackspace() {
    try {
      final String url = 'http://192.168.0.8:3555/?backspace=backspace';
      http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar backspace');
    }
  }

  void sendEnter() {
    try {
      final String url = 'http://192.168.0.8:3555/?enter=x';
      http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar enter');
    }
  }

  void sendArrowUp() {
    try {
      final String url = 'http://192.168.0.8:3555/?arrow_up=x';
      http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar seta para cima');
    }
  }

  void sendArrowLeft() {
    try {
      final String url = 'http://192.168.0.8:3555/?arrow_left=x';
      http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar seta para esquerda');
    }
  }

  void sendArrowRight() {
    try {
      final String url = 'http://192.168.0.8:3555/?arrow_right=x';
      http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar seta para direita');
    }
  }

  void sendCtrlW() {
    try {
      final String url = 'http://192.168.0.8:3555/?ctrl_w=x';
      http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar ctrl+w');
    }
  }

  void sendAltEnter() {
    try {
      final String url = 'http://192.168.0.8:3555/?alt_enter=x';
      http.get(Uri.parse(url));
    } catch (e) {
      log('Erro ao enviar alt+enter');
    }
  }
}
