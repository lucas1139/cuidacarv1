import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/vehicle_provider.dart';

class EditVehicleScreen extends StatefulWidget {
  final String vehicleId;
  const EditVehicleScreen({super.key, required this.vehicleId});
  @override State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _fk = GlobalKey<FormState>();
  late final TextEditingController _ma, _mo, _an, _km;

  @override void initState() {
    super.initState();
    final v = context.read<VehicleProvider>().byId(widget.vehicleId)!;
    _ma = TextEditingController(text: v.marca);
    _mo = TextEditingController(text: v.modelo);
    _an = TextEditingController(text: v.ano.toString());
    _km = TextEditingController(text: v.km.toString());
  }
  @override void dispose() { _ma.dispose(); _mo.dispose(); _an.dispose(); _km.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(title: const Text('EDITAR VEÍCULO'),
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context))),
    body: Form(key: _fk, child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
      TextFormField(controller: _ma, decoration: const InputDecoration(labelText:'Marca'),
        validator: (v) => v==null||v.isEmpty ? 'Obrigatório' : null),
      const SizedBox(height: 12),
      TextFormField(controller: _mo, decoration: const InputDecoration(labelText:'Modelo'),
        validator: (v) => v==null||v.isEmpty ? 'Obrigatório' : null),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: TextFormField(controller: _an, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText:'Ano'))),
        const SizedBox(width: 12),
        Expanded(child: TextFormField(controller: _km, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText:'KM'))),
      ]),
      const SizedBox(height: 24),
      ElevatedButton(onPressed: _save, child: const Text('SALVAR ALTERAÇÕES')),
    ]))));

  void _save() {
    if (!_fk.currentState!.validate()) return;
    context.read<VehicleProvider>().edit(widget.vehicleId,
      marca: _ma.text.trim(), modelo: _mo.text.trim(),
      ano: int.tryParse(_an.text), km: int.tryParse(_km.text));
    Navigator.pop(context);
  }
}
