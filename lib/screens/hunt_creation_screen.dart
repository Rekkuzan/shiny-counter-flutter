import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shiny_hunt_tracker/constants.dart';
import 'package:shiny_hunt_tracker/models/game.dart';
import 'package:shiny_hunt_tracker/models/hunt.dart';
import 'package:shiny_hunt_tracker/models/pokemon.dart';
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
  int _selectedGame = -1;
  String? _selectedMethod;
  int _selectedPokemon = -1;

  Future<bool>? _loaded;

  @override
  void initState() {
    super.initState();
    _selectedGame = widget.hunt?.gameId ?? -1;
    _selectedMethod = widget.hunt?.method;
    _selectedPokemon = widget.hunt?.pokemonId ?? -1;
    _loaded = _loadData();
  }

  void _saveHunt() async {
    final hunt = Hunt(
      pokemonId: _selectedPokemon ?? -1,
      gameId: _selectedGame ?? -1,
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
    await DataLoader.loadPokemonData();
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
            } else if (snapshot.hasError || DataLoader.games == null) {
              return const Center(child: Text('Error loading data'));
            } else {
              return Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (DataLoader.games != null)
                      DropdownSearch<Game>(
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Game",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        items: DataLoader.games!.values.toList(),
                        itemAsString: (item) => item.name.getValue("en"),// Use loaded data
                        selectedItem: _selectedGame >= 0 ? DataLoader.games![_selectedGame] : null,
                        onChanged: (value) {
                          setState(() {
                            _selectedGame = value == null ? -1 : value.id;
                            _selectedMethod = null; // Reset method when game changes
                            _selectedPokemon = -1; // Reset Pokémon when game changes
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a game';
                          }
                          return null;
                        },
                        popupProps: const PopupProps.menu(
                          showSearchBox: true, // Shows the search box in the dropdown
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_selectedGame >= 0)
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
                            _selectedPokemon = -1; // Reset Pokémon when method changes
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
                    if (_selectedGame >= 0
                        && _selectedMethod != null
                        && DataLoader.pokemons != null)
                      DropdownSearch<Pokemon>(
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Pokémon",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        items: DataLoader.pokemons!.values.toList(),
                        itemAsString: (pokemon) => (pokemon.name.getValue("en")),
                        dropdownBuilder: (context, selectedItem) {
                          if (selectedItem == null) {
                            return Container(
                              height: 50, // Adjust the height as needed
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/undefined.png",
                                    width: 50, // Set the width and height as needed
                                    height: 50,
                                    fit: BoxFit.cover, // Make the image cover the area
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Select a pokemon"),
                                ],
                              ),
                            );
                          }
                          return Container(
                            height: 50, // Adjust the height as needed
                            child: Row(
                              children: [
                                Image.network(
                                  selectedItem.sprite_shiny,
                                  width: 50, // Set the width and height as needed
                                  height: 50,
                                  fit: BoxFit.cover, // Make the image cover the area
                                ),
                                const SizedBox(width: 10),
                                Text(selectedItem.name.getValue("en")),
                              ],
                            ),
                          );
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedPokemon = value == null ? -1: value.id;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a Pokémon';
                          }
                          return null;
                        },
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0), // Adds padding around the entire box
                              child: SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes elements to opposite ends
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name.getValue("en"),
                                        overflow: TextOverflow.ellipsis, // Handle long text gracefully
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0), // Padding only on the left of the image
                                      child: Image.network(
                                        item.sprite_shiny,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover, // Fills the image from top to bottom
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                          },
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
