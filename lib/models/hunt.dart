// lib/models/hunt.dart
class Hunt {
  final int pokemonId;
  final int gameId;
  final String method;
  final int count; // Number of attempts or encounters

  Hunt({
    required this.pokemonId,
    required this.gameId,
    required this.method,
    this.count = 0,
  });

  // Convert Hunt to and from Map for persistence
  Map<String, dynamic> toMap() {
    return {
      'pokemon': pokemonId,
      'game': gameId,
      'method': method,
      'count': count,
    };
  }

  factory Hunt.fromMap(Map<String, dynamic> map) {
    return Hunt(
      pokemonId: map['pokemon'],
      gameId: map['game'],
      method: map['method'],
      count: map['count'],
    );
  }
}
