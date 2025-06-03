import 'package:casa_de_cambios/features/admin/presentation/tipo_cambio/agregar_tipo_cambio_screen.dart';
import 'package:casa_de_cambios/features/auth/domain/providers/auth_provider.dart';
import 'package:casa_de_cambios/features/operaciones/domain/model/venta_model.dart';
import 'package:casa_de_cambios/features/operaciones/domain/providers/moneda_provider.dart';
import 'package:casa_de_cambios/features/operaciones/domain/providers/venta_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerTipoCambioScreen extends ConsumerStatefulWidget {
  const VerTipoCambioScreen({super.key});

  @override
  ConsumerState<VerTipoCambioScreen> createState() =>
      _VerTipoCambioScreenState();
}

class _VerTipoCambioScreenState extends ConsumerState<VerTipoCambioScreen> {
  List<Venta> tiposCambio = [];
  Map<int, String> nombreMonedas = {};
  Map<int, String> nombreUsuarios = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final tipoCambioService = ref.read(ventaServiceProvider);
    final monedaService = ref.read(monedaServiceProvider);
    final usuarioService = ref.read(authServiceProvider);

    final listaTipoCambio = await tipoCambioService.getAllVentas();
    final listaMonedas = await monedaService.getAllMonedas();
    final listaUsuarios = await usuarioService.getAllUsuarios();

    final mapaMonedas = {for (var m in listaMonedas) m.id!: m.nombre};
    final mapaUsuarios = {for (var u in listaUsuarios) u.id!: u.email};

    setState(() {
      tiposCambio = listaTipoCambio;
      nombreMonedas = mapaMonedas;
      nombreUsuarios = mapaUsuarios;
    });
  }

  Future<void> _confirmarEliminacion(Venta venta) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text(
              '¿Estás seguro de que deseas eliminar este tipo de cambio?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );

    if (confirmado == true) {
      final ventaService = ref.read(ventaServiceProvider);
      await ventaService.deleteVenta(venta.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tipo de cambio eliminado correctamente'),
          ),
        );
        _cargarDatos();
      }
    }
  }

  Future<void> _editarTipoCambio(Venta venta) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarTipoCambioScreen(tipoExistente: venta),
      ),
    );

    if (resultado == true) {
      _cargarDatos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ver Tipos de Cambio')),
      body:
          tiposCambio.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: tiposCambio.length,
                itemBuilder: (context, index) {
                  final tipo = tiposCambio[index];
                  final nombreMoneda =
                      nombreMonedas[tipo.idMoneda] ?? 'Moneda desconocida';
                  final nombreUsuario =
                      nombreUsuarios[tipo.idUsuario] ?? 'Usuario desconocido';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        nombreMoneda,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Moneda: $nombreMoneda'),
                          Text('Usuario: $nombreUsuario'),
                          Text('Monto de Venta: ${tipo.montoVenta}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editarTipoCambio(tipo),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmarEliminacion(tipo),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
