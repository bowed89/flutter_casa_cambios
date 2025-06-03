import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/admin/presentation/home/admin_home_screen.dart';
import 'features/cliente/presentation/home/cliente_home_screen.dart';
import 'core/routing/guarded_route.dart'; 

/* void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //

  final dbHelper = DBHelper();
  await dbHelper.borrarBaseDeDatos();
  runApp(const ProviderScope(child: MyApp()));
} */

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Casa de Cambios',
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/admin':
            (_) => GuardedRoute(
              allowedRoles: ['admin'],
              builder: (_) => AdminHomeScreen(),
            ),
        '/cliente':
            (_) => GuardedRoute(
              allowedRoles: ['cliente'],
              builder: (_) => ClienteHomeScreen(),
            ),
      },
    );
  }
}
