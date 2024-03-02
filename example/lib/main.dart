import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nosql_dart/nosql_dart.dart';
import 'package:ui_textfield_cache_flutter/ui_textfield_cache_flutter.dart';
import 'package:ui_theme_mode_flutter/ui_theme_mode_flutter.dart';

import 'screens/app_module.dart';

/// NoSQL database to store the list strings(aka cache)
late final BHiveCacheStore uiTextFieldStore;

/// Part of NoSQL database store.
late final OnDeviceStore onDeviceStore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  onDeviceStore = await BHiveDeviceStore.onDeviceSetUp();
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

/// The main widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Build the widget tree for MyApp.
  @override
  Widget build(BuildContext context) {
    // Get the UIThemeModeCubit from the dependency injection container.
    UIThemeModeCubit cubit = Modular.get<UIThemeModeCubit>();

    // Use a BlocBuilder to rebuild the MaterialApp when the UIThemeModeState changes.
    return BlocBuilder<UIThemeModeCubit, UIThemeModeState>(
      bloc: cubit,
      builder: (context, state) {
        // set brightness by the cubit for access anywhere in the widget tree
        cubit.setBrightness(context);
        // Return a MaterialApp with a router.
        return MaterialApp.router(
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: cubit.state.themeMode,
          localizationsDelegates: const [],
          // Use a BlocProvider to provide the UIThemeModeCubit to the widget tree.
          builder: (context, routerBuilder) => BlocProvider.value(
            value: cubit,
            child: routerBuilder!,
          ),
        );
      },
    );
  }
}
