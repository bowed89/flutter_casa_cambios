import 'package:casa_de_cambios/features/auth/domain/model/auth_model.dart';
import 'package:casa_de_cambios/features/auth/domain/repositories/i_auth_repository.dart';

class AuthService {
  final IAuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<List<Usuarios>> getAllUsuarios() => _authRepository.getAll();

  Future<Usuarios?> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }

  Future<void> register(Usuarios usuario) async {
    await _authRepository.registerUser(usuario);
  }

  Future<void> updateUser(Usuarios usuario) =>
      _authRepository.updateUser(usuario);
  Future<void> delete(int id) => _authRepository.delete(id);
}
