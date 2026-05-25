import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final List<Map<String,dynamic>> _msgs = [];
  final List<Map<String,String>> _history = [];
  bool _loading = false;
  final _quick = ['Barulho no motor','Freio falhando','Luz no painel','Superaquecendo','Vibração ao frear','Troca de óleo'];

  @override void initState() {
    super.initState();
    _msgs.add({'role':'ai','text':'Olá! Descreva o problema do seu carro e identifico as causas e peças. 🔧'});
  }
  @override void dispose() { _ctrl.dispose(); _scroll.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.bg,
    appBar: AppBar(
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context)),
      title: Row(children: [
        Container(width:32, height:32, decoration: BoxDecoration(color:AppColors.purpleL, borderRadius:BorderRadius.circular(9), border:Border.all(color:AppColors.purpleB)),
          child: const Icon(Icons.psychology_outlined, color:AppColors.purple, size:18)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('DIAGNÓSTICO IA', style: TextStyle(fontFamily:'Orbitron', fontSize:12, letterSpacing:1, color:AppColors.text)),
          Text('Especialista em veículos', style: TextStyle(fontSize:10, color:AppColors.textMuted)),
        ]),
      ]),
      actions: [
        Container(margin: const EdgeInsets.only(right:12), padding: const EdgeInsets.symmetric(horizontal:10, vertical:5),
          decoration: BoxDecoration(color:AppColors.purpleL, borderRadius:BorderRadius.circular(20), border:Border.all(color:AppColors.purpleB)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width:5, height:5, decoration: const BoxDecoration(color:AppColors.purple, shape:BoxShape.circle)),
            const SizedBox(width: 5),
            const Text('ONLINE', style: TextStyle(fontFamily:'Orbitron', fontSize:7, color:AppColors.purple)),
          ])),
      ]),
    body: Column(children: [
      SizedBox(height:44, child: ListView.builder(scrollDirection:Axis.horizontal, padding:const EdgeInsets.symmetric(horizontal:12, vertical:7),
        itemCount: _quick.length,
        itemBuilder: (_, i) => GestureDetector(onTap: () => _send(_quick[i]),
          child: Container(margin: const EdgeInsets.only(right:7), padding: const EdgeInsets.symmetric(horizontal:12, vertical:5),
            decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(18), border:Border.all(color:AppColors.blueB)),
            child: Text(_quick[i], style: const TextStyle(fontSize:11, color:AppColors.textSec)))))),
      Expanded(child: ListView.builder(controller: _scroll, padding: const EdgeInsets.all(12), itemCount: _msgs.length,
        itemBuilder: (_, i) {
          final m = _msgs[i]; final isMe = m['role']=='user';
          return Padding(padding: const EdgeInsets.only(bottom:10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start, children: [
              if (!isMe) Container(width:26, height:26, margin: const EdgeInsets.only(right:7),
                decoration: BoxDecoration(color:AppColors.purpleL, shape:BoxShape.circle, border:Border.all(color:AppColors.purpleB)),
                child: const Icon(Icons.psychology_outlined, color:AppColors.purple, size:14)),
              Flexible(child: Container(padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: isMe ? AppColors.blueL : AppColors.surface,
                  borderRadius: BorderRadius.only(topLeft:const Radius.circular(14), topRight:const Radius.circular(14),
                    bottomLeft:Radius.circular(isMe?14:3), bottomRight:Radius.circular(isMe?3:14)),
                  border: Border.all(color: isMe ? AppColors.blueB : AppColors.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m['text'], style: const TextStyle(fontSize:13, color:AppColors.text, height:1.5)),
                  if (m['pecas'] != null && (m['pecas'] as List).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color:AppColors.purpleL, borderRadius:BorderRadius.circular(10), border:Border.all(color:AppColors.purpleB)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('PEÇAS SUGERIDAS', style: TextStyle(fontFamily:'Orbitron', fontSize:8, color:AppColors.purple, letterSpacing:1)),
                        const SizedBox(height: 6),
                        ...(m['pecas'] as List<Peca>).map((p) => Padding(padding: const EdgeInsets.only(bottom:4),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(p.nome, style: const TextStyle(fontSize:11, color:AppColors.text, fontWeight:FontWeight.w600)),
                              Text(p.marca, style: const TextStyle(fontSize:10, color:AppColors.textMuted)),
                            ]),
                            Text(p.preco, style: const TextStyle(fontSize:11, color:AppColors.green, fontWeight:FontWeight.w700)),
                          ]))),
                      ])),
                  ],
                ]))),
              if (isMe) Container(width:26, height:26, margin: const EdgeInsets.only(left:7),
                decoration: BoxDecoration(color:AppColors.blueL, shape:BoxShape.circle, border:Border.all(color:AppColors.blueB)),
                child: const Icon(Icons.person_rounded, color:AppColors.primary, size:14)),
            ]));
        })),
      if (_loading) const LinearProgressIndicator(color: AppColors.purple),
      Container(padding: const EdgeInsets.fromLTRB(12,8,12,12),
        decoration: const BoxDecoration(color:AppColors.surface, border:Border(top:BorderSide(color:AppColors.border))),
        child: Row(children: [
          Expanded(child: TextField(controller: _ctrl, maxLines: null,
            onSubmitted: _send,
            decoration: InputDecoration(hintText:'Descreva o problema...',
              border: OutlineInputBorder(borderRadius:BorderRadius.circular(20), borderSide:const BorderSide(color:AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(20), borderSide:const BorderSide(color:AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(20), borderSide:const BorderSide(color:AppColors.primary, width:1.5)),
              contentPadding: const EdgeInsets.symmetric(horizontal:14, vertical:10),
              filled: true, fillColor: AppColors.surfaceVar))),
          const SizedBox(width: 8),
          GestureDetector(onTap: () => _send(_ctrl.text),
            child: Container(width:40, height:40, decoration: BoxDecoration(color:AppColors.purple, shape:BoxShape.circle),
              child: const Icon(Icons.send_rounded, color:Colors.white, size:18))),
        ])),
    ]));

  Future<void> _send(String text) async {
    if (text.trim().isEmpty || _loading) return;
    _ctrl.clear();
    setState(() { _msgs.add({'role':'user','text':text.trim()}); _loading = true; });
    _history.add({'role':'user','content':text.trim()});
    _scrollDown();
    final res = await GeminiService.send(_history);
    setState(() { _msgs.add({'role':'ai','text':res.text,'pecas':res.pecas}); _loading = false; });
    _history.add({'role':'model','content':res.text});
    _scrollDown();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds:300), curve: Curves.easeOut);
    });
  }
}
