enum AvoidOption {
  pork(['pork', 'bacon', 'ham', 'gammon', 'chorizo']),
  nuts(['nut', 'peanut', 'almond', 'cashew', 'pecan', 'walnut']),
  dairy(['milk', 'cheese', 'butter', 'cream', 'yoghurt', 'yogurt']),
  gluten(['flour', 'bread', 'pasta', 'noodle', 'wheat', 'couscous']),
  seafood(['fish', 'prawn', 'shrimp', 'hake', 'tuna', 'calamari', 'snoek']),
  beef(['beef', 'mince', 'steak', 'boerewors', 'oxtail']);

  const AvoidOption(this.keywords);

  final List<String> keywords;

  String get label => '${name[0].toUpperCase()}${name.substring(1)}';

  bool matches(String name, List<String> aliases) {
    final haystack = [name, ...aliases].join(' ').toLowerCase();
    return keywords.any(haystack.contains);
  }
}
