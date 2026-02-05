import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/models/local_ingredient_model.dart';
import '../../../../core/data/services/ingredient_service.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/ui/custom/buttons/wide_text_button.dart';
import '../../../../core/ui/custom/fields/my_dropdown_field.dart';
import '../../../../core/ui/custom/fields/my_form_field.dart';
import '../../../../core/utils/extensions.dart';
import '../../../bloc/create_recipe/create_recipe_cubit.dart';
import '../../../data/models/ingredient_model.dart';

class CreateIngredientSheet extends StatefulWidget {
  final void Function(IngredientModel i) onConfirm;
  final CreateRecipeCubit cubit;
  final int currentIndex;
  const CreateIngredientSheet({
    super.key,
    required this.onConfirm,
    required this.cubit,
    required this.currentIndex,
  });

  @override
  State<CreateIngredientSheet> createState() => _CreateIngredientSheetState();
}

class _CreateIngredientSheetState extends State<CreateIngredientSheet> {
  final TextEditingController _quantityCont = TextEditingController();
  final TextEditingController _costCont = TextEditingController();

  void _addIngredient() {
    final localIngredient = widget.cubit.state.selectedIngredient!.id;

    final String name = localIngredient.ingredientName;
    final String quantity = _quantityCont.trimmedText;
    final String cost = _costCont.trimmedText;
    final symbol = widget.cubit.state.selectedQuantitySymbol;

    if (name.isEmpty || quantity.isEmpty || cost.isEmpty || symbol == null) {
      return;
    }

    final IngredientModel ingredient = IngredientModel(
      id: widget.currentIndex + 1,
      name: name,
      quantity: quantity,
      quantitySymbol: symbol.value,
      cost: cost,
    );

    widget.onConfirm(ingredient);

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    CreateRecipeState state = widget.cubit.state;
    LocalIngredients localIngredients = GetIt.I<LocalIngredients>();

    return BlocProvider.value(
      value: widget.cubit,
      child: Column(
        spacing: 10,
        children: [
          const AppText.heading(text: 'Add Ingredient', size: 18),
          const SizedBox(),
          MyDropdownButton<LocalIngredientModel>.search(
            title: 'Ingredient Name',
            value: '',
            hint: 'Your ingredient\'s name',
            onChanged: (s) {
              widget.cubit.updateSelectedIngredient(s);
            },
            items: localIngredients.searchItems,
            // items: localIngredients.ingredients,
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: MyFormField(
                  hint: 'Your ingredient\'s quantity',
                  title: 'Quantity',
                  controller: _quantityCont,
                  keyboardType: const TextInputType.numberWithOptions(),
                ),
              ),
              Expanded(
                child: BlocBuilder<CreateRecipeCubit, CreateRecipeState>(
                  builder: (context, state) {
                    LocalIngredientModel? ingredient =
                        state.selectedIngredient?.id;

                    return MyDropdownButton<String>(
                      menuHeight: 175,
                      title: 'Symbol',
                      value: state.selectedQuantitySymbol,
                      initialValue: state.selectedQuantitySymbol,
                      hint: 'Symbol',
                      onChanged: (s) {
                        widget.cubit.updateSymbol(s);
                      },
                      items: [
                        const CustomDropdownValue<String>(id: '1', value: 'mg'),
                        const CustomDropdownValue<String>(id: '2', value: 'g'),
                        const CustomDropdownValue<String>(id: '3', value: 'kg'),
                        const CustomDropdownValue<String>(id: '4', value: 'ml'),
                        const CustomDropdownValue<String>(id: '5', value: 'l'),
                        if (ingredient?.unitDescription != null)
                          CustomDropdownValue<String>(
                            id: '6',
                            value: ingredient!.unitDescription!,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          MyFormField(
            hint: 'Your ingredient\'s cost',
            title: 'Cost',
            controller: _costCont,
            keyboardType: const TextInputType.numberWithOptions(),
          ),
          const SizedBox(),
          WideTextButton(text: 'Add Ingredient', onTap: _addIngredient),
        ],
      ),
    );
  }
}
