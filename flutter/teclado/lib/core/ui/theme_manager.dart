import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:teclado/core/local_storage/local_storage.dart';
import 'package:teclado/core/ui/ui_config.dart';

class ThemeManager {
  final Signal<ThemeData> themeData;
  final Signal<bool> _isDarkMode;
  final LocalStorage _localStorage;

  bool get isDarkMode => _isDarkMode.value;

  ThemeManager({
    required bool initialDarkMode,
    required LocalStorage localStorage,
  })  : themeData =
            Signal(initialDarkMode ? UiConfig.darkTheme : UiConfig.lightTheme),
        _isDarkMode = Signal(initialDarkMode),
        _localStorage = localStorage;

  void toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    themeData.value =
        _isDarkMode.value ? UiConfig.darkTheme : UiConfig.lightTheme;

    _localStorage.writeBool('isDarkMode', _isDarkMode.value);
  }

  Future<void> getDarkMode() async {
    final isDark = await _localStorage.readBool('isDarkMode') ?? true;
    _isDarkMode.value = isDark;
  }
}
