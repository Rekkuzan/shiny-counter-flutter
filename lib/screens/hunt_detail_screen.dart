import 'package:flutter/material.dart';
import 'package:shiny_hunt_tracker/data_loader.dart';
import 'package:shiny_hunt_tracker/models/hunt.dart';
import 'package:shiny_hunt_tracker/utils/hunt_save_utils.dart';

class HuntDetailScreen extends StatefulWidget {
  static const routeName = '/hunt-detail';
  final Hunt hunt;

  const HuntDetailScreen({super.key, required this.hunt});

  @override
  _HuntDetailScreenState createState() => _HuntDetailScreenState();
}

class _HuntDetailScreenState extends State<HuntDetailScreen> {
  late Hunt _hunt;
  final HuntSaveUtils _huntSaveUtils = HuntSaveUtils();
  Future<bool>? _loaded;

  @override
  void initState() {
    super.initState();
    _loaded = _loadData();
  }

  Future<bool> _loadData() async {
    // Load data asynchronously
    await DataLoader.loadPokemonData();
    _hunt = widget.hunt;

    return true;
  }

  Future<void> _incrementHuntCount() async {
    setState(() {
      _hunt = Hunt(
        pokemonId: _hunt.pokemonId,
        gameId: _hunt.gameId,
        method: _hunt.method,
        count: _hunt.count + 1,
      );
    });

    // Save updated hunt
    await _huntSaveUtils.updateHunt(_hunt);
  }

  Future<void> _completeHunt() async {
    // Logic for completing the hunt, e.g., marking it as complete
    setState(() {
      _hunt = Hunt(
        pokemonId: _hunt.pokemonId,
        gameId: _hunt.gameId,
        method: _hunt.method,
        count: _hunt.count,
        // Assuming you might add a 'completed' flag or similar property
        // For now, let's just keep the current count
      );
    });

    // Save updated hunt
    await _huntSaveUtils.updateHunt(_hunt);

    if (mounted) {
      // Navigate back to HomeScreen
      Navigator.pop(context);
    }
  }

  Future<void> _deleteHunt() async {
    await _huntSaveUtils.deleteHunt(_hunt);

    if (mounted) {
      // Navigate back to HomeScreen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Pokemon hunt detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<bool>(
            future: _loaded,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError ||
                  DataLoader.pokemons == null ||
                  DataLoader.games == null)
              {
                return const Text("An error occured");
              }

              final pokemon = DataLoader.pokemons![_hunt.pokemonId]!;
              final game = DataLoader.games![_hunt.gameId]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pokémon: ${pokemon.name.getValue("en")}',
                      style: textTheme.bodyMedium),
                  Center(child: Image.network(pokemon.sprite_shiny)),
                  Text('Game: ${game.name.getValue("en")}',
                      style: textTheme.titleMedium),
                  Text('Method: ${_hunt.method}', style: textTheme.titleMedium),
                  Text('Count: ${_hunt.count}', style: textTheme.titleMedium),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _incrementHuntCount,
                    child: const Text('Increment Count'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _completeHunt,
                    child: const Text('Complete Hunt'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _deleteHunt,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Background color
                      foregroundColor: Colors.white, // Text color
                    ),
                    child: const Text('Delete Hunt'),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
