import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpos/initialization/logic/initialization.dart';
import 'package:riverpos/initialization/widgets/app.dart';

void main() => runZonedGuarded(() async {
  try {
    final dependencies = await initialize();
    runApp(App(dependencies: dependencies));
  } on InitializationStepException catch (error, stackTrace) {
    // run ErrorApp
  }
}, (error, stackTrace) {});
