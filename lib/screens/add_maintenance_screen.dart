import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/vehicle_provider.dart';
import '../models/vehicle.dart';

class AddMaintenanceScreen extends StatefulWidget {
  final String vehicleId;
  final Maintenance? existing;
  const AddMaintenanceScreen({super.key, required this.vehicleId, this.existing});
  @override State<AddMaintenanceScreen> createState() => _State();
}

class _State extends State<AddMaintenanceScreen> {
  final _tipos = ['Troca de Óleo','Revisão Geral','Freios','Pneus','Filtro de Ar','Alinhamento','Correia Dentada','Velas','Bateria','Suspensão','Embreagem','Outro'];
  String _tipo = 'Troca de Óleo';
  DateTime _data = DateTime.now();
  final _custo = TextEditingController();
  final _obs   = TextEditingController();
  final _ofic  = TextEditingController();
  final _pec   = TextEditingController();
  final _out   = TextEditingController();

  @override void initState() {
    super.initState();
    final m = widget.existing; if (m == null) return;
    _tipo = m.tipo; _data = m.data;
    _custo.text = m.custo?.toStringAsFixed(2) ?? '';
    _obs.text = m.obs; _ofic.text = m.oficina;
    _pec.text = m.pecas; _out.text = m.tipo=='Outro' ? m.obs : '';
  }
  @override void dispose() { _custo.dispose(); _obs.dispose(); _ofic.dispose(); _pec.dispose(); _out.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final v = context.read<VehicleProvider>().byId(widget.vehicleId);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(widget.existing != null ? 'EDITAR MANUTENÇÃO' : 'NOVA MANUTENÇÃO'),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(14), margin: const EdgeInsets.only(bottom:16),
          decoration: BoxDecoration(color:AppColors.blueL, borderRadius:BorderRadius.circular(12), border:Border.all(color:AppColors.blueB)),
          child: Row(children: [
            const Icon(Icons.speed_rounded, color:AppColors.primary, size:22), const SizedBox(width:12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('KM NO MOMENTO', style: TextStyle(fontFamily:'Orbitron', fontSize:8, color:AppColors.primary, letterSpacing:1)),
              Text('${fmtKm(v?.km??0)} km', style: const TextStyle(fontFamily:'Orbitron', fontSize:16, color:AppColors.primary, fontWeight:FontWeight.w700)),
            ])])),
        const Text('TIPO', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
        const SizedBox(height: 8),
        Wrap(spacing:7, runSpacing:7, children: _tipos.map((t) => GestureDetector(
          onTap: () => setState(() => _tipo = t),
          child: Container(padding: const EdgeInsets.symmetric(horizontal:12, vertical:6),
            decoration: BoxDecoration(color:_tipo==t?AppColors.blueL:AppColors.surface, borderRadius:BorderRadius.circular(20), border:Border.all(color:_tipo==t?AppColors.primary:AppColors.border)),
            child: Text(t, style: TextStyle(fontSize:11, color:_tipo==t?AppColors.primary:AppColors.textSec, fontWeight:_tipo==t?FontWeight.w600:FontWeight.normal))))).toList()),
        if (_tipo == 'Outro') ...[
          const SizedBox(height: 12),
          const Text('DESCREVA', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
          const SizedBox(height: 5),
          TextField(controller: _out, decoration: const InputDecoration(hintText:'Ex: Troca correia auxiliar...')),
        ],
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('DATA', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _data, firstDate: DateTime(2000), lastDate: DateTime.now());
                if (d != null) setState(() => _data = d);
              },
              child: Container(padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color:AppColors.surfaceVar, borderRadius:BorderRadius.circular(10), border:Border.all(color:AppColors.border)),
                child: Row(children: [const Icon(Icons.calendar_today_rounded, size:16, color:AppColors.primary), const SizedBox(width:8), Text(fmtDate(_data))]))),
          ])),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('CUSTO R\$', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
            const SizedBox(height: 5),
            TextField(controller: _custo, keyboardType: const TextInputType.numberWithOptions(decimal:true), decoration: const InputDecoration(hintText:'250,00')),
          ])),
        ]),
        const SizedBox(height: 12),
        const Text('OFICINA / LOCAL', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
        const SizedBox(height: 5),
        TextField(controller: _ofic, decoration: const InputDecoration(hintText:'Ex: Mecânica do João...')),
        const SizedBox(height: 12),
        const Text('PEÇAS E MARCAS', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
        const SizedBox(height: 5),
        TextField(controller: _pec, maxLines: 2, decoration: const InputDecoration(hintText:'Ex: Bosch - filtro, Castrol 5W30...')),
        const SizedBox(height: 12),
        const Text('OBSERVAÇÕES', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.primary, letterSpacing:1)),
        const SizedBox(height: 5),
        TextField(controller: _obs, maxLines: 2, decoration: const InputDecoration(hintText:'Ex: Próxima troca em 5.000 km...')),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: _save, child: Text(widget.existing != null ? 'SALVAR ALTERAÇÕES' : 'REGISTRAR MANUTENÇÃO')),
      ])));
  }

  void _save() {
    final p = context.read<VehicleProvider>();
    final v = p.byId(widget.vehicleId); if (v == null) return;
    final m = Maintenance(
      id: widget.existing?.id ?? p.newMId(), tipo: _tipo, data: _data,
      kmNa: widget.existing?.kmNa ?? v.km,
      custo: double.tryParse(_custo.text.replaceAll(',','.')),
      obs: _tipo=='Outro' ? _out.text.trim() : _obs.text.trim(),
      oficina: _ofic.text.trim(), pecas: _pec.text.trim());
    widget.existing != null ? p.editMaint(widget.vehicleId, m) : p.addMaint(widget.vehicleId, m);
    Navigator.pop(context);
  }
}
