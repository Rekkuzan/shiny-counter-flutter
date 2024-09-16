import 'package:flutter/material.dart';
import 'package:shiny_hunt_tracker/data_loader.dart';
import 'package:shiny_hunt_tracker/models/hunt.dart';
import 'package:shiny_hunt_tracker/utils/hunt_save_utils.dart';
import 'hunt_creation_screen.dart';
import 'hunt_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HuntSaveUtils _huntSaveUtils = HuntSaveUtils();
  List<Hunt> _hunts = [];
  Future<bool>? _loaded;

  @override
  void initState() {
    super.initState();
    _loadHunts();
  }

  Future<void> _loadHunts() async {
    final savedHunts = await _huntSaveUtils.loadHunts();
    final loaded = _loadData();
    // Parse savedHunts into List<Hunt> if necessary
    setState(() {
      _hunts = savedHunts;
      _loaded = loaded;
    });
  }

  Future<bool> _loadData() async
  {
    // Load data asynchronously
    await DataLoader.loadPokemonData();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hunt Tracker')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _hunts.length,
        itemBuilder: (context, index) {
          final hunt = _hunts[index];
          final pokemon = DataLoader.pokemons![hunt.pokemonId]!;
          final game = DataLoader.games![hunt.gameId]!;
          
          return Card(
            child: ListTile(
              title: Text(pokemon.name.getValue("en")),
              subtitle: Text('${game.name.getValue("en")} - ${hunt.method}'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  HuntDetailScreen.routeName,
                  arguments: hunt,
                ).then((_) => _loadHunts());
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            HuntCreationScreen.routeName,
          ).then((_) => _loadHunts());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}