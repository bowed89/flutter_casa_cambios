import 'package:casa_de_cambios/features/operaciones/domain/model/moneda_model.dart';
import 'package:casa_de_cambios/features/operaciones/domain/providers/moneda_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'agregar_moneda_screen.dart';

class VerMonedaScreen extends ConsumerStatefulWidget {
  const VerMonedaScreen({super.key});

  @override
  ConsumerState<VerMonedaScreen> createState() => _VerMonedasScreenState();
}

class _VerMonedasScreenState extends ConsumerState<VerMonedaScreen> {
  late Future<List<Moneda>> _monedasFuture;

  @override
  void initState() {
    super.initState();
    _monedasFuture = _cargarMonedas();
  }

  Future<List<Moneda>> _cargarMonedas() {
    final monedaService = ref.read(monedaServiceProvider);
    return monedaService.getAllMonedas();
  }

  Future<void> _eliminarMoneda(int id) async {
    final monedaService = ref.read(monedaServiceProvider);
    await monedaService.deleteMoneda(id);
    setState(() {
      _monedasFuture = _cargarMonedas();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Moneda eliminada')));
  }

  void _editarMoneda(Moneda moneda) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AgregarMonedaScreen(moneda: moneda)),
    ).then(
      (_) => setState(() {
        _monedasFuture = _cargarMonedas();
      }),
    );
  }

  void _confirmarEliminacion(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text('¿Deseas eliminar esta moneda?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _eliminarMoneda(id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monedas Registradas')),
      body: FutureBuilder<List<Moneda>>(
        future: _monedasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final monedas = snapshot.data ?? [];

          if (monedas.isEmpty) {
            return const Center(child: Text('No hay monedas registradas.'));
          }

          return ListView.builder(
            itemCount: monedas.length,
            itemBuilder: (context, index) {
              final moneda = monedas[index];
              return ListTile(
                leading: const Icon(Icons.monetization_on),
                title: Text(moneda.nombre),
                subtitle: Text('Tipo de cambio: ${moneda.tipoCambio}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editarMoneda(moneda),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed:
                          () => _confirmarEliminacion(context, moneda.id!),
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
