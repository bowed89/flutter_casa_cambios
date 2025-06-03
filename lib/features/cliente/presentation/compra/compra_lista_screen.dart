import 'dart:convert';
import 'dart:typed_data';

import 'package:casa_de_cambios/features/operaciones/domain/model/compra_detallada_model.dart';
import 'package:casa_de_cambios/features/operaciones/domain/model/compra_model.dart';
import 'package:casa_de_cambios/features/operaciones/domain/providers/compra_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompraListScreen extends ConsumerStatefulWidget {
  const CompraListScreen({super.key});

  @override
  ConsumerState<CompraListScreen> createState() => _CompraListScreenState();
}

class _CompraListScreenState extends ConsumerState<CompraListScreen> {
  late Future<List<CompraDetallada>> _comprasFuture;

  @override
  void initState() {
    super.initState();
     _cargarCompras();
    _comprasFuture = _cargarCompras();
  }

  Future<List<CompraDetallada>> _cargarCompras() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');

    if (userIdString == null) return [];
    final userId = int.tryParse(userIdString);

    final compraService = ref.read(compraServiceProvider);
    final todas = await compraService.getCompraDetallada();

    print("todas777 ===> ${todas}");

    return todas.where((c) => c.id_usuario == userId).toList();
  }

  Future<void> _eliminarCompra(int id) async {
    final compraService = ref.read(compraServiceProvider);
    await compraService.deleteCompra(id);
    setState(() {
      _comprasFuture = _cargarCompras();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Compra eliminada')));
  }

  void _confirmarEliminacion(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text('¿Deseas eliminar esta compra?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _eliminarCompra(id);
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildImagenBase64(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return const Icon(Icons.image_not_supported);
    }

    try {
      Uint8List bytes = base64Decode(base64String);
      return Image.memory(bytes, width: 60, height: 60, fit: BoxFit.cover);
    } catch (e) {
      return const Icon(Icons.broken_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Compras')),
      body: FutureBuilder<List<CompraDetallada>>(
        future: _comprasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final compras = snapshot.data ?? [];

          if (compras.isEmpty) {
            return const Center(child: Text('No tienes compras registradas.'));
          }

          return ListView.builder(
            itemCount: compras.length,
            itemBuilder: (context, index) {
              final compra = compras[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: _buildImagenBase64(compra.imagen),
                  title: Text(
                    'Compra: \$${compra.monto_compra.toStringAsFixed(2)} ${compra.nombre_moneda}',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total pagado: ${compra.total_pagar} Bs.'),
                      Text('Tipo de cambio: ${compra.tipo_cambio} Bs.'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmarEliminacion(context, compra.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
