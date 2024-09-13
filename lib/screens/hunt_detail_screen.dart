import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _hunt = widget.hunt;
  }

  Future<void> _incrementHuntCount() async {
    setState(() {
      _hunt = Hunt(
        pokemon: _hunt.pokemon,
        game: _hunt.game,
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
        pokemon: _hunt.pokemon,
        game: _hunt.game,
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
      appBar: AppBar(title: Text(_hunt.pokemon)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pokémon: ${_hunt.pokemon}', style: textTheme.bodyMedium),
            Text('Game: ${_hunt.game}', style: textTheme.titleMedium),
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
        ),
      ),
    );
  }
}
