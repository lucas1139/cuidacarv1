import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/vehicle_provider.dart';
import '../models/vehicle.dart';
import 'add_maintenance_screen.dart';
import 'edit_vehicle_screen.dart';

class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;
  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(builder: (ctx, p, _) {
      final v = p.byId(vehicleId);
      if (v == null) { Navigator.pop(ctx); return const SizedBox(); }
      final s = v.status; final c = AppColors.sc(s);
      final sorted = [...v.manutencoes]..sort((a,b) => b.data.compareTo(a.data));

      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: Text('${v.marca} ${v.modelo}'),
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(ctx)),
          actions: [
            IconButton(icon: const Icon(Icons.edit_outlined, color:AppColors.primary),
              onPressed: () => Navigator.push(ctx, MaterialPageRoute(builder:(_) => EditVehicleScreen(vehicleId: vehicleId)))),
            IconButton(icon: const Icon(Icons.delete_outline_rounded, color:AppColors.red),
              onPressed: () => _confirmDelete(ctx, p, v)),
          ],
        ),
        body: SingleChildScrollView(padding: const EdgeInsets.all(14), child: Column(children: [
          _HeroCard(v: v, c: c),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(ctx, MaterialPageRoute(builder:(_) => AddMaintenanceScreen(vehicleId: vehicleId))),
            icon: const Icon(Icons.add_rounded, color:Colors.white, size:18),
            label: const Text('+ MANUTENÇÃO')),
          const SizedBox(height: 16),
          const Align(alignment: Alignment.centerLeft,
            child: Text('HISTÓRICO', style: TextStyle(fontFamily:'Orbitron', fontSize:8, color:AppColors.primary, letterSpacing:2))),
          const SizedBox(height: 10),
          if (sorted.isEmpty) const _NoMaint(),
          ...sorted.map((m) => _MaintItem(
            m: m, vehicleId: vehicleId,
            onEdit: () => Navigator.push(ctx, MaterialPageRoute(builder:(_) => AddMaintenanceScreen(vehicleId: vehicleId, existing: m))),
            onDel: () => _confirmDelMaint(ctx, p, m))),
        ])),
      );
    });
  }

  void _confirmDelete(BuildContext ctx, VehicleProvider p, Vehicle v) {
    showDialog(context: ctx, builder: (_) => AlertDialog(
      title: const Text('Excluir veículo?'),
      content: Text('${v.marca} ${v.modelo} será removido permanentemente.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        TextButton(onPressed: () { p.delete(v.id); Navigator.pop(ctx); Navigator.pop(ctx); },
          child: const Text('Excluir', style: TextStyle(color: AppColors.red))),
      ]));
  }

  void _confirmDelMaint(BuildContext ctx, VehicleProvider p, Maintenance m) {
    showDialog(context: ctx, builder: (_) => AlertDialog(
      title: const Text('Excluir manutenção?'),
      content: Text('${m.tipo} de ${fmtDate(m.data)} será removida.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        TextButton(onPressed: () { p.deleteMaint(vehicleId, m.id); Navigator.pop(ctx); },
          child: const Text('Excluir', style: TextStyle(color: AppColors.red))),
      ]));
  }
}

class _HeroCard extends StatelessWidget {
  final Vehicle v; final Color c;
  const _HeroCard({required this.v, required this.c});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(15), border:Border.all(color:AppColors.border)),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${v.marca} ${v.modelo}', style: const TextStyle(fontFamily:'Orbitron', fontSize:14, fontWeight:FontWeight.w700, color:AppColors.text)),
          Text('${v.ano} · ${fmtKm(v.km)} km', style: const TextStyle(fontSize:12, color:AppColors.textMuted)),
        ]),
        Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:5),
          decoration: BoxDecoration(color:AppColors.sl(v.status), borderRadius:BorderRadius.circular(20), border:Border.all(color:AppColors.sb(v.status))),
          child: Text(stLabel(v.status), style: TextStyle(fontSize:11, color:c, fontWeight:FontWeight.w600))),
      ]),
      const SizedBox(height: 14),
      Row(children: [
        _SB(lbl:'KM Atual', val:'${fmtKm(v.km)} km'),
        const SizedBox(width: 8),
        _SB(lbl:'Desde revisão', val:'${fmtKm(v.kmDesde)} km', vc: c),
        const SizedBox(width: 8),
        _SB(lbl:'Próx. revisão', val:'${fmtKm(v.kmProx)} km'),
      ]),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Progresso', style: TextStyle(fontSize:10, color:AppColors.textMuted)),
        Text('${(v.progresso*100).round()}%', style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
      ]),
      const SizedBox(height: 5),
      ClipRRect(borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(value:v.progresso, backgroundColor:AppColors.border,
          valueColor:AlwaysStoppedAnimation(c), minHeight:7)),
    ]));
}

class _SB extends StatelessWidget {
  final String lbl, val; final Color? vc;
  const _SB({required this.lbl, required this.val, this.vc});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical:10),
    decoration: BoxDecoration(color:AppColors.surfaceVar, borderRadius:BorderRadius.circular(10), border:Border.all(color:AppColors.border)),
    child: Column(children: [
      Text(val, style: TextStyle(fontFamily:'Orbitron', fontSize:11, fontWeight:FontWeight.w700, color:vc??AppColors.text)),
      const SizedBox(height: 3),
      Text(lbl, style: const TextStyle(fontSize:8, color:AppColors.textMuted), textAlign: TextAlign.center),
    ])));
}

class _NoMaint extends StatelessWidget {
  const _NoMaint();
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(32),
    child: Column(children: [
      Icon(Icons.build_circle_outlined, size:48, color:AppColors.textMuted.withOpacity(0.4)),
      const SizedBox(height: 12),
      const Text('Nenhuma manutenção registrada', style: TextStyle(color:AppColors.textMuted, fontSize:13)),
    ]));
}

class _MaintItem extends StatelessWidget {
  final Maintenance m; final String vehicleId;
  final VoidCallback onEdit, onDel;
  const _MaintItem({required this.m, required this.vehicleId, required this.onEdit, required this.onDel});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom:8), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(12), border:Border.all(color:AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width:36, height:36,
          decoration: BoxDecoration(color:AppColors.blueL, borderRadius:BorderRadius.circular(9), border:Border.all(color:AppColors.blueB)),
          child: const Icon(Icons.build_rounded, color:AppColors.primary, size:18)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m.tipo=='Outro'&&m.obs.isNotEmpty ? m.obs : m.tipo,
            style: const TextStyle(fontSize:13, fontWeight:FontWeight.w600, color:AppColors.text)),
          const SizedBox(height: 2),
          Text('${fmtKm(m.kmNa)} km · ${fmtDate(m.data)}', style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
          if (m.oficina.isNotEmpty) Text('📍 ${m.oficina}', style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
          if (m.pecas.isNotEmpty) Text('🔩 ${m.pecas}', style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
        ])),
        if (m.custo != null) Text('R\$ ${m.custo!.toStringAsFixed(2)}',
          style: const TextStyle(fontSize:12, color:AppColors.green, fontWeight:FontWeight.w700)),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        _Btn('✏ Editar', AppColors.primary, AppColors.blueL, AppColors.blueB, onEdit),
        const SizedBox(width: 6),
        _Btn('🗑 Excluir', AppColors.red, AppColors.redL, AppColors.redB, onDel),
      ]),
    ]));
}

class _Btn extends StatelessWidget {
  final String lbl; final Color c, bg, b; final VoidCallback t;
  const _Btn(this.lbl, this.c, this.bg, this.b, this.t);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: t,
    child: Container(padding: const EdgeInsets.symmetric(horizontal:12, vertical:5),
      decoration: BoxDecoration(color:bg, borderRadius:BorderRadius.circular(8), border:Border.all(color:b)),
      child: Text(lbl, style: TextStyle(fontSize:11, color:c, fontWeight:FontWeight.w600))));
}
