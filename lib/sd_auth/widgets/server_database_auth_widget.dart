import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/sd_auth/providers/server_database_provider.dart';

/// {@template server_database_auth_widget}
/// ServerDatabaseAuthWidget widget.
/// {@endtemplate}
class ServerDatabaseAuthWidget extends ConsumerStatefulWidget {
  /// {@macro server_database_auth_widget}
  const ServerDatabaseAuthWidget({
    super.key, // ignore: unused_element_parameter
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServerDatabaseAuthWidgetState();
}

/// State for widget ServerDatabaseAuthWidget.
class _ServerDatabaseAuthWidgetState
    extends ConsumerState<ServerDatabaseAuthWidget> {
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serverDatabaseProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) {
    final serverDatabaseState = ref.watch(serverDatabaseProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Server database auth')),
      body: CustomScrollView(
        slivers: [
          if (serverDatabaseState.inInProgress)
            SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
