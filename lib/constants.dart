class Constants {
  static const List<String> games = [
    'Pokémon Red/Blue',
    'Pokémon Gold/Silver',
    'Pokémon Ruby/Sapphire',
    'Pokémon Diamond/Pearl',
    // Add more games...
  ];

  static const Map<int, String> methods = {
    0 : 'Random Encounter',
    1 : 'Soft Reset',
    2 : 'Breeding',
    3 : 'PokeRadar',
    4 : 'Chain Fishing',
  };

  static const Map<String, List<String>> methodsByGame = {
    'Pokémon Red/Blue': ['Random Encounter', 'Soft Reset'],
    'Pokémon Gold/Silver': ['Random Encounter', 'Breeding'],
    'Pokémon Ruby/Sapphire': ['Random Encounter', 'Chain Fishing'],
    'Pokémon Diamond/Pearl': ['Random Encounter', 'PokeRadar'],
    // Add more methods for each game...
  };

  static const Map<String, Map<String, List<String>>> pokemonByGameAndMethod = {
    'Pokémon Red/Blue': {
      'Random Encounter': ['Pikachu', 'Charmander', 'Bulbasaur'],
      'Soft Reset': ['Mewtwo'],
    },
    'Pokémon Gold/Silver': {
      'Random Encounter': ['Totodile', 'Chikorita'],
      'Breeding': ['Pichu'],
    },
    // Add more Pokémon for each game and method...
  };
}