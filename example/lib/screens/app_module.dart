import 'package:flutter_modular/flutter_modular.dart';
import 'package:ui_textfield_cache_flutter/ui_textfield_cache_flutter.dart';

import '../main.dart';
import 'home_scaffold.dart';

class AppModule extends Module {
  // Provide a list of dependencies to inject into your project

  @override
  void binds(i) async {
    i.addInstance<UITextFieldCubit>(UITextFieldCubit(store: uiTextFieldStore));
  }

  @override
  void routes(r) {
    r.child('/', child: (_) => const HomeScaffold());
  }
}
