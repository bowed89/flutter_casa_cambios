import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/model/auth_model.dart';
import '../domain/providers/auth_provider.dart';

class RegisterUserScreen extends ConsumerStatefulWidget {
  final Usuarios? usuario;

  const RegisterUserScreen({super.key, this.usuario});

  @override
  ConsumerState<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends ConsumerState<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'cliente';
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      isEditing = true;
      emailController.text = widget.usuario!.email;
      passwordController.text = widget.usuario!.password;
      selectedRole = widget.usuario!.rol;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Usuario' : 'Registrar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Campo requerido';
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                  if (!emailRegex.hasMatch(value)) return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator:
                    (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: 'cliente', child: Text('Cliente')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = Usuarios(
                      id: widget.usuario?.id,
                      email: emailController.text,
                      password: passwordController.text,
                      rol: selectedRole,
                    );

                    try {
                      if (isEditing) {
                        await authService.updateUser(user);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Usuario actualizado correctamente',
                              ),
                            ),
                          );
                          Navigator.pop(context, true);
                        }
                      } else {
                        await authService.register(user);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuario registrado correctamente'),
                            ),
                          );
                          _formKey.currentState!.reset();
                          emailController.clear();
                          passwordController.clear();
                          Navigator.pop(context, true);
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Error: Verifique que el correo no fue registrado',
                            ),
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text(
                  isEditing ? 'Guardar Cambios' : 'Registrar Usuario',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
