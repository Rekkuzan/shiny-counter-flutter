class PokemonByGame
{
  final Map<int, List<int>> _data;

  PokemonByGame(this._data);

  List<int> getPokemons(int gameId)
  {
    return _data[gameId]!;
  }
}