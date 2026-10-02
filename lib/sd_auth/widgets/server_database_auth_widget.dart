import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/auth/widgets/auth_widget.dart';
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
  final serverCode = TextEditingController();
  late final controllers = [serverCode];

  // --- form-level state
  final _validation = ValueNotifier<bool>(false);
  final _error = ValueNotifier<String?>(null);

  // --- The merged Listeners ---
  late final Listenable formController;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();

    formController = Listenable.merge(controllers);
    formController.addListener(_onFormChanged);

    _onFormChanged();
    // Initial state initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serverDatabaseProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    formController.removeListener(_onFormChanged);

    controllers.whereType<ChangeNotifier>().forEach(
      (listenable) => listenable.dispose(),
    );

    _validation.dispose();

    _error.dispose();

    super.dispose();
  }
  /* #endregion */

  void _onFormChanged() {
    final text = serverCode.text.trim();
    if (text.length != 8) {
      _validation.value = false;
      _error.value = 'Length error';
      return;
    }

    if (int.tryParse(text) == null) {
      _validation.value = false;
      _error.value = 'Type error';
      return;
    }

    _validation.value = true;
    _error.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final serverDatabaseState = ref.watch(serverDatabaseProvider);

    /// блять/бля/бла
    ref.listen(serverDatabaseProvider, (prev, current) {
      if (current is ServerDatabase$CompletedState &&
          current.serverDatabase != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthWidget()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('Server database auth')),
      body: CustomScrollView(
        slivers: [
          switch (serverDatabaseState) {
            ServerDatabase$InitialState() => SliverToBoxAdapter(
              child: SizedBox.shrink(),
            ),
            ServerDatabase$InProgressState() => SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            ServerDatabase$ErrorState(:final error) => SliverFillRemaining(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(serverDatabaseProvider.notifier).load();
                    },
                    child: Text('Reset'),
                  ),
                ],
              ),
            ),
            ServerDatabase$CompletedState() => SliverFillRemaining(
              child: Column(
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
                children: [
                  TextField(controller: serverCode),

                  ListenableBuilder(
                    listenable: _validation,
                    builder: (context, child) {
                      return TextButton(
                        onPressed: _validation.value
                            ? () {
                                ref
                                    .read(serverDatabaseProvider.notifier)
                                    .remoteServerDatabase(
                                      uid: serverCode.text.trim(),
                                      onMessage: (message) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                              SnackBar(content: Text(message)),
                                            );
                                      },
                                    );
                              }
                            : null,
                        child: Text('Submit'),
                      );
                    },
                  ),

                  ListenableBuilder(
                    listenable: _error,
                    builder: (context, child) {
                      if (_error.value != null) {
                        return Text(_error.value!);
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          },
        ],
      ),
    );
  }
}
