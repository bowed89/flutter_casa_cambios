import 'package:casa_de_cambios/features/auth/domain/providers/auth_provider.dart';
import 'package:casa_de_cambios/features/operaciones/domain/model/venta_model.dart';
import 'package:casa_de_cambios/features/operaciones/domain/providers/moneda_provider.dart';
import 'package:casa_de_cambios/features/operaciones/domain/providers/venta_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgregarTipoCambioScreen extends ConsumerStatefulWidget {
  final Venta? tipoExistente; 

  const AgregarTipoCambioScreen({super.key, this.tipoExistente});

  @override
  ConsumerState<AgregarTipoCambioScreen> createState() => _AgregarTipoCambioScreenState();
}

class _AgregarTipoCambioScreenState extends ConsumerState<AgregarTipoCambioScreen> {
  late TextEditingController _montoController;
  int? _monedaSeleccionada;
  List<DropdownMenuItem<int>> monedasDropdown = [];

  @override
  void initState() {
    super.initState();
    _montoController = TextEditingController(
      text: widget.tipoExistente?.montoVenta?.toString() ?? '',
    );
    _monedaSeleccionada = widget.tipoExistente?.idMoneda;
    _cargarMonedas();
  }

  Future<void> _cargarMonedas() async {
    final monedaService = ref.read(monedaServiceProvider);
    final lista = await monedaService.getAllMonedas();
    setState(() {
      monedasDropdown = lista
          .map((m) => DropdownMenuItem<int>(
                value: m.id!,
                child: Text(m.nombre),
              ))
          .toList();
    });
  }

  Future<void> _guardarTipoCambio() async {
    final ventaService = ref.read(ventaServiceProvider);
    final monto = double.tryParse(_montoController.text) ?? 0;
    final moneda = _monedaSeleccionada;

    if (moneda == null || monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    final user = ref.read(authUserProvider);
    if (user == null) return;

    final nuevaVenta = Venta(
      id: widget.tipoExistente?.id,
      idUsuario: user.id!,
      idMoneda: moneda,
      montoVenta: monto,
    );

    final esEditar = widget.tipoExistente != null;

    if (esEditar) {
      await ventaService.updateVenta(nuevaVenta);
    } else {
      await ventaService.addVenta(nuevaVenta);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(esEditar
              ? 'Tipo de cambio actualizado correctamente'
              : 'Tipo de cambio agregado correctamente'),
        ),
      );
      Navigator.pop(context, true); 
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = widget.tipoExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Tipo de Cambio' : 'Agregar Tipo de Cambio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: _monedaSeleccionada,
              items: monedasDropdown,
              onChanged: (value) => setState(() => _monedaSeleccionada = value),
              decoration: const InputDecoration(labelText: 'Moneda'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto de Venta'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _guardarTipoCambio,
              child: Text(esEditar ? 'Actualizar' : 'Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
