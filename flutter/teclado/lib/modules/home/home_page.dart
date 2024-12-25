import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:teclado/modules/home/custom_listener.dart';
import 'package:teclado/modules/home/custom_keyboard_listener.dart';
import 'package:teclado/modules/home/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showKeyboard = true;
  final HomeController homeController = Injector.get<HomeController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            // boto tooggle mouse/keyboard
            SizedBox(
              height: 75,
              width: 75,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    showKeyboard = !showKeyboard;
                  });
                },
                icon: showKeyboard ? Icon(Icons.mouse) : Icon(Icons.keyboard),
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 75,
                      child: ElevatedButton(
                        onPressed: () {
                          homeController.sendArrowUp();
                        },
                        child: Icon(Icons.arrow_upward),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 75,
                      child: ElevatedButton(
                        onPressed: () {
                          homeController.sendArrowLeft();
                        },
                        child: Icon(Icons.arrow_left),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 75,
                      child: ElevatedButton(
                        onPressed: () {
                          homeController.sendArrowRight();
                        },
                        child: Icon(Icons.arrow_right),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 75,
                      child: ElevatedButton(
                        onPressed: () {
                          homeController.sendArrowDown();
                        },
                        child: Icon(Icons.arrow_downward),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Stack(
                children: [
                  Visibility(
                    visible: showKeyboard,
                    child: CustomKeyboardListener(),
                  ),
                  Visibility(
                    visible: !showKeyboard,
                    child: CustomListener(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
