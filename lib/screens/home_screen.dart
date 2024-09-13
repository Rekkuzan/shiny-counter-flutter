import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadHunts();
  }

  Future<void> _loadHunts() async {
    final savedHunts = await _huntSaveUtils.loadHunts();
    // Parse savedHunts into List<Hunt> if necessary
    setState(() {
      _hunts = savedHunts; // Populate with parsed data
    });
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
          return Card(
            child: ListTile(
              title: Text(hunt.pokemon),
              subtitle: Text('${hunt.game} - ${hunt.method}'),
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