import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ui_textfield_cache_flutter/ui_textfield_cache_flutter.dart';

import 'screens/app_module.dart';

/// NoSQL database to store the list strings(aka cache)
late final BHiveCacheStore uiTextFieldStore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  uiTextFieldStore = await BHiveCacheStore.onDeviceSetup(
    hiveDir: 'hive',
    hiveBox: 'ui_textfield_cache',
  );

  runApp(
    ModularApp(
      module: AppModule(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      title: 'Flutter Demo',

      ///locale: Language.locale,
      theme: null,
      darkTheme: null,
      themeMode: null,
      localizationsDelegates: const [],
    );
  }
}
