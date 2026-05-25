import 'package:flutter/material.dart';
import '../theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(title: const Text('INFORMAÇÕES'),
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context))),
    body: ListView(children: [
      _Item(icon:Icons.directions_car_rounded, color:AppColors.primary, bg:AppColors.blueL,
        nome:'Sobre o CuidaCar', sub:'Versão, missão e tecnologia',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder:(_) => const _InfoPage(page:'sobre')))),
      _Item(icon:Icons.menu_book_rounded, color:AppColors.orange, bg:AppColors.orangeL,
        nome:'Como usar o app', sub:'Guia passo a passo',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder:(_) => const _InfoPage(page:'como')))),
      _Item(icon:Icons.help_outline_rounded, color:AppColors.purple, bg:AppColors.purpleL,
        nome:'FAQ', sub:'Perguntas frequentes',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder:(_) => const _InfoPage(page:'faq')))),
      _Item(icon:Icons.lock_outline_rounded, color:AppColors.green, bg:AppColors.greenL,
        nome:'Política de Privacidade', sub:'Seus dados são seus',
        onTap: () => Navigator.push(context, MaterialPageRoute(builder:(_) => const _InfoPage(page:'privacidade')))),
    ]),
  );
}

class _Item extends StatelessWidget {
  final IconData icon; final Color color, bg; final String nome, sub; final VoidCallback onTap;
  const _Item({required this.icon, required this.color, required this.bg, required this.nome, required this.sub, required this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(width:42, height:42, decoration: BoxDecoration(color:bg, borderRadius:BorderRadius.circular(11)),
      child: Icon(icon, color:color, size:22)),
    title: Text(nome, style: const TextStyle(fontSize:14, fontWeight:FontWeight.w600, color:AppColors.text)),
    subtitle: Text(sub, style: const TextStyle(fontSize:11, color:AppColors.textMuted)),
    trailing: const Icon(Icons.chevron_right_rounded, color:AppColors.textMuted),
    onTap: onTap,
  );
}

class _InfoPage extends StatelessWidget {
  final String page;
  const _InfoPage({required this.page});

  @override
  Widget build(BuildContext context) {
    final titles = {'sobre':'SOBRE O CUIDACAR','como':'COMO USAR','faq':'FAQ','privacidade':'PRIVACIDADE'};
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(titles[page]??''),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: _buildContent(page)),
    );
  }

  Widget _buildContent(String page) {
    switch(page) {
      case 'sobre': return Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Center(child:Column(children:[
          Container(width:70,height:70,decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppColors.primary,AppColors.primaryL]),borderRadius:BorderRadius.circular(18)),child:const Icon(Icons.directions_car_rounded,color:Colors.white,size:36)),
          const SizedBox(height:12),
          const Text('CUIDACAR',style:TextStyle(fontFamily:'Orbitron',fontSize:18,color:AppColors.primary,letterSpacing:2,fontWeight:FontWeight.w700)),
          const Text('Versão 1.0.0',style:TextStyle(fontSize:12,color:AppColors.textMuted)),
        ])),
        const SizedBox(height:24),
        _sec('NOSSA MISSÃO','O CuidaCar nasceu para ajudar brasileiros a cuidar melhor dos seus veículos, evitando surpresas mecânicas e gastos desnecessários.'),
        _sec('TECNOLOGIA','• Diagnóstico por IA (Gemini)\n• Dados salvos no seu celular\n• Interface otimizada para uso diário'),
      ]);
      case 'como': return Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        ...[
          ['1','Cadastre seu veículo','Toque em + no rodapé, escolha a marca, modelo, ano e KM.'],
          ['2','Registre manutenções','Toque no card do veículo → + MANUTENÇÃO.'],
          ['3','Configure alertas','Em cada manutenção, configure a próxima revisão.'],
          ['4','Use a IA','Toque em IA no rodapé para diagnóstico de problemas.'],
          ['5','Compre peças','Acesse a Loja no rodapé para encontrar peças.'],
        ].map((s)=>Padding(padding:const EdgeInsets.only(bottom:16),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Container(width:28,height:28,margin:const EdgeInsets.only(top:2,right:12),
            decoration:BoxDecoration(color:AppColors.blueL,shape:BoxShape.circle,border:Border.all(color:AppColors.blueB)),
            child:Center(child:Text(s[0],style:const TextStyle(fontFamily:'Orbitron',fontSize:10,color:AppColors.primary,fontWeight:FontWeight.w700)))),
          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(s[1],style:const TextStyle(fontSize:14,fontWeight:FontWeight.w600,color:AppColors.text)),
            const SizedBox(height:3),
            Text(s[2],style:const TextStyle(fontSize:12,color:AppColors.textSec,height:1.5)),
          ])),
        ]))),
      ]);
      case 'faq': return Column(children:[
        ...[
          ['O app funciona sem internet?','Sim! Cadastro e manutenções funcionam offline. Apenas IA e Loja precisam de conexão.'],
          ['Meus dados somem se desinstalar?','Sim, os dados ficam no celular. Ao desinstalar são apagados.'],
          ['Posso ter mais de um veículo?','Sim, sem limite de veículos.'],
          ['Como funciona a IA?','Descreva o problema e a IA identifica causas e sugere peças.'],
          ['O app avisa da próxima manutenção?','Sim! Configure alertas em cada manutenção registrada.'],
        ].map((f)=>_FaqItem(q:f[0],a:f[1])),
      ]);
      case 'privacidade': return Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Container(padding:const EdgeInsets.all(16),margin:const EdgeInsets.only(bottom:16),
          decoration:BoxDecoration(color:AppColors.greenL,borderRadius:BorderRadius.circular(12),border:Border.all(color:AppColors.greenB)),
          child:Row(children:[const Text('🔒',style:TextStyle(fontSize:28)),const SizedBox(width:12),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              const Text('SEUS DADOS SÃO SEUS',style:TextStyle(fontFamily:'Orbitron',fontSize:10,color:AppColors.green,letterSpacing:1)),
              const SizedBox(height:4),
              const Text('Sem servidores. Tudo fica no seu celular.',style:TextStyle(fontSize:12,color:AppColors.textSec,height:1.5)),
            ]))])),
        _sec('ARMAZENAMENTO','Todos os dados ficam exclusivamente no seu dispositivo. Não coletamos nem transmitimos nada.'),
        _sec('PERMISSÕES','✅ Armazenamento local\n✅ Internet (apenas IA e Loja)\n❌ Câmera: não\n❌ Localização: não\n❌ Contatos: não'),
        _sec('CONTATO','contato@cuidacar.app'),
      ]);
      default: return const SizedBox();
    }
  }

  static Widget _sec(String t, String txt) => Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
    Text(t,style:const TextStyle(fontFamily:'Orbitron',fontSize:9,color:AppColors.primary,letterSpacing:2)),
    const SizedBox(height:6),Container(height:1,color:AppColors.blueB,margin:const EdgeInsets.only(bottom:10)),
    Text(txt,style:const TextStyle(fontSize:13,color:AppColors.textSec,height:1.7)),
    const SizedBox(height:20),
  ]);
}

class _FaqItem extends StatefulWidget {
  final String q, a;
  const _FaqItem({required this.q, required this.a});
  @override State<_FaqItem> createState() => _FaqItemState();
}
class _FaqItemState extends State<_FaqItem> {
  bool _open = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => _open = !_open),
    child: Container(margin:const EdgeInsets.only(bottom:8), padding:const EdgeInsets.all(14),
      decoration:BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(12), border:Border.all(color:AppColors.border)),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
        Row(children:[
          Expanded(child:Text(widget.q,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppColors.text))),
          Icon(_open?Icons.keyboard_arrow_up_rounded:Icons.keyboard_arrow_down_rounded,color:AppColors.textMuted),
        ]),
        if(_open)...[const SizedBox(height:8),Text(widget.a,style:const TextStyle(fontSize:12,color:AppColors.textSec,height:1.6))],
      ])));
}
