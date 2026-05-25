import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

const _shopUrl = 'https://shopee.com.br'; // ← substitua pelo seu link de afiliado

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const _cats = [
    {'icon':'🛢️','nome':'Óleos','desc':'Motor, câmbio, freio','q':'óleo motor automotivo'},
    {'icon':'🔧','nome':'Filtros','desc':'Ar, óleo, combustível','q':'filtros automotivos'},
    {'icon':'🛞','nome':'Freios','desc':'Pastilhas, discos','q':'pastilha freio carro'},
    {'icon':'⚡','nome':'Elétrica','desc':'Baterias, velas','q':'bateria automotiva'},
    {'icon':'🔩','nome':'Suspensão','desc':'Amortecedores, buchas','q':'amortecedor carro'},
    {'icon':'✨','nome':'Acessórios','desc':'Tapetes, capas','q':'acessórios automotivos'},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(title: const Text('LOJA DE PEÇAS'),
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context))),
    body: SingleChildScrollView(padding: const EdgeInsets.all(14), child: Column(children: [
      Container(padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom:16),
        decoration: BoxDecoration(gradient: const LinearGradient(colors:[Color(0xFFFF6B00),Color(0xFFFF4500)], begin:Alignment.topLeft, end:Alignment.bottomRight), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Text('🛍️', style: TextStyle(fontSize:32)), const SizedBox(width:14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('SHOPEE', style: TextStyle(fontFamily:'Orbitron', fontSize:18, color:Colors.white, letterSpacing:2, fontWeight:FontWeight.w700)),
            Text('Peças e acessórios automotivos', style: TextStyle(fontSize:12, color:Colors.white70)),
          ])])),
      GridView.count(crossAxisCount:2, shrinkWrap:true, physics:const NeverScrollableScrollPhysics(),
        crossAxisSpacing:10, mainAxisSpacing:10, childAspectRatio:1.3,
        children: _cats.map((cat) => GestureDetector(
          onTap: () => _open(cat['q']!),
          child: Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(12), border:Border.all(color:const Color(0xFFFED7AA))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(cat['icon']!, style: const TextStyle(fontSize:24)), const SizedBox(height:6),
              Text(cat['nome']!, style: const TextStyle(fontSize:13, fontWeight:FontWeight.w600, color:AppColors.text)),
              Text(cat['desc']!, style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
            ])))).toList()),
      const SizedBox(height: 14),
      ElevatedButton(
        onPressed: () => _open(''),
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B00)),
        child: const Text('VER TODA A LOJA →')),
    ])));

  Future<void> _open(String q) async {
    final url = Uri.parse(q.isEmpty ? _shopUrl : '$_shopUrl/search?keyword=${Uri.encodeComponent(q)}');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
