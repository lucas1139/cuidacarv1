import 'package:flutter/material.dart';
import '../theme.dart';

class DebitosScreen extends StatelessWidget {
  const DebitosScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(title: const Text('CONSULTA DE DÉBITOS'),
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context))),
    body: Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width:80, height:80,
        decoration: BoxDecoration(color:AppColors.blueL, shape:BoxShape.circle, border:Border.all(color:AppColors.blueB)),
        child: const Icon(Icons.attach_money_rounded, color:AppColors.primary, size:40)),
      const SizedBox(height: 24),
      const Text('EM BREVE', style: TextStyle(fontFamily:'Orbitron', fontSize:18, color:AppColors.primary, letterSpacing:3)),
      const SizedBox(height: 12),
      const Text('A consulta de débitos veiculares estará disponível em breve.\n\nAguarde novidades!',
        style: TextStyle(fontSize:14, color:AppColors.textSec, height:1.7), textAlign: TextAlign.center),
      const SizedBox(height: 28),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color:AppColors.greenL, borderRadius:BorderRadius.circular(12), border:Border.all(color:AppColors.greenB)),
        child: Column(children: [
          const Text('O QUE ESTARÁ DISPONÍVEL', style: TextStyle(fontFamily:'Orbitron', fontSize:9, color:AppColors.green, letterSpacing:1)),
          const SizedBox(height: 10),
          ...['Multas de trânsito','IPVA e licenciamento','Restrições e bloqueios'].map((t) =>
            Padding(padding: const EdgeInsets.only(bottom:6), child: Row(children: [
              const Icon(Icons.check_circle_rounded, color:AppColors.green, size:16), const SizedBox(width:8),
              Text(t, style: const TextStyle(fontSize:13, color:AppColors.text)),
            ]))),
        ])),
    ]))));
}
