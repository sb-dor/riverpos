import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/auth/providers/auth_provider.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/products/providers/products_provider.dart';
import 'package:riverpos/sd_auth/providers/server_database_provider.dart';
import 'package:riverpos/sd_auth/widgets/server_database_auth_widget.dart';

/// {@template app}
/// App widget.
/// {@endtemplate}
class App extends StatefulWidget {
  /// {@macro app}
  const App({
    super.key, // ignore: unused_element_parameter
    required this.dependencies,
  });

  final DependenciesContainer dependencies;

  @override
  State<App> createState() => _AppState();
}

/// State for widget App.
class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [
      dependenciesProvider.overrideWithValue(widget.dependencies),
      serverDatabaseProvider,
      authProvider,
      productsProvider,
    ],
    child: MaterialApp(home: ServerDatabaseAuthWidget()),
  );
}
