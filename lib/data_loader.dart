import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shiny_hunt_tracker/models/game.dart';
import 'package:shiny_hunt_tracker/models/localized_string.dart';
import 'package:shiny_hunt_tracker/models/pokemon.dart';

class DataLoader {

  static Map<String, dynamic>? _data;

  static List<String>? gamesAsString;
  static List<String>? pokemonAsString;

  static Map<int, Pokemon>? pokemons;
  static Map<int, Game>? games;



  static Future<Map<String, dynamic>> loadPokemonData() async {
    if (_data != null) {
      return _data!;
    }
    final String response = await rootBundle.loadString(
        'assets/data/data.json');
    _data = json.decode(response);

    var data = _data!;
    pokemons = getPokemons(data);
    games = getGames(data);

    print("Loaded pokemons: ${pokemons!.values.length}");
    print("Loaded games: ${games!.values.length}");

    return data;
  }
}

class LabelSpriteContainer {
  final String label;
  final String spriteUrl;

  LabelSpriteContainer({required this.label, required this.spriteUrl});
}

Map<int, Pokemon> getPokemons(Map<String, dynamic> data) {
  List<dynamic> pokemonList = data['pokemon'];
  Map<int, Pokemon> pokemonMap = {};

  List<Pokemon> pokemons = pokemonList.map<Pokemon>((pokemon) {
    final Map<String, String> localizedNames = {};
    // Iterate over each entry in the list
    for (var entry in pokemon['localized_names']) {
      // Extract the language and value
      final String language = entry['language'];
      final String value = entry['value'];

      // Add the language and value to the map
      localizedNames[language] = value;
    }

    return Pokemon(
        LocalizedString(localizedNames),
        pokemon["id"],
        pokemon['sprite'],
        pokemon['sprite_shiny'],
        pokemon['capture_rate'],
        pokemon['is_baby'],
        pokemon['is_legendary'],
        pokemon['is_mythical']
    );
  }).toList();

  for (var pokemon in pokemons) {
    pokemonMap[pokemon.id] = pokemon;
  }
  return pokemonMap;
}

Map<int, Game> getGames(Map<String, dynamic> data) {
  List<dynamic> gameList = data['games'];
  Map<int, Game> gameMap = {};

  List<Game> games = gameList.map<Game>((game) {
    final Map<String, String> localizedNames = {};
    // Iterate over each entry in the list
    for (var entry in game['localized_names']) {
      // Extract the language and value
      final String language = entry['language'];
      final String value = entry['value'];

      // Add the language and value to the map
      localizedNames[language] = value;
    }

    return Game(
        LocalizedString(localizedNames),
        game["id"]
    );
  }).toList();

  for (var game in games) {
    gameMap[game.id] = game;
  }
  return gameMap;
}