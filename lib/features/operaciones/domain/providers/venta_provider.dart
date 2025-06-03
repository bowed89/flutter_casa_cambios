import 'package:casa_de_cambios/features/operaciones/application/service/venta_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/venta_repository.dart';
import '../repositories/i_venta_repository.dart';

final ventaRepositoryProvider = Provider<IVentaRepository>((ref) {
  return VentaRepository();
});

final ventaServiceProvider = Provider<VentaService>((ref) {
  final repository = ref.watch(ventaRepositoryProvider);
  return VentaService(repository);
});
