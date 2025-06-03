import 'package:casa_de_cambios/features/operaciones/application/service/moneda_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/moneda_repository.dart';
import '../repositories/i_moneda_repository.dart';

final monedaRepositoryProvider = Provider<IMonedaRepository>((ref) {
  return MonedaRepository();
});

final monedaServiceProvider = Provider<MonedaService>((ref) {
  final repo = ref.watch(monedaRepositoryProvider);
  return MonedaService(repo);
});
