import 'package:shared_plates_app/core/widgets/sp_icon.dart';

abstract final class TasteIcons {
  static const Map<String, SpIcons> _bySlug = {
    'weeknight': SpIcons.bolt,
    'curry': SpIcons.bowl,
    'cape-malay': SpIcons.bowl,
    'stew': SpIcons.bowl,
    'soup': SpIcons.bowl,
    'one-pot': SpIcons.bowl,
    'braai': SpIcons.flame,
    'sunday-lunch': SpIcons.flame,
    'baking': SpIcons.cake,
    'dessert': SpIcons.icecream,
    'veggie': SpIcons.leaf,
    'vegan': SpIcons.leaf,
    'salad': SpIcons.leaf,
    'pasta': SpIcons.pasta,
    'breakfast': SpIcons.egg,
    'freezer-friendly': SpIcons.box,
  };

  static SpIcons forSlug(String slug) => _bySlug[slug] ?? SpIcons.heart;
}
