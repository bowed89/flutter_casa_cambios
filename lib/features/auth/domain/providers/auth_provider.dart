import 'package:casa_de_cambios/features/auth/application/auth_service.dart';
import 'package:casa_de_cambios/features/auth/domain/model/auth_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import '../repositories/i_auth_repository.dart';

final authUserProvider = StateProvider<Usuarios?>((ref) => null);
/// Proveedor del repositorio de autenticación
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository();
});

/// Proveedor del servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthService(repo);
});
