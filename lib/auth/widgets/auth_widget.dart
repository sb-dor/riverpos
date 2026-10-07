import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpos/auth/providers/auth_provider.dart';
import 'package:riverpos/orders/widgets/orders_scope.dart';

/// {@template auth_widget}
/// AuthWidget widget.
/// {@endtemplate}
class AuthWidget extends ConsumerStatefulWidget {
  /// {@macro auth_widget}
  const AuthWidget({
    super.key, // ignore: unused_element_parameter
  });

  @override
  ConsumerState<AuthWidget> createState() => _AuthWidgetState();
}

/// State for widget AuthWidget.
class _AuthWidgetState extends ConsumerState<AuthWidget> {
  final email = TextEditingController();
  final password = TextEditingController();
  late final controllers = [email, password];

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
  }

  @override
  void dispose() {
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
    final emailText = email.text.trim();
    final passwordText = password.text;

    if (emailText.isEmpty || passwordText.isEmpty) {
      _validation.value = false;
      _error.value = 'Email and password are required';
      return;
    }

    final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailPattern.hasMatch(emailText)) {
      _validation.value = false;
      _error.value = 'Invalid email address';
      return;
    }

    if (passwordText.length < 6) {
      _validation.value = false;
      _error.value = 'Password must be at least 8 characters';
      return;
    }

    _validation.value = true;
    _error.value = null;
  }

  @override
  Widget build(BuildContext context) {
    //
    ref.listen(authProvider, (prev, current) {
      if (current is AuthenticatedState) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrdersScope()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('User auth')),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: .center,
              children: [
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                ListenableBuilder(
                  listenable: _validation,
                  builder: (context, child) {
                    return TextButton(
                      onPressed: _validation.value
                          ? () {
                              ref
                                  .read(authProvider.notifier)
                                  .signIn(
                                    email: email.text.trim(),
                                    password: password.text.trim(),
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
        ],
      ),
    );
  }
}
