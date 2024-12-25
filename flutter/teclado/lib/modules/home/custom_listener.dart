import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:teclado/modules/home/home_controller.dart';

class CustomListener extends StatefulWidget {
  const CustomListener({super.key});

  @override
  State<CustomListener> createState() => _CustomListenerState();
}

class _CustomListenerState extends State<CustomListener> {
  final HomeController homeController = Injector.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: homeController.onPointerDown,
      onPointerUp: homeController.onPointerUp,
      child: GestureDetector(
        onTap: homeController.onTap,
        onDoubleTap: homeController.onDoubleTap,
        onScaleStart: homeController.onScaleStart,
        onScaleEnd: homeController.onScaleEnd,
        onScaleUpdate: homeController.onScaleUpdate,
        child: Container(
          color: Colors.grey[200],
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Text(
              'Use o touchpad',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
