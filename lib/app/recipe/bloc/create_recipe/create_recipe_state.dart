// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_recipe_cubit.dart';

class CreateRecipeState extends Equatable {
  final DelayedResult<void> loadingResult;

  final List<IngredientModel> ingredients;
  final List<StepModel> steps;
  final List<String> tags;

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
    );
  }

  @override
  List<Object?> get props => [
    ingredients,
    steps,
    imageFile,
    serves,
    tags,
    selectedQuantitySymbol,
    selectedPrivacyStatus,
    loadingResult,
  ];

  CreateRecipeState copyWith({
    DelayedResult<void>? loadingResult,
    List<IngredientModel>? ingredients,
    List<StepModel>? steps,
    List<String>? tags,
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
      selectedQuantitySymbol:
          selectedQuantitySymbol ?? this.selectedQuantitySymbol,
      selectedPrivacyStatus:
          selectedPrivacyStatus ?? this.selectedPrivacyStatus,
      serves: serves ?? this.serves,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}
