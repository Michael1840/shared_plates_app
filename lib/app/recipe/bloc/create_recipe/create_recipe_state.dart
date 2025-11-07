// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_recipe_cubit.dart';

class CreateRecipeState extends Equatable {
  final DelayedResult<void> loadingResult;

  final List<IngredientModel> ingredients;
  final List<StepModel> steps;
  final List<String> tags;
  final String? title;
  final String? description;

  final List<String> category;
  final List<String> diet;
  final List<String> cuisine;

  final CustomDropdownValue? selectedQuantitySymbol;

  final CustomDropdownValue? selectedPrivacyStatus;

  final int serves;

  final File? imageFile;

  bool get isLoading => loadingResult.isInProgress;
  bool get isError => loadingResult.isError;

  const CreateRecipeState({
    required this.loadingResult,
    required this.ingredients,
    required this.steps,
    required this.serves,
    required this.tags,
    this.title,
    this.description,
    required this.category,
    required this.diet,
    required this.cuisine,
    this.selectedQuantitySymbol,
    this.selectedPrivacyStatus,
    this.imageFile,
  });

  factory CreateRecipeState.initial() {
    return const CreateRecipeState(
      ingredients: [],
      steps: [],
      tags: [],
      serves: 1,
      loadingResult: DelayedResult.idle(),
      category: [],
      diet: [],
      cuisine: [],
    );
  }

  @override
  List<Object?> get props => [
    ingredients,
    steps,
    imageFile,
    serves,
    tags,
    title,
    description,
    category,
    diet,
    cuisine,
    selectedQuantitySymbol,
    selectedPrivacyStatus,
    loadingResult,
  ];

  CreateRecipeState copyWith({
    DelayedResult<void>? loadingResult,
    List<IngredientModel>? ingredients,
    List<StepModel>? steps,
    List<String>? tags,
    String? title,
    String? description,
    List<String>? category,
    List<String>? diet,
    List<String>? cuisine,
    CustomDropdownValue? selectedQuantitySymbol,
    CustomDropdownValue? selectedPrivacyStatus,
    int? serves,
    File? imageFile,
  }) {
    return CreateRecipeState(
      loadingResult: loadingResult ?? this.loadingResult,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      tags: tags ?? this.tags,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      diet: diet ?? this.diet,
      cuisine: cuisine ?? this.cuisine,
      selectedQuantitySymbol:
          selectedQuantitySymbol ?? this.selectedQuantitySymbol,
      selectedPrivacyStatus:
          selectedPrivacyStatus ?? this.selectedPrivacyStatus,
      serves: serves ?? this.serves,
      imageFile: imageFile ?? this.imageFile,
    );
  }

  bool get canCreate {
    return ingredients.isNotEmpty &&
        steps.isNotEmpty &&
        category.isNotEmpty &&
        diet.isNotEmpty &&
        cuisine.isNotEmpty &&
        selectedPrivacyStatus != null &&
        !title.isNull &&
        !description.isNull;
  }
}
