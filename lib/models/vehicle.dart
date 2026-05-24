class Maintenance {
  final String id, tipo, obs, oficina, pecas;
  final DateTime data;
  final int kmNa;
  final double? custo;
  final int? alertaKm;
  final DateTime? alertaData;

  Maintenance({
    required this.id, required this.tipo, required this.data, required this.kmNa,
    this.custo, this.obs='', this.oficina='', this.pecas='',
    this.alertaKm, this.alertaData,
  });

  factory Maintenance.fromJson(Map<String,dynamic> j) => Maintenance(
    id: j['id']??'', tipo: j['tipo']??'',
    data: DateTime.tryParse(j['data']??'')??DateTime.now(),
    kmNa: j['kmNa']??0, custo: j['custo']?.toDouble(),
    obs: j['obs']??'', oficina: j['oficina']??'', pecas: j['pecas']??'',
    alertaKm: j['alertaKm'],
    alertaData: j['alertaData']!=null ? DateTime.tryParse(j['alertaData']) : null,
  );

  Map<String,dynamic> toJson() => {
    'id':id,'tipo':tipo,'data':data.toIso8601String(),'kmNa':kmNa,
    'custo':custo,'obs':obs,'oficina':oficina,'pecas':pecas,
    'alertaKm':alertaKm,'alertaData':alertaData?.toIso8601String(),
  };

  Maintenance copyWith({String? tipo, DateTime? data, int? kmNa, double? custo,
    String? obs, String? oficina, String? pecas, int? alertaKm, DateTime? alertaData}) =>
    Maintenance(id:id, tipo:tipo??this.tipo, data:data??this.data, kmNa:kmNa??this.kmNa,
      custo:custo??this.custo, obs:obs??this.obs, oficina:oficina??this.oficina,
      pecas:pecas??this.pecas, alertaKm:alertaKm??this.alertaKm, alertaData:alertaData??this.alertaData);
}

enum VehicleStatus { ok, warn, crit }

class Vehicle {
  final String id;
  String marca, modelo;
  int ano, km;
  List<Maintenance> manutencoes;

  Vehicle({required this.id, required this.marca, required this.modelo,
    required this.ano, required this.km, this.manutencoes=const[]});

  factory Vehicle.fromJson(Map<String,dynamic> j) => Vehicle(
    id: j['id']??'', marca: j['marca']??'', modelo: j['modelo']??'',
    ano: j['ano']??2024, km: j['km']??0,
    manutencoes: (j['manutencoes'] as List<dynamic>? ?? [])
      .map((m) => Maintenance.fromJson(m)).toList(),
  );

  Map<String,dynamic> toJson() => {
    'id':id,'marca':marca,'modelo':modelo,'ano':ano,'km':km,
    'manutencoes':manutencoes.map((m)=>m.toJson()).toList(),
  };

  Maintenance? get ultima => manutencoes.isEmpty ? null :
    manutencoes.reduce((a,b) => a.data.isAfter(b.data) ? a : b);
  int get kmDesde { final u=ultima; return u==null ? km : km-u.kmNa; }
  int get kmProx  { final u=ultima; return u==null ? 5000 : u.kmNa+5000; }
  double get progresso => (kmDesde/5000).clamp(0.0,1.0);
  VehicleStatus get status {
    final k=kmDesde;
    if(k<3000) return VehicleStatus.ok;
    if(k<6000) return VehicleStatus.warn;
    return VehicleStatus.crit;
  }
}
