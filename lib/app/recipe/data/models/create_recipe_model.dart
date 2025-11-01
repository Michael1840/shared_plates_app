import 'dart:io';

class CreateRecipeModel {
  final String title;
  final String description;
  final String serves;
  final List<String> tags;
  final String privacyStatus;
  final List<Map<String, dynamic>> ingredients;
  final List<Map<String, dynamic>> steps;
  final File image;

  const CreateRecipeModel({
    required this.title,
    required this.description,
    required this.serves,
    required this.tags,
    required this.privacyStatus,
    required this.ingredients,
    required this.steps,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'serves': serves,
      'tags': tags,
      'privacy_status': privacyStatus,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}
