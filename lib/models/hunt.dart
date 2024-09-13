// lib/models/hunt.dart
class Hunt {
  final String pokemon;
  final String game;
  final String method;
  final int count; // Number of attempts or encounters

  Hunt({
    required this.pokemon,
    required this.game,
    required this.method,
    this.count = 0,
  });

  // Convert Hunt to and from Map for persistence
  Map<String, dynamic> toMap() {
    return {
      'pokemon': pokemon,
      'game': game,
      'method': method,
      'count': count,
    };
  }

  factory Hunt.fromMap(Map<String, dynamic> map) {
    return Hunt(
      pokemon: map['pokemon'],
      game: map['game'],
      method: map['method'],
      count: map['count'],
    );
  }
}
