import 'dart:convert';
import 'package:http/http.dart' as http;

// Chave GRÁTIS em: aistudio.google.com
const _key = 'SUA_CHAVE_GEMINI_AQUI';

class GeminiService {
  static const _url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  static const _sys = 'Você é mecânico especialista em veículos brasileiro. '
    'Responda em português, forma clara e amigável. Ao descrever um problema: '
    '1) Causas prováveis; 2) Explicação breve; 3) Urgência; '
    '4) Peças com marcas brasileiras (Bosch,Cofap,Monroe,Nakata,NGK) e preço em reais. '
    'Máx 120 palavras. Sem markdown. '
    r'Se houver peças: PECAS_JSON:[{"nome":"...","marca":"...","preco":"R$ XX-XX"}]';

  static Future<AIResponse> send(List<Map<String,String>> history) async {
    try {
      final contents = [
        {'role':'user','parts':[{'text':_sys}]},
        {'role':'model','parts':[{'text':'Entendido! Como posso ajudar?'}]},
        ...history.map((m)=>{'role':m['role']=='user'?'user':'model','parts':[{'text':m['content']}]}),
      ];
      final res = await http.post(
        Uri.parse('$_url?key=$_key'),
        headers: {'Content-Type':'application/json'},
        body: jsonEncode({'contents':contents,'generationConfig':{'temperature':0.7,'maxOutputTokens':500}}),
      ).timeout(const Duration(seconds:30));
      if(res.statusCode==200) {
        final d = jsonDecode(res.body);
        final txt = d['candidates']?[0]?['content']?['parts']?[0]?['text']??'';
        return AIResponse.parse(txt);
      }
      return AIResponse.err('Erro na IA. Tente novamente.');
    } catch(_) { return AIResponse.err('Sem conexão com a internet.'); }
  }
}

class AIResponse {
  final String text; final List<Peca> pecas; final bool isError;
  AIResponse({required this.text, this.pecas=const[], this.isError=false});

  factory AIResponse.parse(String full) {
    String text=full; List<Peca> pecas=[];
    final m=RegExp(r'PECAS_JSON:(\[.*?\])').firstMatch(full);
    if(m!=null) {
      try{ pecas=(jsonDecode(m.group(1)!) as List)
        .map((p)=>Peca(p['nome']??'',p['marca']??'',p['preco']??'')).toList(); }catch(_){}
      text=full.replaceAll(RegExp(r'PECAS_JSON:\[.*?\]'),'').trim();
    }
    return AIResponse(text:text, pecas:pecas);
  }
  factory AIResponse.err(String msg) => AIResponse(text:msg, isError:true);
}

class Peca {
  final String nome, marca, preco;
  Peca(this.nome, this.marca, this.preco);
}
