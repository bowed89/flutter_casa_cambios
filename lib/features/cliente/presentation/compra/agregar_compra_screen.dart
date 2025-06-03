import 'dart:io';
import 'package:casa_de_cambios/features/operaciones/domain/model/compra_model.dart';
import 'package:casa_de_cambios/features/operaciones/domain/model/venta_con_moneda.dart';
import 'package:casa_de_cambios/features/operaciones/domain/model/venta_model.dart';
import 'package:casa_de_cambios/features/operaciones/domain/providers/compra_provider.dart';
import 'package:casa_de_cambios/features/operaciones/domain/providers/venta_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class AgregarCompraScreen extends ConsumerStatefulWidget {
  const AgregarCompraScreen({super.key});

  @override
  ConsumerState<AgregarCompraScreen> createState() =>
      _AgregarCompraScreenState();
}

class _AgregarCompraScreenState extends ConsumerState<AgregarCompraScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoCompraController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();

  int? _userId;
  VentaConMoneda? _ventaSeleccionada;
  List<VentaConMoneda> _ventas = [];

  double _totalPagar = 0;

  @override
  void initState() {
    super.initState();
    _cargarUserId();
    _cargarVentas();

    _montoCompraController.addListener(_calcularTotalPagar);
  }

  void _calcularTotalPagar() {
    final monto = double.tryParse(_montoCompraController.text);
    if (_ventaSeleccionada != null && monto != null) {
      setState(() {
        _totalPagar = monto * _ventaSeleccionada!.tipoCambio;
      });
    } else {
      setState(() {
        _totalPagar = 0;
      });
    }
  }

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imagenController.text = pickedFile.path;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se tomó ninguna foto')));
    }
  }

  Future<void> _cargarUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');
    if (userIdString != null) {
      setState(() {
        _userId = int.tryParse(userIdString);
      });
    }
  }

  Future<void> _cargarVentas() async {
    try {
      final ventas = await ref.read(ventaServiceProvider).getVentasConMoneda();
      setState(() {
        _ventas = ventas;
      });
    } catch (e) {
      // Manejo de error opcional
    }
  }

  @override
  void dispose() {
    _montoCompraController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  void _guardarCompra() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró ID de usuario.')),
      );
      return;
    }

    if (_ventaSeleccionada == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seleccione una venta')));
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final montoCompra = double.parse(_montoCompraController.text);

      if (montoCompra > _ventaSeleccionada!.montoVenta) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'El monto de compra excede el monto disponible de la venta',
            ),
          ),
        );
        return;
      }

      final imagenPath =
          _imagenController.text.isNotEmpty ? _imagenController.text : null;

      final compra = Compra(
        idVenta: _ventaSeleccionada!.id,
        idUsuario: _userId!,
        montoCompra: montoCompra,
        totalPagar: _totalPagar,
        imagen: imagenPath,
      );

      try {
        final compraService = ref.read(compraServiceProvider);
        await compraService.addCompra(compra);

        final nuevaVenta = Venta(
          id: _ventaSeleccionada!.id,
          idMoneda: _ventaSeleccionada!.id,
          idUsuario: _ventaSeleccionada!.id,
          montoVenta: _ventaSeleccionada!.montoVenta - montoCompra,
        );

        final ventaService = ref.read(ventaServiceProvider);
        await ventaService.updateVenta(nuevaVenta);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra agregada exitosamente')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar compra: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Compra')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<VentaConMoneda>(
                decoration: const InputDecoration(labelText: 'Venta'),
                items:
                    _ventas.map((venta) {
                      return DropdownMenuItem<VentaConMoneda>(
                        value: venta,
                        child: Text(
                          'Moneda: ${venta.nombreMoneda} - Monto Disponible: ${venta.montoVenta}',
                        ),
                      );
                    }).toList(),
                onChanged: (venta) {
                  setState(() {
                    _ventaSeleccionada = venta;
                  });
                  _calcularTotalPagar();
                },
                validator:
                    (value) => value == null ? 'Seleccione una venta' : null,
                value: _ventaSeleccionada,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _montoCompraController,
                decoration: const InputDecoration(labelText: 'Monto Compra'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el monto de la compra';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Debe ser un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Total a pagar en Bs: ${_totalPagar.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 12),
              if (_ventaSeleccionada != null)
                Text(
                  'Tipo de cambio: ${_ventaSeleccionada!.tipoCambio.toStringAsFixed(2)} Bs.',
                  style: const TextStyle(fontSize: 17),
                ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _tomarFoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Tomar foto del recibo de transferencia'),
              ),
              if (_imagenController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Image.file(File(_imagenController.text), height: 150),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarCompra,
                child: const Text('Guardar Compra'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
