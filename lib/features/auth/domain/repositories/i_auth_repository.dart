import 'package:casa_de_cambios/features/auth/domain/model/auth_model.dart';

abstract class IAuthRepository {
  Future<List<Usuarios>> getAll();
  Future<void> registerUser(Usuarios usuario);
  Future<void> updateUser(Usuarios usuario);
  Future<Usuarios?> login(String email, String password);
  Future<void> delete(int id);
}
