import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:teclado/modules/home/home_controller.dart';

class CustomKeyboardListener extends StatefulWidget {
  const CustomKeyboardListener({super.key});

  @override
  State<CustomKeyboardListener> createState() => _CustomKeyboardListenerState();
}

class _CustomKeyboardListenerState extends State<CustomKeyboardListener> {
  final FocusNode _focusNode = FocusNode();
  final HomeController homeController = Injector.get<HomeController>();
  final TextEditingController _controller = TextEditingController();
  String textSended = '';

  @override
  void initState() {
    super.initState();

    // definir a orientação do teclado como paisagem
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    // Dispose do FocusNode para evitar vazamentos de memória
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (value) {
          log('tecla pressionada: $value');
        },
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    // onChanged: (value) {
                    //   homeController.sendKey(value);
                    // },
                  ),
                ),
                // botão pra recuperar o texto que foi enviado anteriormente
                IconButton(
                  onPressed: () {
                    _controller.text = textSended;
                  },
                  icon: Icon(Icons.restore_rounded),
                ),
                IconButton(
                  onPressed: () {
                    homeController.sendText(_controller.text);
                    textSended = _controller.text;
                    _controller.clear();
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     SystemChannels.textInput.invokeMethod('TextInput.hide');
            //   },
            //   child: Text('Hide'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     SystemChannels.textInput.invokeMethod('TextInput.show');
            //   },
            //   child: Text('Show'),
            // ),
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: () {
                      homeController.sendBackspace();
                    },
                    icon: Icon(Icons.backspace),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: () {
                      homeController.sendEnter();
                    },
                    icon: Icon(Icons.keyboard_return),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: IconButton(
                    onPressed: () {
                      homeController.sendCtrlW();
                    },
                    icon: Text('CTRL + W'),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 120,
                  child: IconButton(
                    onPressed: () {
                      homeController.sendAltEnter();
                    },
                    icon: Text('ALT + ENTER'),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
