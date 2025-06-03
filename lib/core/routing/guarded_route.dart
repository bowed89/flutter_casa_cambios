import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/domain/providers/auth_provider.dart';
import '../../../features/auth/presentation/login_screen.dart';

class GuardedRoute extends ConsumerWidget {
  final WidgetBuilder builder;
  final List<String> allowedRoles;

  const GuardedRoute({
    super.key,
    required this.builder,
    required this.allowedRoles,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider);

    if (user == null) {
      // No autenticado, redirigir al login
      return const LoginScreen();
    }

    if (!allowedRoles.contains(user.rol)) {
      // Rol no permitido
      return Scaffold(
        appBar: AppBar(title: const Text('Acceso denegado')),
        body: const Center(
          child: Text('No tienes permiso para acceder a esta sección.'),
        ),
      );
    }

    return builder(context);
  }
}
