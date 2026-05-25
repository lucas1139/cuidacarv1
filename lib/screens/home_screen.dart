import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../services/vehicle_provider.dart';
import '../widgets/vehicle_card.dart';
import 'vehicle_detail_screen.dart';
import 'add_vehicle_screen.dart';
import 'chat_screen.dart';
import 'debitos_screen.dart';
import 'shop_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Row(children: [
          Container(width:32, height:32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors:[AppColors.primary, AppColors.primaryL]),
              borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.directions_car_rounded, color:Colors.white, size:18)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('CUIDACAR', style: TextStyle(fontFamily:'Orbitron', fontSize:14, fontWeight:FontWeight.w700, color:AppColors.primary, letterSpacing:2)),
            Text('MANUTENÇÃO VEICULAR', style: TextStyle(fontFamily:'Orbitron', fontSize:7, color:AppColors.textMuted, letterSpacing:1.5)),
          ]),
        ]),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(_) => const InfoScreen())),
            icon: Container(width:32, height:32,
              decoration: BoxDecoration(color:AppColors.blueL, borderRadius:BorderRadius.circular(8), border:Border.all(color:AppColors.blueB)),
              child: const Icon(Icons.info_outline_rounded, color:AppColors.primary, size:17))),
          const SizedBox(width: 4),
        ],
      ),
      body: Consumer<VehicleProvider>(builder: (ctx, p, _) {
        if (p.loading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        final vs = p.sorted;
        return Column(children: [
          if (p.totCrit > 0) _AlertBanner(count: p.totCrit),
          Expanded(child: vs.isEmpty
            ? _EmptyState(onAdd: () => Navigator.push(context, MaterialPageRoute(builder:(_) => const AddVehicleScreen())))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 100),
                itemCount: vs.length,
                itemBuilder: (_, i) => VehicleCard(
                  vehicle: vs[i],
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder:(_) => VehicleDetailScreen(vehicleId: vs[i].id)))))),
        ]);
      }),
      bottomNavigationBar: _BottomNav(
        onAdd:    () => Navigator.push(context, MaterialPageRoute(builder:(_) => const AddVehicleScreen())),
        onChat:   () => Navigator.push(context, MaterialPageRoute(builder:(_) => const ChatScreen())),
        onDebits: () => Navigator.push(context, MaterialPageRoute(builder:(_) => const DebitosScreen())),
        onShop:   () => Navigator.push(context, MaterialPageRoute(builder:(_) => const ShopScreen())),
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final int count;
  const _AlertBanner({required this.count});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(14,10,14,0),
    padding: const EdgeInsets.symmetric(horizontal:14, vertical:10),
    decoration: BoxDecoration(color:AppColors.redL, borderRadius:BorderRadius.circular(12), border:Border.all(color:AppColors.redB)),
    child: Row(children: [
      const Icon(Icons.warning_amber_rounded, color:AppColors.red, size:18),
      const SizedBox(width: 8),
      Text('$count veículo${count>1?"s precisam":" precisa"} de manutenção urgente!',
        style: const TextStyle(color:AppColors.red, fontSize:12, fontWeight:FontWeight.w600)),
    ]));
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.directions_car_outlined, size:72, color:AppColors.textMuted.withOpacity(0.4)),
    const SizedBox(height: 16),
    const Text('Nenhum veículo cadastrado', style: TextStyle(color:AppColors.textMuted, fontSize:16)),
    const SizedBox(height: 8),
    const Text('Toque no + para adicionar', style: TextStyle(color:AppColors.textMuted, fontSize:13)),
    const SizedBox(height: 24),
    SizedBox(width:200, child: ElevatedButton(onPressed: onAdd, child: const Text('ADICIONAR VEÍCULO'))),
  ]));
}

class _BottomNav extends StatelessWidget {
  final VoidCallback onAdd, onChat, onDebits, onShop;
  const _BottomNav({required this.onAdd, required this.onChat, required this.onDebits, required this.onShop});

  @override
  Widget build(BuildContext context) => Container(
    height: 70 + MediaQuery.of(context).padding.bottom,
    decoration: const BoxDecoration(
      color: AppColors.surface,
      border: Border(top: BorderSide(color: AppColors.border)),
      boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius:10, offset:Offset(0,-2))]),
    child: Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _NI(icon: Icons.psychology_outlined, label: 'IA', onTap: onChat),
        GestureDetector(onTap: onAdd,
          child: Container(width:50, height:50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors:[AppColors.primary, AppColors.primaryL], begin:Alignment.topLeft, end:Alignment.bottomRight),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color:AppColors.primary.withOpacity(0.35), blurRadius:12, offset:const Offset(0,4))]),
            child: const Icon(Icons.add_rounded, color:Colors.white, size:26))),
        _NI(icon: Icons.attach_money_rounded, label: 'Débitos', onTap: onDebits),
        _NI(icon: Icons.storefront_outlined, label: 'Loja', onTap: onShop),
      ])),
  );
}

class _NI extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _NI({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque,
    child: Padding(padding: const EdgeInsets.symmetric(horizontal:12, vertical:8),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color:AppColors.textMuted, size:22),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontFamily:'Orbitron', fontSize:6, color:AppColors.textMuted, letterSpacing:0.5)),
      ])));
}
p
