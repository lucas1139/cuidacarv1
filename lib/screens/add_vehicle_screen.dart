import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/vehicle_provider.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});
  @override State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _fk = GlobalKey<FormState>();
  String _marca = 'Toyota';
  final _mCtrl = TextEditingController();
  final _aCtrl = TextEditingController();
  final _kCtrl = TextEditingController();
  final _brands = ['Toyota','Fiat','Chevrolet','Volkswagen','Honda','Hyundai','Renault','Ford','Jeep','Nissan'];

  @override void dispose() { _mCtrl.dispose(); _aCtrl.dispose(); _kCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(title: const Text('NOVO VEÍCULO'),
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context))),
    body: Form(key: _fk, child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('MARCA', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
      const SizedBox(height: 8),
      Wrap(spacing:8, runSpacing:8, children: _brands.map((b) => GestureDetector(
        onTap: () => setState(() => _marca = b),
        child: Container(padding: const EdgeInsets.symmetric(horizontal:12, vertical:8),
          decoration: BoxDecoration(
            color: _marca==b ? AppColors.blueL : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _marca==b ? AppColors.primary : AppColors.border)),
          child: Text(b, style: TextStyle(fontSize:12, color:_marca==b ? AppColors.primary : AppColors.textSec,
            fontWeight: _marca==b ? FontWeight.w600 : FontWeight.normal))))).toList()),
      const SizedBox(height: 16),
      const Text('MODELO', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
      const SizedBox(height: 5),
      TextFormField(controller: _mCtrl, decoration: const InputDecoration(hintText:'Ex: Corolla, Onix...'),
        validator: (v) => v==null||v.isEmpty ? 'Obrigatório' : null),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ANO', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
          const SizedBox(height: 5),
          TextFormField(controller: _aCtrl, keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText:'2021'),
            validator: (v) => v==null||v.isEmpty ? 'Obrigatório' : null),
        ])),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('KM ATUAL', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
          const SizedBox(height: 5),
          TextFormField(controller: _kCtrl, keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText:'45000'),
            validator: (v) => v==null||v.isEmpty ? 'Obrigatório' : null),
        ])),
      ]),
      const SizedBox(height: 24),
      ElevatedButton(onPressed: _save, child: const Text('CADASTRAR VEÍCULO')),
    ]))));

  void _save() {
    if (!_fk.currentState!.validate()) return;
    context.read<VehicleProvider>().add(_marca, _mCtrl.text.trim(),
      int.tryParse(_aCtrl.text) ?? DateTime.now().year, int.tryParse(_kCtrl.text) ?? 0);
    Navigator.pop(context);
  }
}
