import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/data/models/delayed_result.dart';
import '../../../core/ui/custom/fields/my_dropdown_field.dart';
import '../../data/models/ingredient_model.dart';

part 'create_recipe_state.dart';

class CreateRecipeCubit extends Cubit<CreateRecipeState> {
  CreateRecipeCubit() : super(CreateRecipeState.initial());

  void updateSymbol(CustomDropdownValue value) =>
      emit(state.copyWith(selectedQuantitySymbol: value));

  void updateIngredients(IngredientModel i) =>
      emit(state.copyWith(ingredients: [i, ...state.ingredients]));

  void selectImage() async {
    ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      File? imageFile = File(file.path);

      emit(state.copyWith(imageFile: imageFile));
    }
  }
}
