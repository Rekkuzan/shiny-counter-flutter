import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shiny_hunt_tracker/constants.dart';
import 'package:shiny_hunt_tracker/models/hunt.dart';
import 'package:shiny_hunt_tracker/utils/hunt_save_utils.dart';
import 'package:shiny_hunt_tracker/data_loader.dart';

class HuntCreationScreen extends StatefulWidget {
  static const routeName = '/hunt-creation';
  final Hunt? hunt;

  const HuntCreationScreen({super.key, this.hunt});

  @override
  _HuntCreationScreenState createState() => _HuntCreationScreenState();
}

class _HuntCreationScreenState extends State<HuntCreationScreen> {
  String? _selectedGame;
  String? _selectedMethod;
  String? _selectedPokemon;

  Future<bool>? _loaded;
  Map<String, dynamic>? _data;
  List<String>? _gamesAsString;
  List<String>? _pokemonAsString;
  List<PokemonNameSprite>? _pokemons;

  @override
  void initState() {
    super.initState();
    _selectedGame = widget.hunt?.game;
    _selectedMethod = widget.hunt?.method;
    _selectedPokemon = widget.hunt?.pokemon;
    _loaded = _loadData();
  }

  void _saveHunt() async {
    final hunt = Hunt(
      pokemon: _selectedPokemon ?? '',
      game: _selectedGame ?? '',
      method: _selectedMethod ?? '',
      count: widget.hunt?.count ?? 0,
    );

    final HuntSaveUtils huntSaveUtils = HuntSaveUtils();

    if (widget.hunt != null) {
      // If editing an existing hunt
      await huntSaveUtils.updateHunt(hunt);
    } else {
      // If adding a new hunt
      await huntSaveUtils.addHunt(hunt);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<bool> _loadData() async
  {
    // Load data asynchronously
    _data = await DataLoader.loadPokemonData();
    var data = _data!;
    _gamesAsString = getGameNamesInLanguage(data, "en");
    _pokemonAsString = getPokemonNamesInLanguage(data, "en");
    _pokemons = getPokemonNamesInLanguageAndSprite(data, "en");

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.hunt == null ? 'New Hunt' : 'Edit Hunt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<bool>(
          future: _loaded,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else {
              return Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_gamesAsString != null)
                      DropdownSearch<String>(
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Game",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        items: _gamesAsString!, // Use loaded data
                        selectedItem: _selectedGame,
                        onChanged: (value) {
                          setState(() {
                            _selectedGame = value;
                            _selectedMethod = null; // Reset method when game changes
                            _selectedPokemon = null; // Reset Pokémon when game changes
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a game';
                          }
                          return null;
                        },
                        popupProps: const PopupProps.menu(
                          showSearchBox: true, // Shows the search box in the dropdown
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_selectedGame != null)
                      DropdownSearch<String>(
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Method",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        items: Constants.methods.values.toList(),
                        selectedItem: _selectedMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedMethod = value;
                            _selectedPokemon = null; // Reset Pokémon when method changes
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a method';
                          }
                          return null;
                        },
                        popupProps: const PopupProps.menu(
                          showSearchBox: true, // Shows the search box in the dropdown
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_selectedGame != null
                        && _selectedMethod != null
                        && _pokemonAsString != null
                        && _pokemons != null)
                      DropdownSearch<PokemonNameSprite>(
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Pokémon",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        items: _pokemons!,
                        itemAsString: (pokemon) => (pokemon.label),
                        dropdownBuilder: (context, selectedItem) {
                          if (selectedItem == null) {
                            return const Text("Null");
                          }
                          return ListTile(
                            leading: Image.network(selectedItem.spriteUrl),
                            title: Text(selectedItem.label),
                          );
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedPokemon = value?.label;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a Pokémon';
                          }
                          return null;
                        },
                        popupProps: const PopupProps.menu(
                          showSearchBox: true, // Shows the search box in the dropdown
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveHunt,
                      child: const Text('Save Hunt'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
