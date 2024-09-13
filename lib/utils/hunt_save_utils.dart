// lib/utils/hunt_save_utils.dart
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiny_hunt_tracker/models/hunt.dart';

class HuntSaveUtils {

  final List<Hunt> _dummyHunts = [
    Hunt(pokemon: 'Pikachu', game: 'Pokemon Go', method: 'Random Encounters'),
    Hunt(pokemon: 'Charmander', game: 'Pokemon Sword', method: 'Masuda Method'),
  ];

  Future<void> _saveHunts(List<Hunt> hunts) async {
    final prefs = await SharedPreferences.getInstance();
    final huntMaps = hunts.map((hunt) => hunt.toMap()).toList();
    final jsonString = jsonEncode(huntMaps);
    await prefs.setString('hunts_key', jsonString);
  }

  Future<List<Hunt>> _loadHunts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('hunts_key');
    if (jsonString == null) {
      return _dummyHunts;
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Hunt.fromMap(json)).toList();
  }

  Future<void> updateHunt(Hunt updatedHunt) async {
    List<Hunt> hunts = await _loadHunts();
    int index = hunts.indexWhere((hunt) => hunt.pokemon == updatedHunt.pokemon);
    if (index != -1) {
      hunts[index] = updatedHunt;
      await _saveHunts(hunts);
    }
  }

  Future<void> deleteHunt(Hunt hunt) async {
    List<Hunt> hunts = await _loadHunts();
    hunts.removeWhere((h) => h.pokemon == hunt.pokemon);
    await _saveHunts(hunts);
  }

  Future<void> addHunt(Hunt hunt) async {
    List<Hunt> hunts = await _loadHunts();
    hunts.add(hunt);
    await _saveHunts(hunts);
  }

  Future<List<Hunt>> loadHunts() async {
    return await _loadHunts();
  }
}