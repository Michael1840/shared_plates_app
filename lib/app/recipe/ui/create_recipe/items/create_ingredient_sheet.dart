import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  final TextEditingController _nameCont = TextEditingController();
  final TextEditingController _quantityCont = TextEditingController();
  final TextEditingController _costCont = TextEditingController();

  void _addIngredient() {
    final String name = _nameCont.trimmedText;
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
    return Column(
      spacing: 10,
      children: [
        const AppText.heading(text: 'Add Ingredient', size: 18),
        const SizedBox(),
        MyFormField(
          hint: 'Your ingredient\'s name',
          title: 'Ingredient Name',
          controller: _nameCont,
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: MyFormField(
                hint: 'Your ingredient\'s quantity',
                title: 'Quantity',
                controller: _quantityCont,
              ),
            ),
            Expanded(
              child: MyDropdownButton(
                title: 'Symbol',
                value: '',
                hint: 'Symbol',
                onChanged: (s) {
                  widget.cubit.updateSymbol(s);
                },
                items: const [
                  CustomDropdownValue(id: 1, value: 'mg'),
                  CustomDropdownValue(id: 2, value: 'g'),
                  CustomDropdownValue(id: 3, value: 'kg'),
                  CustomDropdownValue(id: 4, value: 'ml'),
                  CustomDropdownValue(id: 5, value: 'l'),
                  CustomDropdownValue(id: 6, value: 'item(s)'),
                ],
              ),
            ),
          ],
        ),
        MyFormField(
          hint: 'Your ingredient\'s cost',
          title: 'Cost',
          controller: _costCont,
        ),
        const SizedBox(),
        WideTextButton(text: 'Add Ingredient', onTap: _addIngredient),
      ],
    );
  }
}
