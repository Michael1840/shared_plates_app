import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/data/models/delayed_result.dart';
import '../../../core/ui/custom/fields/my_dropdown_field.dart';
import '../../../core/utils/extensions.dart';
import '../../data/models/ingredient_model.dart';
import '../../data/models/step_model.dart';

part 'create_recipe_state.dart';

class CreateRecipeCubit extends Cubit<CreateRecipeState> {
  CreateRecipeCubit() : super(CreateRecipeState.initial());

  void incrementServes() => emit(state.copyWith(serves: state.serves + 1));

  void decrementServes() =>
      state.serves > 0 ? emit(state.copyWith(serves: state.serves - 1)) : null;

  void updateSymbol(CustomDropdownValue value) =>
      emit(state.copyWith(selectedQuantitySymbol: value));

  void updatePrivacy(CustomDropdownValue value) =>
      emit(state.copyWith(selectedPrivacyStatus: value));

  void updateTitle(String value) => emit(state.copyWith(title: value));

  void updateDescription(String value) =>
      emit(state.copyWith(description: value));

  void updateCategory(String value) => emit(state.copyWith(category: value));

  void updateDiet(String value) => emit(state.copyWith(diet: value));

  void updateCuisine(String value) => emit(state.copyWith(cuisine: value));

  void updateTags(String t) => emit(state.copyWith(tags: [t, ...state.tags]));

  void updateIngredients(IngredientModel i) =>
      emit(state.copyWith(ingredients: [...state.ingredients, i]));

  void deleteIngredient(IngredientModel i) {
    final List<IngredientModel> ingredients = List.from(state.ingredients);

    ingredients.removeWhere((ingredient) => ingredient.id == i.id);

    emit(state.copyWith(ingredients: ingredients));
  }

  void updateSteps(StepModel s) =>
      emit(state.copyWith(steps: [...state.steps, s]));

  void deleteStep(StepModel s) {
    final List<StepModel> steps = List.from(state.steps);

    steps.removeWhere((step) => step.stepIndex == s.stepIndex);

    emit(state.copyWith(steps: steps));
  }

  void selectImage() async {
    ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      File? imageFile = File(file.path);

      emit(state.copyWith(imageFile: imageFile));
    }
  }
}
