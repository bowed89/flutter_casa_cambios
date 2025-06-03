import 'package:casa_de_cambios/features/auth/domain/model/auth_model.dart';
import 'package:casa_de_cambios/features/auth/domain/providers/auth_provider.dart';
import 'package:casa_de_cambios/features/auth/presentation/register_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerClientesScreen extends ConsumerStatefulWidget {
  const VerClientesScreen({super.key});

  @override
  ConsumerState<VerClientesScreen> createState() => _VerClientesScreenState();
}

class _VerClientesScreenState extends ConsumerState<VerClientesScreen> {
  late Future<List<Usuarios>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = ref.read(authServiceProvider).getAllUsuarios();
  }

  Future<void> _reloadUsuarios() async {
    setState(() {
      _usuariosFuture = ref.read(authServiceProvider).getAllUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Usuarios')),
      body: FutureBuilder<List<Usuarios>>(
        future: _usuariosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final clientes = snapshot.data!.toList();

          if (clientes.isEmpty) {
            return const Center(child: Text('No hay clientes registrados.'));
          }

          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final usuario = clientes[index];
              return ListTile(
                leading: const Icon(Icons.person_2_rounded),
                title: Text(usuario.email),
                subtitle: Text('Rol: ${usuario.rol}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => RegisterUserScreen(usuario: usuario),
                          ),
                        );
                        if (result == true) {
                          await _reloadUsuarios();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Confirmar eliminación'),
                                content: Text(
                                  '¿Estás seguro de eliminar a ${usuario.email}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          try {
                            await ref
                                .read(authServiceProvider)
                                .delete(usuario.id!);
                            await _reloadUsuarios();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${usuario.email} eliminado.'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al eliminar usuario.'),
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
