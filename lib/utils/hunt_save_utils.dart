// lib/utils/hunt_save_utils.dart
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shiny_hunt_tracker/models/hunt.dart';

class HuntSaveUtils {

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
      return List<Hunt>.empty();
    }
    final List<dynamic> jsonList = jsonDecode(jsonString);
    var listHunts = jsonList.map((json) => Hunt.fromMap(json)).toList(growable: true);
    listHunts.removeWhere((hunt) => hunt.gameId < 0 || hunt.pokemonId < 0);

    return listHunts;
  }

  Future<void> updateHunt(Hunt updatedHunt) async {
    List<Hunt> hunts = await _loadHunts();
    int index = hunts.indexWhere((hunt) => hunt.pokemonId == updatedHunt.pokemonId);
    if (index != -1) {
      hunts[index] = updatedHunt;
      await _saveHunts(hunts);
    }
  }

  Future<void> deleteHunt(Hunt hunt) async {
    List<Hunt> hunts = await _loadHunts();
    hunts.removeWhere((h) => h.pokemonId == hunt.pokemonId);
    await _saveHunts(hunts);
  }

  Future<void> addHunt(Hunt hunt) async {
    List<Hunt> hunts = await _loadHunts();

    List<Hunt> newHunts = List.empty(growable: true);
    newHunts.addAll(hunts);
    newHunts.add(hunt);

    await _saveHunts(newHunts);
  }

  Future<List<Hunt>> loadHunts() async {
    return await _loadHunts();
  }
}