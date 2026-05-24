import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/vehicle.dart';
import 'storage_service.dart';

class VehicleProvider extends ChangeNotifier {
  List<Vehicle> _v = [];
  bool loading = true;
  final _uuid = const Uuid();

  List<Vehicle> get vehicles => _v;
  List<Vehicle> get sorted => [..._v]..sort((a,b) {
    const o = {VehicleStatus.crit:0, VehicleStatus.warn:1, VehicleStatus.ok:2};
    return (o[a.status]??2).compareTo(o[b.status]??2);
  });

  int get totCrit => _v.where((v) => v.status==VehicleStatus.crit).length;
  Vehicle? byId(String id) { try{return _v.firstWhere((v)=>v.id==id);}catch(_){return null;} }
  String newMId() => _uuid.v4();

  Future<void> load() async {
    _v = await StorageService.load();
    loading = false;
    notifyListeners();
  }
  Future<void> _save() async { await StorageService.save(_v); }

  Future<void> add(String marca, String modelo, int ano, int km) async {
    _v.add(Vehicle(id:_uuid.v4(), marca:marca, modelo:modelo, ano:ano, km:km));
    await _save(); notifyListeners();
  }
  Future<void> edit(String id, {String? marca, String? modelo, int? ano, int? km}) async {
    final v=byId(id); if(v==null) return;
    if(marca!=null) v.marca=marca; if(modelo!=null) v.modelo=modelo;
    if(ano!=null) v.ano=ano; if(km!=null) v.km=km;
    await _save(); notifyListeners();
  }
  Future<void> delete(String id) async {
    _v.removeWhere((v)=>v.id==id); await _save(); notifyListeners();
  }
  Future<void> addMaint(String vid, Maintenance m) async {
    final v=byId(vid); if(v==null) return;
    v.manutencoes=[...v.manutencoes,m]; await _save(); notifyListeners();
  }
  Future<void> editMaint(String vid, Maintenance m) async {
    final v=byId(vid); if(v==null) return;
    v.manutencoes=v.manutencoes.map((x)=>x.id==m.id?m:x).toList();
    await _save(); notifyListeners();
  }
  Future<void> deleteMaint(String vid, String mid) async {
    final v=byId(vid); if(v==null) return;
    v.manutencoes=v.manutencoes.where((x)=>x.id!=mid).toList();
    await _save(); notifyListeners();
  }
}
