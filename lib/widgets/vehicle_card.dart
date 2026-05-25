import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/vehicle.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onTap;
  const VehicleCard({super.key, required this.vehicle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = vehicle.status;
    final c = AppColors.sc(s);
    final l = AppColors.sl(s);
    final b = AppColors.sb(s);
    final u = vehicle.ultima;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border(
            left: BorderSide(color: c, width: 3),
            top: BorderSide(color: b),
            right: BorderSide(color: b),
            bottom: BorderSide(color: b),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width:40, height:40,
                decoration: BoxDecoration(color: l, borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(
                  s==VehicleStatus.ok ? '🟢' : s==VehicleStatus.warn ? '🟡' : '🔴',
                  style: const TextStyle(fontSize: 20)))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${vehicle.marca} ${vehicle.modelo}',
                  style: const TextStyle(fontFamily:'Orbitron', fontSize:12, fontWeight:FontWeight.w600, color:AppColors.text, letterSpacing:0.5)),
                const SizedBox(height: 2),
                Text('${vehicle.ano} · ${fmtKm(vehicle.km)} km',
                  style: const TextStyle(fontSize:11, color:AppColors.textMuted)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal:10, vertical:4),
                decoration: BoxDecoration(color:l, borderRadius:BorderRadius.circular(20), border:Border.all(color:b)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width:5, height:5, decoration: BoxDecoration(color:c, shape:BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text(stLabel(s), style: TextStyle(fontSize:10, color:c, fontWeight:FontWeight.w600)),
                ])),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${fmtKm(vehicle.kmDesde)} km desde revisão', style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
              Text('Próx: ${fmtKm(vehicle.kmProx)} km', style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
            ]),
            const SizedBox(height: 5),
            ClipRRect(borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(value: vehicle.progresso, backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation(c), minHeight: 5)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.build_rounded, size:12, color:AppColors.textMuted),
              const SizedBox(width: 5),
              Expanded(child: Text(
                u != null ? '${u.tipo} · ${fmtDate(u.data)}' : 'Sem manutenções registradas',
                style: const TextStyle(fontSize:10, color:AppColors.textMuted),
                overflow: TextOverflow.ellipsis)),
            ]),
          ]),
        ),
      ),
    );
  }
}
