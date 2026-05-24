import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehicle.dart';

class StorageService {
  static const _key = 'cuidacar_v1';

  static Future<List<Vehicle>> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_key);
      if (raw == null) return [];
      return (jsonDecode(raw) as List).map((j) => Vehicle.fromJson(j)).toList();
    } catch(_) { return []; }
  }

  static Future<void> save(List<Vehicle> v) async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_key, jsonEncode(v.map((x) => x.toJson()).toList()));
    } catch(_) {}
  }
}
