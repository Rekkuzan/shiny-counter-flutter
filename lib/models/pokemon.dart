import 'package:shiny_hunt_tracker/models/localized_string.dart';

class Pokemon
{
  final int id;
  final String sprite;
  final String sprite_shiny;
  final int capture_rate;
  final bool is_baby;
  final bool is_legendary;
  final bool is_mythical;
  final LocalizedString name;

  Pokemon(this.name, this.id, this.sprite, this.sprite_shiny, this.capture_rate, this.is_baby, this.is_legendary, this.is_mythical);
}