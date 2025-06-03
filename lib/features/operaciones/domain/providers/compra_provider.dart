import 'package:casa_de_cambios/features/operaciones/application/service/compra_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/compra_repository.dart';
import '../repositories/i_compra_repository.dart';

final compraRepositoryProvider = Provider<ICompraRepository>((ref) {
  return CompraRepository();
});

final compraServiceProvider = Provider<CompraService>((ref) {
  final repository = ref.watch(compraRepositoryProvider);
  return CompraService(repository);
});
