import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

/// {@template main}
/// App widget.
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro main}
  const App({
    super.key, // ignore: unused_element_parameter
  });

  @override
  State<App> createState() => _AppState();
}

/// State for widget App.
class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => const Placeholder();
}
