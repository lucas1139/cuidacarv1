import 'package:flutter/material.dart';
import 'models/vehicle.dart';

class AppColors {
  static const primary    = Color(0xFF2563EB);
  static const primaryL   = Color(0xFF3B82F6);
  static const primaryD   = Color(0xFF1E40AF);
  static const bg         = Color(0xFFF0F4FF);
  static const surface    = Color(0xFFFFFFFF);
  static const surfaceVar = Color(0xFFF8FAFC);
  static const border     = Color(0xFFE2E8F0);
  static const borderL    = Color(0xFFCBD5E1);
  static const text       = Color(0xFF1E293B);
  static const textSec    = Color(0xFF64748B);
  static const textMuted  = Color(0xFF94A3B8);
  static const green      = Color(0xFF16A34A);
  static const greenL     = Color(0xFFF0FDF4);
  static const greenB     = Color(0xFFBBF7D0);
  static const orange     = Color(0xFFD97706);
  static const orangeL    = Color(0xFFFFFBEB);
  static const orangeB    = Color(0xFFFDE68A);
  static const red        = Color(0xFFDC2626);
  static const redL       = Color(0xFFFEF2F2);
  static const redB       = Color(0xFFFECACA);
  static const purple     = Color(0xFF7C3AED);
  static const purpleL    = Color(0xFFEDE9FE);
  static const purpleB    = Color(0xFFDDD6FE);
  static const blueL      = Color(0xFFEFF6FF);
  static const blueB      = Color(0xFFBFDBFE);

  static Color sc(VehicleStatus s) => s==VehicleStatus.ok ? green : s==VehicleStatus.warn ? orange : red;
  static Color sl(VehicleStatus s) => s==VehicleStatus.ok ? greenL : s==VehicleStatus.warn ? orangeL : redL;
  static Color sb(VehicleStatus s) => s==VehicleStatus.ok ? greenB : s==VehicleStatus.warn ? orangeB : redB;
}

String fmtKm(int km) => km.toString().replaceAllMapped(
  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
String fmtDate(DateTime d) =>
  '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
String stLabel(VehicleStatus s) =>
  s==VehicleStatus.ok ? 'Em dia' : s==VehicleStatus.warn ? 'Atenção' : 'Urgente';

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Rajdhani',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary, brightness: Brightness.light),
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.text,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontFamily: 'Orbitron', fontSize: 14, fontWeight: FontWeight.w700,
        color: AppColors.text, letterSpacing: 1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, foregroundColor: Colors.white,
        elevation: 0, minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontFamily: 'Orbitron', fontSize: 10,
          fontWeight: FontWeight.w700, letterSpacing: 1.5),
      )),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: AppColors.surfaceVar,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      labelStyle: const TextStyle(color: AppColors.textMuted),
      hintStyle: const TextStyle(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
  );
}
