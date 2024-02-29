// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:ui_textfield_cache_flutter/ui_textfield_cache_flutter.dart';

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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UITextFieldCache(
            callback: (String? text) {
              debugPrint('callback: $text');
            },
          ),
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
