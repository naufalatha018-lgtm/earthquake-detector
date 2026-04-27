import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  String get languageName => _locale.languageCode == 'id' ? 'Indonesia' : 'English';
  String get themeName {
    if (_themeMode == ThemeMode.light) return 'Light';
    if (_themeMode == ThemeMode.dark) return 'Dark';
    return 'System';
  }

  void setThemeMode(String mode) {
    switch (mode) {
      case 'Light':
        _themeMode = ThemeMode.light;
        break;
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }

  void setLanguage(String lang) {
    if (lang == 'Indonesia') {
      _locale = const Locale('id');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }

  // Simple localization helper
  String getString(String key) {
    final isId = _locale.languageCode == 'id';
    final map = {
      'dashboard': isId ? 'Dashboard' : 'Dashboard',
      'logs': isId ? 'Log' : 'Logs',
      'settings': isId ? 'Pengaturan' : 'Settings',
      'earthquake_monitor': isId ? 'Monitor Gempa' : 'Earthquake Monitor',
      'live_seismic': isId ? 'Aktivitas Seismik Langsung' : 'Live Seismic Activity',
      'waiting_data': isId ? 'Menunggu data...' : 'Waiting for data...',
      'mag_chart': isId ? 'GRAFIK MAGNITUDE' : 'MAGNITUDE CHART',
      'date': isId ? 'Tanggal' : 'Date',
      'time': isId ? 'Jam' : 'Time',
      'magnitude': isId ? 'Magnitudo' : 'Magnitude',
      'depth': isId ? 'Kedalaman' : 'Depth',
      'login': isId ? 'Masuk' : 'Login',
      'no_account': isId ? 'Belum punya akun? Daftar' : "Don't have an account? Register",
      'system_prefs': isId ? 'Preferensi Sistem' : 'System Preferences',
      'theme': isId ? 'Tema' : 'Theme',
      'language': isId ? 'Bahasa' : 'Language',
      'account_access': isId ? 'Akun & Akses' : 'Account & Access',
      'hardware_diag': isId ? 'Hardware & Diagnostik' : 'Hardware & Diagnostics',
      'alert_params': isId ? 'Parameter Peringatan' : 'Alert Parameters',
      'emergency_proto': isId ? 'Protokol Darurat' : 'Emergency Protocol',
      'save_changes': isId ? 'Simpan Perubahan' : 'Save Changes',
      'profile': isId ? 'Profil' : 'Profile',
      'name': isId ? 'Nama' : 'Name',
      'new_password': isId ? 'Kata Sandi Baru' : 'New Password',
      'family_access': isId ? 'Akses Keluarga' : 'Family Access',
    };
    return map[key] ?? key;
  }
}
