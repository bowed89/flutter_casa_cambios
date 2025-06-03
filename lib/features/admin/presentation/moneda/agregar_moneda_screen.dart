import 'package:casa_de_cambios/features/operaciones/domain/model/moneda_model.dart';
import 'package:casa_de_cambios/features/operaciones/domain/providers/moneda_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgregarMonedaScreen extends ConsumerStatefulWidget {
  final Moneda? moneda;

  const AgregarMonedaScreen({super.key, this.moneda});

  @override
  ConsumerState<AgregarMonedaScreen> createState() => _AgregarMonedaScreenState();
}

class _AgregarMonedaScreenState extends ConsumerState<AgregarMonedaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tipoCambioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.moneda != null) {
      _nombreController.text = widget.moneda!.nombre;
      _tipoCambioController.text = widget.moneda!.tipoCambio.toString();
    }
  }

  Future<void> _guardarMoneda() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text.trim();
      final tipoCambio =
          double.tryParse(_tipoCambioController.text.trim()) ?? 0.0;

      final moneda = Moneda(
        id: widget.moneda?.id,
        nombre: nombre,
        tipoCambio: tipoCambio,
      );

      final monedaService = ref.read(monedaServiceProvider);

      if (widget.moneda == null) {
        await monedaService.addMoneda(moneda);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Moneda agregada correctamente')),
          );
        }
      } else {
        await monedaService.updateMoneda(moneda);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Moneda actualizada correctamente')),
          );
        }
      }

      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _tipoCambioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEditar = widget.moneda != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEditar ? 'Editar Moneda' : 'Agregar Nueva Moneda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de la moneda'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Campo obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tipoCambioController,
                decoration: const InputDecoration(labelText: 'Tipo de cambio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final number = double.tryParse(value ?? '');
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  } else if (number == null || number <= 0) {
                    return 'Ingrese un valor válido mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _guardarMoneda,
                icon: const Icon(Icons.save),
                label: Text(esEditar ? 'Actualizar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
