// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ui_textfield_cache_flutter/ui_textfield_cache_flutter.dart';
import 'package:ui_theme_mode_flutter/ui_theme_mode_flutter.dart';

import '../gen/assets.gen.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeWidget(context),
      floatingActionButton: null,
    );
  }

  Widget homeWidget(BuildContext context) {
    final cubit = context.read<UIThemeModeCubit>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final result =
                  await Navigator.of(context).push(UIPageRouteBuilder());
              debugPrint('Result: $result');
            },
            child: const Text('Show New Overlay'),
          ),
          ElevatedButton(
              onPressed: () {
                cubit.setToDarkMode();
              },
              child: const Text('Dark')),
          ElevatedButton(
              onPressed: () {
                cubit.setToLightMode();
              },
              child: const Text('Light')),
          ElevatedButton(
              onPressed: () {
                cubit.setToSystemMode();
              },
              child: const Text('System')),
          SizedBox(
            width: 50,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.images.ltmm1024x1024.image(),
            ),
          ),
        ],
      ),
    );
  }
}
