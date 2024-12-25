import 'package:flutter_getit/flutter_getit.dart';
import 'package:teclado/modules/home/home_controller.dart';
import 'package:teclado/modules/home/home_page.dart';

class HomeModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => "/home";

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<HomeController>(
          (i) => HomeController(),
        ),
      ];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: "/",
          builder: (context) => const HomePage(),
        ),
      ];
}
