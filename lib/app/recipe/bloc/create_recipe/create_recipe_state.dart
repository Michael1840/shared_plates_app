// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_recipe_cubit.dart';

class CreateRecipeState extends Equatable {
  final DelayedResult<void> loadingResult;

  final List<IngredientModel> ingredients;
  final List<StepModel> steps;

  final CustomDropdownValue? selectedQuantitySymbol;

  final File? imageFile;

  bool get isLoading => loadingResult.isInProgress;
  bool get isError => loadingResult.isError;

  const CreateRecipeState({
    required this.ingredients,
    required this.steps,
    this.selectedQuantitySymbol,
    this.imageFile,
    required this.loadingResult,
  });

  factory CreateRecipeState.initial() {
    return const CreateRecipeState(
      ingredients: [],
      steps: [],
      loadingResult: DelayedResult.idle(),
    );
  }

  @override
  List<Object?> get props => [
    ingredients,
    steps,
    imageFile,
    selectedQuantitySymbol,
    loadingResult,
  ];

  CreateRecipeState copyWith({
    DelayedResult<void>? loadingResult,
    List<IngredientModel>? ingredients,
    List<StepModel>? steps,
    CustomDropdownValue? selectedQuantitySymbol,
    File? imageFile,
  }) {
    return CreateRecipeState(
      loadingResult: loadingResult ?? this.loadingResult,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      selectedQuantitySymbol:
          selectedQuantitySymbol ?? this.selectedQuantitySymbol,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}
