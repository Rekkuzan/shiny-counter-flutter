import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class DataLoader {
  static Future<Map<String, dynamic>> loadPokemonData() async {
    final String response = await rootBundle.loadString('assets/data/data.json');
    return json.decode(response);
  }
}


class PokemonNameSprite {
  final String label;
  final String spriteUrl;

  PokemonNameSprite({required this.label, required this.spriteUrl});
}

List<String> getGameNamesInLanguage(Map<String, dynamic> data, String languageCode) {
  List<dynamic> gameList = data['games'];
  List<String> gameNames = gameList.map<String>((game) {
    return "Pokémon " + (game['names'] as List<dynamic>).firstWhere(
          (name) => name['language'] == languageCode,
      orElse: () => {'value': 'Unknown'},
    )["value"];
  }).toList();

  return gameNames;
}

List<String> getPokemonNamesInLanguage(Map<String, dynamic> data, String languageCode) {
  List<dynamic> pokemonList = data['pokemon'];
  List<String> names = pokemonList.map<String>((pokemon) {
    return (pokemon['localized_names'] as List<dynamic>).firstWhere(
          (name) => name['language'] == languageCode,
      orElse: () => {'value': 'Unknown'},
    )['value'] as String;
  }).toList();

  return names;
}

List<PokemonNameSprite> getPokemonNamesInLanguageAndSprite(Map<String, dynamic> data, String languageCode) {
  List<dynamic> pokemonList = data['pokemon'];
  List<PokemonNameSprite> pokemons = pokemonList.map<PokemonNameSprite>((pokemon) {
    return PokemonNameSprite (
        label: (pokemon['localized_names'] as List<dynamic>).firstWhere(
          (name) => name['language'] == languageCode,
      orElse: () => {'value': 'Unknown'},
    )['value'] as String,
       spriteUrl:  pokemon['sprite']);
  }).toList();

  return pokemons;
}