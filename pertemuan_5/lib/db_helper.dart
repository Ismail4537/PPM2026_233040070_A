import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart' show Catatan;

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const _storageKey = 'catatan_list';
  late SharedPreferences _prefs;
  int _nextId = 1;

  // Inisialisasi (hanya dipanggil sekali saat app start)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Load next ID dari data yang ada
    _loadNextId();
  }

  void _loadNextId() {
    final data = _getCatatanData();
    if (data.isNotEmpty) {
      _nextId =
          (data.map((c) => c['id'] as int).reduce((a, b) => a > b ? a : b)) + 1;
    }
  }

  List<Map<String, dynamic>> _getCatatanData() {
    final json = _prefs.getString(_storageKey) ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(json));
  }

  Future<void> _saveCatatanData(List<Map<String, dynamic>> data) async {
    await _prefs.setString(_storageKey, jsonEncode(data));
  }

  // ===== CRUD =====

  Future<int> insert(Catatan c) async {
    final data = _getCatatanData();
    final newCatatan = c.toMap();
    newCatatan['id'] = _nextId;
    data.add(newCatatan);
    await _saveCatatanData(data);
    _nextId++;
    return _nextId - 1;
  }

  Future<List<Catatan>> getAll() async {
    final data = _getCatatanData();
    // Sort by dibuat_pada descending
    data.sort(
      (a, b) => (b['dibuat_pada'] as int).compareTo(a['dibuat_pada'] as int),
    );
    return data
        .map((json) => Catatan.fromMap(json.cast<String, Object?>()))
        .toList();
  }

  Future<int> update(Catatan c) async {
    assert(c.id != null);
    final data = _getCatatanData();
    final index = data.indexWhere((item) => item['id'] == c.id);
    if (index != -1) {
      data[index] = c.toMap();
      await _saveCatatanData(data);
      return 1;
    }
    return 0;
  }

  Future<int> delete(int id) async {
    final data = _getCatatanData();
    final initialLength = data.length;
    data.removeWhere((item) => item['id'] == id);
    await _saveCatatanData(data);
    return initialLength - data.length;
  }
}
