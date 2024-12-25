import 'package:flutter_getit/flutter_getit.dart';
import 'package:teclado/core/local_storage/local_storage.dart';
import 'package:teclado/core/local_storage/local_storage_impl.dart';
import 'package:teclado/core/ui/theme_manager.dart';

class TecladoApplicationBindings extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton<ThemeManager>(
          (i) => ThemeManager(
            initialDarkMode: true,
            localStorage: i(),
          ),
        ),
        Bind.lazySingleton<LocalStorage>(
          (i) => SharedPreferenceImpl(),
        ),
      ];
}
